Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYGIU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYGIU6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbYGIU4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:56:46 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:38184 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbYGIU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:45 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, macro@linux-mips.org
Subject: Re: 2.6.25.9: system clocks works normally then speeds up 4x...
References: <87d4lm2792.fsf@old-tantale.fifi.org>
	<1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
	<874p6y25es.fsf@old-tantale.fifi.org>
	<1215634125.6149.8.camel@localhost.localdomain>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 09 Jul 2008 13:53:32 -0700
In-Reply-To: <1215634125.6149.8.camel@localhost.localdomain>
Message-ID: <87wsjuzsmr.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:

> On Wed, 2008-07-09 at 13:01 -0700, Philippe Troin wrote:
> > "john stultz" <johnstul@us.ibm.com> writes:
> > 
> > > On Wed, Jul 9, 2008 at 12:21 PM, Philippe Troin <phil@fifi.org> wrote:
> > > >
> > > > Symptoms:
> > > >
> > > >  The system boots fine. Clock seems to run normally.
> > > >
> > > >  Then after a random amount of time (on the current boot, 3 days),
> > > >  clock starts to be running 2-4x faster (on the current boot, 4x).
> > > >
> > > >  I have tried booting with "nohz=off highres=off" but it does not
> > > >  help.
> > > 
> > > Could you provide the output from the following:
> > >    sudo cat /sys/devices/system/clocksource/clocksource0/*
> > 
> > Sure.
> > 
> > It is:
> > available: jiffies tsc 
> > current:   jiffies
> > 
> > > Did this issue occur with 2.6.24 or earlier kernels?
> > 
> > No.  It started with 2.6.25.
> > 
> > Interestingly:
> > 
> >   I've just modified the current clocksource to tsc and the clock went
> >   back to its normal speed.
> > 
> >   Then I reset the current clocksource to jiffies, and the clock went
> >   back to its (wrong) 4x speed.
> > 
> > So it looks like the kernel is counting jiffies 4x too fast.
> 
> When you're seeing the issue, can you do the following:
>   cat /proc/interrupts > interrupts
> 
>   <wait 10 seconds by your wristwatch> 
> 
>   cat /proc/interrupts >> interrupts
> 
> And send the results?

There you are:

           CPU0       CPU1
  0:        353          0   IO-APIC-edge      timer
  1:          0          8   IO-APIC-edge      i8042
  2:          0          0    XT-PIC-XT        cascade
  3:          0          2   IO-APIC-edge
  4:      32796         68   IO-APIC-edge      serial
  8:          1          0   IO-APIC-edge      rtc
 14:     665397      37592   IO-APIC-edge      pata_via
 15:          0          0   IO-APIC-edge      pata_via
 16:   11417314     784937   IO-APIC-fasteoi   ohci_hcd:usb2, aic7xxx,
  firewire_ohci
 17:   11695442    1165240   IO-APIC-fasteoi   ohci_hcd:usb3, eth1
 18:   14967468    1533627   IO-APIC-fasteoi   ehci_hcd:usb1, eth0
 19:    1526542     363432   IO-APIC-fasteoi   uhci_hcd:usb4, eth2
NMI:          0          0   Non-maskable interrupts
LOC:  546305845   33155722   Local timer interrupts
RES:    4502087    5460357   Rescheduling interrupts
CAL:     816244    3856944   function call interrupts
TLB:     604097    1266758   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

Roughly 10 seconds later:

           CPU0       CPU1
  0:        353          0   IO-APIC-edge      timer
  1:          0          8   IO-APIC-edge      i8042
  2:          0          0    XT-PIC-XT        cascade
  3:          0          2   IO-APIC-edge
  4:      32796         68   IO-APIC-edge      serial
  8:          1          0   IO-APIC-edge      rtc
 14:     665481      37592   IO-APIC-edge      pata_via
 15:          0          0   IO-APIC-edge      pata_via
 16:   11417335     784937   IO-APIC-fasteoi   ohci_hcd:usb2, aic7xxx,
  firewire_ohci
 17:   11695614    1165240   IO-APIC-fasteoi   ohci_hcd:usb3, eth1
 18:   14967672    1533627   IO-APIC-fasteoi   ehci_hcd:usb1, eth0
 19:    1526542     363432   IO-APIC-fasteoi   uhci_hcd:usb4, eth2
NMI:          0          0   Non-maskable interrupts
LOC:  546361653   33156517   Local timer interrupts
RES:    4502100    5460379   Rescheduling interrupts
CAL:     816244    3856944   function call interrupts
TLB:     604097    1266758   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
 
> Could you also try booting with noapic to see if that changes anything?

Sure.  This will mean I will lose the "wedged" system.  Is there
anything else that needs to be checked on it before I lose the broken
state?
Also keep in mind that the symptoms take a while to manifest
themselves (a few days typically).

Phil.
