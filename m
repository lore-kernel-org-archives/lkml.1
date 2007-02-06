Return-Path: <linux-kernel-owner+w=401wt.eu-S965377AbXBFTbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377AbXBFTbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXBFTbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:31:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:15206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965375AbXBFTbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TFpRs0Vraye1YYU8K1pZvE1tQgodqVv4BUw0CEu8LEk2oBb0unZpdgA5udxTMS8A/vkX9ZdIWTaBOtfNbPivvUj6ozsyOKBlrL8RZVtpklwwLuPbjnY5DMm1Y+hYdlg122Yu5ycR4Z9/eZoFcrjKYGXEpBZyA86ddZ1RKf4lapc=
Message-ID: <3efb10970702061131o6696c76h5b0ab8b6a6a7422b@mail.gmail.com>
Date: Tue, 6 Feb 2007 20:31:18 +0100
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: j-almeida@criticalsoftware.com
Subject: Re: IRQ Sharing
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702061854.15320.j-almeida@criticalsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702061801.58465.j-almeida@criticalsoftware.com>
	 <3efb10970702061043m43f5b3eelfa24fbb95721acb4@mail.gmail.com>
	 <200702061854.15320.j-almeida@criticalsoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jorge,

AFAIK, if the lines are really hardwired, you can never seperate them,
as there is no way to detect which device generated the interrupt,
other than executing the interrupt handler of both devices. Only the
driver can tell by checking the interrupt status registers of the
device.
A piece of hardware that has no knowledge about the devices, can not
distinguish the source, you have to look in the device registers to
check if that device has generated the interrupt.

But, Interrupt lines that are NOT hardwired to each other, can still
be mapped (e.g. by BIOS) to the same virtual interrupt lines. In that
case they can be seperated by configuring the hardware. But, if you
already use the LAPIC and IOAPIC, my experience is that the lines are
already seperated as much as possible, but you have to verify that.

I had similar problems in the past, and as I am using the RT-kernel, I
have threaded interrupts. I implemented a real-interrupt tophalf
(IRQF_NODELAY flag) that is capable of detecting the source of the
interrupt, and wakes the corresponding high-priority kernel thread
that handles the interrupt. All within a few microseconds latency.

When it comes to sharing with other devices I have made the choice to
close down 1 USB controller that shared the interrupt with my
IO-board. USB still works in my case, but 1 onboard
controller/connector is dead)

Kind Regards,

Remy


2007/2/6, Jorge Almeida <j-almeida@criticalsoftware.com>:
> Em Tuesday, 6 de February de 2007 18:43, o Remy Bohmer escreveu:
> > Hello Jorge,
> Hello Remy,
> >
> > It is not uncommon that interrupt lines are hardwired to each other on
> > a standard PC-board.
> > Therefor it is not always feasible to get rid of interrupt sharing.
> > Especially on-board USB adapters can easily use up to 5 interrupt
> > lines on a standard main-board. Also, sharing of interrupt lines (by
> > hardwiring them) between on-board devices and PCI slots is also common
> > practice.
> >
> > The PCI specification explicitly states that PCI devices can share
> > interrupt lines, and that your drivers must be capable of handling
> > this.
> >
> > Why is sharing a problem for you?
> >
> > If you do not have special realtime requirements, it usually should be
> > no problem...
>
> Thats the problem.
> I have real time requirements.
>
> The physic IRQ line can be shared, the only thing i need is the virtual IRQ to
> be different for each device.
> This way my real-time drivers already work great :)
>
> So i need to change the APIC way of distribute virtual IRQs.
>
> Jorge
>
> >
> >
> > Remy
> >
> >
> > 2007/2/6, Jorge Almeida <j-almeida@criticalsoftware.com>:
> > >
> > > Hello to all.
> > >
> > > I'm running an application that uses several IO boards in a PCI bus.
> > >
> > > My main problem is the virtual IRQ sharing between several boards.
> > > I mean for example:
> > >         1 ethernet board IRQ = 169;
> > >         1 ADC card IRQ         = 169;
> > >
> > > I want to get ride of this behaviour, and changing the slot position of
> each
> > > board is not enought, to get something like (for example):
> > >         1 ethernet board IRQ = 169;
> > >         1 ADC card IRQ         = 170;
> > >
> > > Where in the kernel i can see the algorithms for the APIC system where the
> > > virtual IRQs are distributed? Or exist already any patch that permits to
> > > solve my problem?
> > >
> > > I'm using kernel 2.6.16.27, in a single machine with Intel pentium IV
> > > processor and chipset ICH4.
> > >
> > > Thanks for any reply.
> > > Greetings.
> > >
> > > --
> > > Jorge Almeida
> > > j-almeida@criticalsoftware.com
> > > DISCLAIMER: This message may contain confidential information or
> privileged material and is intended only for the individual(s) named. If you
> are not a named addressee and mistakenly received this message you should not
> copy or otherwise disseminate it: please delete this e-mail from your system
> and notify the sender immediately. E-mail transmissions are not guaranteed to
> be secure or without errors as information could be intercepted, corrupted,
> lost, destroyed, arrive late or incomplete or contain viruses. Therefore, the
> sender does not accept liability for any errors or omissions in the contents
> of this message that arise as a result of e-mail transmissions. Please
> request a hard copy version if verification is required. Critical Software,
> SA.
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
> --
> Jorge Almeida
> j-almeida@criticalsoftware.com
> DISCLAIMER: This message may contain confidential information or privileged material and is intended only for the individual(s) named. If you are not a named addressee and mistakenly received this message you should not copy or otherwise disseminate it: please delete this e-mail from your system and notify the sender immediately. E-mail transmissions are not guaranteed to be secure or without errors as information could be intercepted, corrupted, lost, destroyed, arrive late or incomplete or contain viruses. Therefore, the sender does not accept liability for any errors or omissions in the contents of this message that arise as a result of e-mail transmissions. Please request a hard copy version if verification is required. Critical Software, SA.
>
