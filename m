Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbYFFTXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbYFFTXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYFFTXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:23:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:10160 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYFFTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SoNT2wRZ7STzjP03+V/BmlMCNWtmT//cFlXeLvhrxtck7huvIQuFAkLh/OCd5BgJg+
         hF6IHBdUK53LhpNg1JdhHMredpahoHU1TUC4YdFWS5Fx/KQaBi1Kmsw0P5ZaJOzl1zBE
         bh+L4ARJOPThfNc8KsgO+zLoWsKhE9EYi5NSA=
Message-ID: <c384c5ea0806061223k44a7db74hbdf2ed6f422442b2@mail.gmail.com>
Date: Fri, 6 Jun 2008 21:23:38 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: Locking in the (now generic) GPIO infrastructure?
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806060553.48057.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
	 <200806060553.48057.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, all,

On Fri, Jun 6, 2008 at 2:53 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 04 June 2008, Leon Woestenberg wrote:
>> include/asm-arm/arch-ixp4xx/platform.h:
>> static inline void gpio_line_set(u8 line, int value)
>> {
>>         if (value == IXP4XX_GPIO_HIGH)
>>             *IXP4XX_GPIO_GPOUTR |= (1 << line);
>>         else if (value == IXP4XX_GPIO_LOW)
>>             *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
>> }
>>
>> Under a Linux kernel where multiple drivers are accessing GPIO, the
>> latter does not seem safe against preemption (assuming the memory
>> read-modify-write is not atomic).
>>
>> Shouldn't GPIO access be protected against concurrent access here?
>
> Well, against an IRQ in the middle of those read/modify/write
> sequences hidden by the "|=" and "&=" syntax.  Last I knew,
> no XScale CPUs support on-chip SMP.
>
Indeed, however, I used a kernel with -rt patch (and using PREEMPT RT)
as mentioned in my original e-mail. For completeness I should have
stated this:

The interrupt handlers become kernel threads.
As such they become preemptable (to reduce latencies for any higher
priority threads, such as those from other interrupts or even RT user
tasks).

>> Documentation/gpio.txt does not really mention the locking mechanism
>> assumed to modify GPIO lines.
>
> That function isn't part of the GPIO interface, despite
> its gpio_* prefix, so that's not relevant.
>
> It resembles gpio_set_value() though.  That can use at
>
In fact, on the IXP4xx, gpio_set_value() is just gpio_line_set(), so I
think it is valid to understand where the locking should occur (lowest
level, higher level?)

> most spinlocks to establish its atomicity guarantee; it's
> described as "spinlock-safe", and in distinction to the
> gpio_set_value_cansleep() call which could use a mutex or
> other sleeping synch primitive.
>

So, the solution (for the upstream work on -rt) would be to add
spinlock protection to gpio_line_set(), mutex protection for
_cansleep() variants?

Regards,
-- 
Leon
