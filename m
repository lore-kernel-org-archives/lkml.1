Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYGGBhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYGGBhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 21:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYGGBg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 21:36:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:23119 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYGGBg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 21:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b9EcbrOXXbqaeU3VTsOjqOidJvohWfXSfOVyk6e/ZOAhuOaDC5V4LpHLzHXJKEWyjf
         xO65TUWlnp0b9EfiGr0kekMEKlv+fjPF4BCav6Acqejic1AaBneBo5frrQS7wH+RIdwP
         nRLsH/Ni9ouTdwWueKqgF1CHGb1ejM8DmUnac=
Message-ID: <aec7e5c30807061836k2fb03fb8uc1dd5df482326c07@mail.gmail.com>
Date: Mon, 7 Jul 2008 10:36:53 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode V2
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, lethal@linux-sh.org, tglx@linutronix.de,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080706122743.GA3198@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705042121.4647.29429.sendpatchset@rx1.opensource.se>
	 <20080706122743.GA3198@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thank you very much for your clear and constructive email!

On Sun, Jul 6, 2008 at 9:27 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Sat, Jul 05, 2008 at 01:21:21PM +0900, Magnus Damm wrote:
>> This is V2 of the UIO "User IRQ Mode" patch.

> We already have Uwe's uio_pdrv. It allows generic handling of UIO
> platform devices by defining struct uio_info and the irq handler
> together with struct platform_device in board support. An irqcontrol()
> function can optionally be defined if needed.
>
> Your idea takes this one step further. You say we can even omit the irq
> handler and the irqcontrol() function if we know that the platform
> devices's irq is not shared. We can then replace both functions with
> generic ones using disable_irq_nosync(). As a consequence, the userspace
> part of the driver must reenable the interrupt using write().
>
> As this is a special version of uio_pdrv, it should be implemented in a
> similar way. I suggest calling it uio_pdrv_genirq because the difference
> to uio_pdrv is that irqs are handled in a generic way in the kernel (as
> I already said, I find the term "User IRQ mode" misleading).

Absolutely. I don't have any strong opinions about names, but of all
the ideas so far I like "genirq" the most.

> uio_pdrv_genirq would be quite similar to uio_pdrv, with the following
> differences:
>
> - Its probe() function should fail if either (*handler) or (*irqcontrol)
>  is not NULL, because obviously the user didn't get the idea.

Since you want to check these parameters, I suggest the two functions
_and_ irq_flags.

> - It should instead fill in the generic functions from your patch below.
>  These can be implemented in uio_pdrv_genirq.c, no need to patch them
>  into the UIO core header file.

That's fine.

> - The Kconfig help text should state clearly that this only works for
>  non-shared interrupts. Maybe it should be disabled on x86.

I'd prefer to have in enabled on all architectures, but I don't have
any strong opinion about it. If you'd like we can start by enabling it
on SuperH and whatever platform Uwe is using, and after that we can
just add other architectures later on whenever needed.

> One of your first implementations of that idea patched it into uio_pdrv.
> I didn't like this because it adds stuff that doesn't work on every
> platform to something that does. Although uio_pdrv and uio_pdrv_genirq
> would share some code, I find it justified to have two separate
> implementation files, as both differ in platform dependencies and
> possible use cases. Having two separate drivers clearly shows a user
> which choices he has. Trying to save a few lines by putting it all in
> one file would mainly add confusion and #ifdefs.

I agree, two separate drivers sounds good.

> Implementing it this way, we also have the advantage that we don't have
> to change any existing UIO core files (aside from adding the "flags"
> element to struct uio_info, which is OK for me).
>
> If you implemented it like this, uio_pdrv_genirq would become a part of
> the UIO framework, and I'd explain it in the docs (I need to describe
> uio_pdrv there anyway).
>
> Would this approach be acceptable to you? If yes, please send a patch, I
> think it can be merged soon.

Sure!

> Sorry I didn't have that idea earlier. I didn't feel well rejecting your
> implementations without having something better to offer. I really hope
> we can settle it this way.
>
> Thanks for your contributions and patience,

No problem. Thank you for helping out, and sorry for shouting at you.

I'll post a new version in little bit.

/ magnus
