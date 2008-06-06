Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYFFMyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYFFMyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYFFMxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:53:51 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:32187 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752016AbYFFMxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:53:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o63d8HunSFSFfNhuxcorpFw65tkzT9fZd4p0+LLPRD7aJDDAwomdFwafhnjdyHfYMOscAzwyRFiNU0fu8v5PrKAfpMKfuLiQ3X9cXqzEidbRj9I8fh0UTU6wYotvRDfMOvgrrxnEu0X/u4VG3pp4SlPuZA58laIskRo6aHlF3sA=  ;
X-YMail-OSG: Pex4baMVM1lNSXhkxFXTZKmC_x0bIELT5SGPOLv0iX3uycCYApeXh5RRy3cj9kfSL9TpHmOe3Ea_MsP.HxssAANgBRIsY1xpOxTZGhP832gtd5WDxi3izOnHqljGlj7nmWY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Locking in the (now generic) GPIO infrastructure?
Date: Fri, 6 Jun 2008 05:53:47 -0700
User-Agent: KMail/1.9.9
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
References: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
In-Reply-To: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806060553.48057.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008, Leon Woestenberg wrote:
> include/asm-arm/arch-ixp4xx/platform.h:
> static inline void gpio_line_set(u8 line, int value)
> {
>         if (value == IXP4XX_GPIO_HIGH)
>             *IXP4XX_GPIO_GPOUTR |= (1 << line);
>         else if (value == IXP4XX_GPIO_LOW)
>             *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
> }
> 
> Under a Linux kernel where multiple drivers are accessing GPIO, the
> latter does not seem safe against preemption (assuming the memory
> read-modify-write is not atomic).
> 
> Shouldn't GPIO access be protected against concurrent access here?

Well, against an IRQ in the middle of those read/modify/write
sequences hidden by the "|=" and "&=" syntax.  Last I knew,
no XScale CPUs support on-chip SMP.


> Documentation/gpio.txt does not really mention the locking mechanism
> assumed to modify GPIO lines.

That function isn't part of the GPIO interface, despite
its gpio_* prefix, so that's not relevant.

It resembles gpio_set_value() though.  That can use at
most spinlocks to establish its atomicity guarantee; it's
described as "spinlock-safe", and in distinction to the
gpio_set_value_cansleep() call which could use a mutex or
other sleeping synch primitive.

