Return-Path: <linux-kernel-owner+w=401wt.eu-S965212AbZLHAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965212AbZLHAa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965161AbZLHAa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:30:26 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44435 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961AbZLHAaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:30:25 -0500
Subject: RE: timer interrupt stucks using tickless kernel
From: john stultz <johnstul@us.ibm.com>
To: Ioannis Kyriakopoulos <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <SNT111-DS1740657A3615A93A6C0EDFA78F0@phx.gbl>
References: <Acp3UXhD1R6mbV5yTGykTs+HAU6bQg==>
	 <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl>
	 <1f1b08da0912071330i35808790r554f7a3a8d712ca7@mail.gmail.com>
	 <SNT111-DS1740657A3615A93A6C0EDFA78F0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 16:30:12 -0800
Message-ID: <1260232212.6255.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 00:18 +0000, Ioannis Kyriakopoulos wrote:
> >> I have configured my kernel (2.6.31.6) so that I get periodic ticks from
> >> the timer interrupt (i.e. tickless is not configured) with a rate
> determined
> >> by the HZ value. I've also checked the "high resolution timer support"
> >> and also SMP support. The posblem is that the timer is getting
> incremented
> >> very slowly (way slower than the HZ value), just like it would be if the
> >> kernel was tickless. Is there an explanation for that? How can I get
> >> periodic
> >> timer ticks?
> >>
> >> AFAI understand, the HPET timer is used through the IO-APIC controller to
> >> trigger the processors (N.B. if the "High Resolution Timer Support"
> option
> >> wasn't checked, the timer used would  be PIT, right?) and each
> processor's
> >> LAPIC timer is used for time keeping. Please correct me if I am wrong.
> >
> >Not quite, if High Resolution Timers support was disabled, you would
> >still use the HPET hardware instead of the pit, but you'd stay in
> >periodic mode. However, since you have Highres Timers on, the system
> >is using oneshot mode (which is necessary to trigger interrupts faster
> >then HZ), and likely has chosen the LAPIC timer as the interrupt
> >source.
> >
> >In this case, the timer tick becomes an hrt event, that triggers every
> >HZ, instead of being caused by a periodic interrupt.
> 
> OK, so I configured the kernel as follows, expecting to have periodic 
> interrupts by the HPET timer using the PIC controller using only a single
> processor (UP configuration). 
> 
> Unselected: 
> Tickless System (Dynamic Ticks)
> High Resolution Timer Support  
> Symmetric multi-processing support 
> IO-APIC support on uniprocessors (NEW)
> 
> Selected: 
> Local APIC support on uniprocessors
> HPET timer support
>  
> However, when I ran /proc/interrupts, I noticed many weird things:
> 1.	The timer is still not getting incremented at a rate determined by
> HZ.

Right, the system has switched to using the local apic instead of the
PIT or HPET (connected to irq0).


> 2.	When performing cat proc/interrupts, I see that:
>           0:        157   IO-APIC-edge      timer
> 	How the system timer is attached on IO-APIC at the time that the
> IO-APIC 
>       is disabled on kernel configurations? Basically, the timer is not the
> only
>       peripheral attached to IO-APIC as can be seen by /proc/interrupts.
> 
> Here is the output of /proc/interrupts :
> 
>            CPU0
>   0:        157   IO-APIC-edge      timer
>   1:          2   IO-APIC-edge      i8042
>   4:        544   IO-APIC-edge      serial
>   8:          1   IO-APIC-edge      rtc0
>   9:          0   IO-APIC-fasteoi   acpi
>  12:          4   IO-APIC-edge      i8042
>  14:          4   IO-APIC-edge      ata_piix
>  15:          0   IO-APIC-edge      ata_piix
>  16:          0   IO-APIC-fasteoi   uhci_hcd:usb5
>  18:          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  19:         45   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3
>  22:        149   IO-APIC-fasteoi   HDA Intel
>  23:         72   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
>  27:          0   PCI-MSI-edge      eth0
> NMI:          0   Non-maskable interrupts
> LOC:    1865130   Local timer interrupts
            ^^^
This value should be incrementing at HZ freq.


> SPU:          0   Spurious interrupts
> CNT:          0   Performance counter interrupts
> PND:          0   Performance pending work
> TRM:          0   Thermal event interrupts
> THR:          0   Threshold APIC interrupts
> MCE:          0   Machine check exceptions
> MCP:          7   Machine check polls
> ERR:          0
> MIS:          0
> 
> Is it that difficult to have periodic timer interrupts using HZ rate?

I suspect you already do. If you really want the interrupts to be coming
in via irq0, try booting w/ nolapic.

Is there something your actually having problems with here? Ignoring
which interrupt line is used for the timer event, the system is
functioning properly, right?

thanks
-john

