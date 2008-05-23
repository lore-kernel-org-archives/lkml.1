Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYEWInf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYEWInf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYEWInZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:43:25 -0400
Received: from www.tglx.de ([62.245.132.106]:60971 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYEWInW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:43:22 -0400
Date: Fri, 23 May 2008 10:43:05 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Magnus Damm" <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       lethal@linux-sh.org, gregkh@suse.de,
       "Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH 01/03] uio: Add enable_irq() callback
Message-ID: <20080523104305.45778bf2@bluebox.local>
In-Reply-To: <aec7e5c30805221824l5ecf0b53i1e1cce7c1c815912@mail.gmail.com>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
	<20080520105140.1474.59715.sendpatchset@rx1.opensource.se>
	<aec7e5c30805210458m3d15b89am563e4a94b8eb6f2c@mail.gmail.com>
	<20080522201829.GE3226@local>
	<aec7e5c30805221824l5ecf0b53i1e1cce7c1c815912@mail.gmail.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 23 May 2008 10:24:42 +0900
schrieb "Magnus Damm" <magnus.damm@gmail.com>:

> Hi Hans,
> 
> On Fri, May 23, 2008 at 5:18 AM, Hans J. Koch <hjk@linutronix.de>
> wrote:
> > On Wed, May 21, 2008 at 08:58:24PM +0900, Magnus Damm wrote:
> >> On Tue, May 20, 2008 at 7:51 PM, Magnus Damm
> >> <magnus.damm@gmail.com> wrote:
> >> > Add enable_irq() callback to struct uio_info. This callback is
> >> > needed by the uio_platform driver so interrupts can be enabled
> >> > before blocking.
> >>
> >> We can most likely use a single uio platform driver if this patch
> >> is acceptable. Any NAKs?
> >
> > Yes. Your approach only allows enabling interrupts, but not
> > disabling them. And I don't like that it is not possible for
> > generic userspace tools to find out if a UIO device has this
> > auto-irq-enabling capability or not.
> 
> Thanks for your effort. I understand that you need to enable and
> disable interrupts from user space, but that's a bit different from
> what I want to do. I just want interrupts to be enabled before I do
> read() or poll().

Are you sure this works cleanly? You usually do a read immediately
after poll, so you might get two interrupts when waiting with select().

> 
> Also, adding the capability of disabling and enabling interrupts from
> user space seems a bit error prone to me. Mainly since user space then
> needs to know that the interrupt handler in kernel space can cope with
> such changes. 

No, it doesn't. If the kernel driver doesn't implement the irqcontrol()
handler, write attempts will return an error.

> Not such a clean interface IMO. OTOH you may need that
> to cope with some broken hardware.

All of this talk is _only_ about broken hardware. Decent hardware has
seperate IRQ mask and status registers, in which case userspace has no
problems at all to deal with several internal interrupt sources of the
chip. We only need all this for chips where it is not possible to mask
an IRQ through a mappable register or (more often) where acknowledging
the interrupt also clears the status register so that userspace has no
way of knowing what the source of the interrupt was. The latter applies
only to chips with more than one internal irq source.

> 
> But why does user space need to know if the auto-irq-enabling function
> is there or not?

It doesn't, I just find it nice to have such a flag displayed in lsuio.

> If the user is interfacing to the wrong kernel UIO
> driver with wrong behavior then he has obviously done something wrong.
> Knowing if auto-irq-enabling is there from user space isn't going to
> save users from themselves. They can and will mix and match things in
> all sorts of wrong ways anyway.

Agreed.

> 
> > I just posted a patch that allows enabling _and_ disabling of irqs
> > from userspace by writing 0 or 1 to /dev/uioX. I've CCed you, could
> > you please test? If this doesn't do what you need, please let me
> > know.
> 
> I'm sure your patch or the ioctl suggestion both allow re-enabling
> interrupts from user space. That's great, but both of them add extra
> syscall overhead compared to my suggestion. They also make the user
> space interface in user space part of the driver a bit more
> complicated.

UIO deals with two things, device memory and interrupts. We have mmap()
for mem and read() for waiting for an irq. This looks clean and logical
to me:

1) mmap() => device memory
2) read()/write() => device irqs

> 
> I do understand that you don't want to mess up your UIO kernel
> callbacks by introducing just merging new ones all the time. OTOH, my
> patch is just a few lines. Is introducing one extra syscall good
> enough performance wise?

This doesn't seem to be a problem, really. This write() is straight
forward, without any wait queues etc, so what?

Thanks,
Hans

