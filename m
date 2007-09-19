Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXISMpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXISMpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXISMox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:44:53 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:36591 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753425AbXISMow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:44:52 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2007 13:21:08 +0200
MIME-Version: 1.0
Subject: Re: PCI Interrupt
Message-ID: <46F12244.22016.47D8DCD0@localhost>
In-reply-to: <20070919101430.GA3226@ff.dom.local>
References: <200709181642.23070.rjw@sisk.pl>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.12@11920:11921
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007 at 12:14, Jarek Poplawski wrote:
> On 18-09-2007 16:42, Rafael J. Wysocki wrote:
> > Hm, edge-triggered interrupts cannot be shared, AFAIK.
> > 
> Let's agree it's only a superstition...
> http://en.wikipedia.org/wiki/Edge_triggered_interrupt
> 
Superstition? Depends on how stringent your requirements are.

On IBM PC compatible hardware, there's always a risky "window of 
opportunity" that a shared edge-triggered interrupt line gets 
electrically re-triggered before your ISR manages to service all the 
devices and ACK the interrupt (I believe RTAI does that in reverse 
order). In that case, you get a missed interrupt, and your 
peripherial device may wait for service indefinitely.

I don't recall if the i8259 AT-pic has some useable "retrigger while 
in service" register, maybe the APIC does. (I do recall that the 
8259's two-register IO footprint is rather convoluted.) I seriously 
doubt that the presence of such a register would completely eliminate 
the critical window of time.

On PC hardware or in general, sharing edge-triggered interrupts can 
be perfectly allright under very specific conditions, if you know 
exactly what you're doing, e.g. you know that the collision of 
interrupt sources simply cannot occur (due to some characteristic 
sequencing of interrupt-generating events in the specific peripherial 
hardware), or you don't quite bother (in that case, why use an 
interrupt at all?).

You can certainly try to re-check your string of devices before 
finally ACKing, or set up supplemental timer-based periodic polling, 
but those are all kludgey workarounds that converge towards not using 
interrupts at all. I believe this is one of the reasons why e.g. ISA 
multi-port serial boards with a shared interrupt have been dropped 
from Linux 2.6 (vs. 2.4).

The fact that some ISA peripherials do respect the open-collector
convention, so that electrical sharing of the IRQ line is possible, 
doesn't help the ISR do the job in time. Even at the electric level, 
this rule is far from notorious. I've had the opportunity to write a 
driver for a special-purpose ISA board, where two different 
generations of the hardware treated the IRQ line very differently. If 
you use OC+pullup combined with active-low pulses of fixed length and 
trigger on the trailing edge of the interrupt pulse, you miss the 
moment of interrupt by a few bus clocks, which adds to your IRQ 
latency... If you (mis)treat the IRQ line as active high, so as to be 
able to send a rising edge exactly in sync with the interrupt event, 
you lose the electrical-level sharing capability.

All in all I'm glad that the PCI guarantees level-triggered 
interrupts, exactly because I don't have to worry much about the 
pesky details of IRQ sharing.

And I'm especially glad that PCIe+MSI (direct to LAPIC delivery)
will someday make IRQ sharing a matter of the past.
Note how modern PCIe-based PC's in "IO(x)APIC legacy-compatible mode" 
are still forcing most PCIe peripherials to share four (4) IRQ 
numbers, unless you take care to select your OS and drivers to 
support MSI on as many devices as possible...

Frank Rysanek

