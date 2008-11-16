Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYKPSDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYKPSDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYKPSCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:02:46 -0500
Received: from science.horizon.com ([192.35.100.1]:19160 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754566AbYKPSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:02:45 -0500
Message-ID: <20081116180244.5671.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 16 Nov 2008 13:02:44 -0500
To: tytso@mit.edu, linux@horizon.com
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
 order.
References: <20081113150308.3590.qmail@science.horizon.com>
 <20081114053042.11532.qmail@science.horizon.com>
 <20081114053314.12093.qmail@science.horizon.com>
 <20081114213449.14960.qmail@science.horizon.com>
 <20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
 <20081115001013.GM25117@mit.edu>
 <20081116152352.20261.qmail@science.horizon.com>
 <20081116162332.GC6958@mit.edu>
In-Reply-To: <20081116162332.GC6958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
>> The idea is that, if you have 4 ports sharing an interrupt, and the fourth
>> is the one that's busy, you'll check every port twice.  If you could check
>> the busy port first, you'd only need to to do 5 checks.
>
> Um, but the ISA bus was edge sensitive.  So presumably PC-104 would be
> as well.  So you *have* to scan all of the ports twice, because you
> want to keep the race window as narrow as possible.  If you don't
> service incoming characters for a previously idle port (because of the
> thought that you only have to check currently busy ports as an
> optimization), you'll never get an interrupt on that IRQ again, and
> you'll have to wait for the serial timeout to save you (and in the
> meantime, you'll likely be losing characters as the FIFO's overflow).

Er, no, you seem to be missing something.  You do NOT have to scan all
the ports twice.  You have to scan until you observe all ports idle.
So the minimum is to scan each busy port twice and each idle port once.
The only problem is that you have to observe all ports idle *at the same
time*, meaning that the "all ports idle" part of the scan starts after the
last busy port is found.

Doing this actually completely closes the race.  If you poll, in
succession, ports 1 though N, and observe them all not requesting
an interrupt, then you know there was an interval, between when you
serviced the last busy port and polled port 1, during which the IRQ line
was not asserted.

If this is confusing, I can expand the relevant comments further.

On Sun, Nov 16, 2008 at 10:23:52AM -0500, George Spelvin wrote:
>> The goal is not fewer dropped characters (although there could be a small
>> benefit in that direction), and it doesn't improve worst-case timing;
>> the goal is to reduce the time spent in the interrupt handler _on average_
>> and thereby make more CPU available for other work.

> Have you actually measured how much CPU is currently being burned by
> the interrupt handler?  And does it actually make a difference with
> your optimization?

No, I confess that I haven't.  I was playing with PPS timing code and
noticed the polling loop.  After studying it, it dawned on me that it
could be optimized further.

> I did a lot of measurements of this back in the day of the 40 MHz 386 and
> 16 serial ports running at 115kbps.  CPU's have gotten *so* much faster,
> and as you have pointed the out, the PCI bus accesses are also faster
> (and on the ISA bus, given edge-triggered interrupts, you have to scan
> all of the ports any way) --- so it's not obvious to me that it's actually
> worth it.

> There were programs to measure CPU overhead; they normally worked by
> doing a certain amount of work (i.e., seeing how many interations of
> some mathematical calculation) in a given amount of clock time both
> with and without the serial ports being busy.  It might be worthwhile
> to see whether for your workload how measurrable the CPU reduction
> really is, given modern hardware.  I'm not convinced given the number
> of Moore's law doublings since 1992, that it's really going to be
> worth it for a rational number of serial ports being serviced by a
> modern Linux machine.

I'll try to get some measurements, but the idea is that Moore's law has
dome wonders for CPU performance but has NOT sped up the PCI bus since
1992, so the cost in CPU cycles has actually gone up.  Even the ISA to
PCI bus transition wasn't that big an improvement, especially for
single-byte reads.  (The 16550D data sheet claims a minimum read cycle
time of 280 ns, maybe 3 cycles at 120 ns = 360 ns in practice, while a
PCI bus access to an OC16PCI954 is 5 PCI bus cycles, 150 ns)

Thus, it's worth more CPU effort to save I/O bus cycles.
