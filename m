Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYFHKDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYFHKDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYFHKDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:03:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:29498 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYFHKDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=soKNTi++GFT0VEAsWfP8B/qxOLvt3ssYfwkQhod68n22JgTxQffiP/bczljOoDeVnZ
         TqOKXHuW5QT2WI0HuuRFaoZvJYQ4E5bmfd17Qpllhm2HfxLYUby8X6oqI6wr2PK+8rEc
         p4YWqQ/c9gDVWsNgxa9/pK7XWsDuUsL0csdlo=
Message-ID: <aec7e5c30806080303i6d412d89o177e665bc3e8f38a@mail.gmail.com>
Date: Sun, 8 Jun 2008 19:03:39 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
       lethal@linux-sh.org, tglx@linutronix.de
In-Reply-To: <20080606100423.GA3213@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
	 <20080604101144.GA3207@local>
	 <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
	 <20080605064945.GA32554@digi.com>
	 <aec7e5c30806051955q5f812e41y9c2f322d98333232@mail.gmail.com>
	 <20080606100423.GA3213@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 7:04 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Fri, Jun 06, 2008 at 11:55:30AM +0900, Magnus Damm wrote:
>> On Thu, Jun 5, 2008 at 3:49 PM, Uwe Kleine-König
>> <Uwe.Kleine-Koenig@digi.com> wrote:
>> > Magnus Damm wrote:
>> >> ... "Unique IRQ Mode". ...
>> > BTW, I wouldn't call it "Unique IRQ Mode" because the non-shared irq is
>> > only a result from automatically disabling the irq.  IMHO something like
>> > "No IRQ Handler Mode" is more suitable.
>>
>> That may be a good idea. Any name is fine with me.
>>
>> Hopefully a better name will make people less confused. =)
>
> I didn't criticize the name. My objection is that you want to introduce
> an optional special handling for cases where the interrupt line is not
> shared, e.g. a GPIO line. In that case, the handler _could_ look like
> this:

First of all, I don't really see how this is related to GPIO. The
hardware blocks I'm exporting to user space are media accelerator
blocks - for instance providing hardware color space conversion. Any
type of device can be exported using this technique as long as it is
memory mapped and it comes with a unique interrupt.

> static irqreturn_t my_handler(int irq, struct uio_info *info)
> {
>        irq_disable(MY_GPIO_LINE);
>        return IRQ_HANDLED;
> }

Why did you remove the atomic_set()? I suggest that you try out the
code, or maybe even look at the irq_enable()/irq_disable()
implementation in kernel/irq/manage.c. Hint: the tricky part is
"desc->depth" in __enable_irq(). Basically, you shouldn't enable the
the interrupt more times than you disable it. So we need to keep track
of things and prevent user space from mucking up the depth for us.

> This solution is only second best, if possible, the irq should be
> properly acknowledged within the chip, but it could be done like this.

Of course the interrupt should be acknowledged at some point. It's
just a question of when and where you do that. I can't see the reason
of having device specific UIO code in kernel space when you can have a
generic kernel space driver and let user space do everything.

> Note that this doesn't work on every platform, it assumes that each GPIO
> line has its own irq number. (Did you ever think about fixing Kconfig so
> that this option is disabled on platforms where it is not possible or
> not sensible to do this?)

Is MY_GPIO_LINE a Kconfig option? Using the "irq" parameter makes more
sense for us since we want to have multiple platform UIO instances up
and running simultaneously.

Would you like me to wrap the above lines in #ifdefs?

> You now suggest that if somebody doesn't fill in an irq handler, we
> should make the above the default. This would save somebody the trouble
> to add the above 5 lines to the 30 lines of board/platform support code
> he has to write anyway. That's the only gain, and that is not enough.

But the code in this patch is reusable. Any platform that has a unique
interrupt assigned to a memory mapped device can just export it to
user space as a regular platform driver. No other kernel space code
needed.

Maybe 5 lines doesn't matter to you, but we want to use this for many
different devices. Maybe we'll start with 5 devices and work our way
from there.

We can of course just do this somewhere under the arch/sh tree, but
why should we make the code architecture specific when it's something
that many architectures can make use of?

> Giving it a different name doesn't make it better.

So exactly what makes it better?

Thank you.

/ magnus
