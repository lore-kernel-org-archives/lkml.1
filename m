Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGDHtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGDHtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 03:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYGDHsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 03:48:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:44143 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYGDHsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 03:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qpAeVheDplurVVNN0jfAm+huY5BfqXX4DXUs7wNIuZpFVeWl3grdep9GXOOgMGmiVS
         dUM/0bDXjrRf4eUDPZkTlPPXK6Knsn7E95MdsJ7hQJgjYX1r0Fzt+Aah2LhCVHQQ0y5k
         Oa012enWtAtxD4wWDZNg59lsy2yDXTVK2DCRM=
Message-ID: <aec7e5c30807040048yd8543d4n2edba43524279b6f@mail.gmail.com>
Date: Fri, 4 Jul 2008 16:48:53 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] uio: User IRQ Mode
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20080704060108.GA11794@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	 <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com>
	 <20080703124505.GB3197@local>
	 <aec7e5c30807032103p7626dcbdwe06c5fac461372c1@mail.gmail.com>
	 <20080704060108.GA11794@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 3:01 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Magnus Damm wrote:
>> On Thu, Jul 3, 2008 at 9:45 PM, Hans J. Koch <hjk@linutronix.de> wrote:
>> > On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-König wrote:
>> >> Hans J. Koch wrote:
>> >> > On Wed, Jul 02, 2008 at 07:59:51PM +0900, Magnus Damm wrote:
>> >> > > From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
>> >> > >
>> >> > > This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
>> >> > > is responsible for acknowledging and re-enabling the interrupt.
>> >> >
>> >> > This can easily be done without your patch.
>> >
>> > BTW, the above wording "the user space driver is responsible for
>> > acknowledging and re-enabling the interrupt" is misleading. The kernel
>> > always has to acknowledge/disable/mask the interrupt. Userspace can only
>> > reenable it, ideally by writing to a chip register. In some cornercases
>> > for broken hardware we need the newly introduced write function.
>>
>> You seem to be mixing up masking/acknowledging the interrupt
>> controller and masking/acknowledging the actual hardware device. In
>> User IRQ Mode, the only thing the user space driver is accessing is
>> the hardware device, with the exception of write() to re-enable
>> interrupts which results in a enable_irq() that touches the interrupt
>> controller.
> But to be honest Hans is right here, the commit log wording is not
> optimal.  I suggest:
>
>        This patch adds a "User IRQ Mode" to UIO. In this mode the
>        kernel space simply disables the serviced interrupt in the
>        interrupt controller and the user space driver is responsible
>        for acknowledging it in the device and reenabling it.

Right, that's better. Thank you.

>        Note that this implies that the interrupt might be disabled for
>        long periods, so this isn't usable for shared interrupt lines.

While I think it's a good idea to write that the interrupt latency
will be increased, I wouldn't say the above is clear enough.

Shared interrupts are not supported by the User IRQ Mode since the
generic in-kernel interrupt handler will disable the shared interrupt
line while servicing interrupts. Disabling the shared interrupt line
will prevent other devices sharing the same interrupt line from being
serviced properly. This fact makes User IRQ Mode unsuitable for shared
interrupts.

> Maybe it's sensible to add the User IRQ Mode functions at least for now
> into platform code.  Then at a later time if and when there are several
> copies the discussion to move it to the generic part might be easier.

Do you mean your uio_pdrv driver?

> BTW, I currently have a situation where it IMHO really makes sense to
> use the User IRQ Mode:  We sell a cpu module to a customer with
> Linux.  I provide a uio device for some memory mapped periphal on the
> customers board that I don't know in detail.  With the User IRQ Mode I
> only need to know the chip select and the irq line, no further
> information is needed for the device.

Yes, and this is a very similar to our requirements. We want to expose
various memory mapped devices inside our SoCs to user space, providing
only device base address and unique interrupt number.

Thank you!

/ magnus
