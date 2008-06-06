Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYFFK2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYFFK2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYFFK2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:28:39 -0400
Received: from trinity.fluff.org ([89.145.97.151]:40437 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYFFK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:28:38 -0400
Date: Fri, 6 Jun 2008 11:28:58 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Locking in the (now generic) GPIO infrastructure?
Message-ID: <20080606102858.GD14683@trinity.fluff.org>
References: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:00:19PM +0200, Leon Woestenberg wrote:
> Hello,
> 
> compare void gpio_line_set() in
> 
> arch/arm/plat-iop/gpio.c:
> void gpio_line_set(int line, int value)
> {
> 	unsigned long flags;
> 
> 	local_irq_save(flags);
> 	if (value == GPIO_LOW) {
> 		*IOP3XX_GPOD &= ~(1 << line);
> 	} else if (value == GPIO_HIGH) {
> 		*IOP3XX_GPOD |= 1 << line;
> 	}
> 	local_irq_restore(flags);
> }
> 
> with
> 
> include/asm-arm/arch-ixp4xx/platform.h:
> static inline void gpio_line_set(u8 line, int value)
> {
> 	if (value == IXP4XX_GPIO_HIGH)
> 	    *IXP4XX_GPIO_GPOUTR |= (1 << line);
> 	else if (value == IXP4XX_GPIO_LOW)
> 	    *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
> }

Yes, that looks rather buggy to me, and also sub-optimal to boot. The
u8 line should be changed to just 'unsigned' having the compiler truncate
to 8bit isn't useful when then used with a shift.

static inline void gpio_line_set(unsigned line, int value)
{
	unsigned long flags;
	unsigned regval;

	local_irq_save(flags);

	regval = *IXP4XX_GPIO_GPOUTR;

	if (value == IXP4XX_GPIO_HIGH)
		regval |= (1 << line);
	else if (value == IXP4XX_GPIO_LOW)
	   	regval &= ~(1 << line);

	*IXP4XX_GPIO_GPOUTR = regval;
	local_irq_restore(flags);
}
 
> Under a Linux kernel where multiple drivers are accessing GPIO, the
> latter does not seem safe against preemption (assuming the memory
> read-modify-write is not atomic).
> 
> Shouldn't GPIO access be protected against concurrent access here?
> 
> Documentation/gpio.txt does not really mention the locking mechanism
> assumed to modify GPIO lines.

I think it depends on whether gpiolib is being used or not, there may
be some locking in there.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

