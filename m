Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbZLPSUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbZLPSUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762747AbZLPSUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:20:39 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49464 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760443AbZLPSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:20:36 -0500
Date: Wed, 16 Dec 2009 21:20:34 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/7] spi/mpc8xxx: don't check platform_get_irq's return
 value against zero
Message-ID: <20091216182034.GA7590@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091216163229.GA26350@oksana.dev.rtsoft.ru>
 <20091216174904.GB26325@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091216174904.GB26325@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 06:49:04PM +0100, Uwe Kleine-König wrote:
[...]
> > Noooooo... :-(
> > 
> > Please revert 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 instead,
> > and fix platforms to remap HWIRQ0 to something that is not VIRQ0.
> > 
> > IRQ0 is invalid for everything that is outside of arch/*.
> > 
> > http://lkml.org/lkml/2005/11/22/159
> > http://lkml.org/lkml/2005/11/22/213
> > http://lkml.org/lkml/2005/11/22/227
> First note that my check is safe with both variants (e.g. it does the
> right thing independent of the error being signaled by 0 or
> -ESOMETHING.)
> 
> Then arch/arm/mach-pxa/devices.c has:
> 
> static struct resource pxa27x_resource_ssp3[] = {
> 	...
> 	[1] = {
> 		.start  = IRQ_SSP3,
> 		.end    = IRQ_SSP3,
> 		.flags  = IORESOURCE_IRQ,
> 	},
> 	...
> }
> 
> with IRQ_SSP3 being zero (sometimes).  The driver is implemented in
> arch/arm/mach-pxa/ssp.c and uses platform_get_irq.

So fix this *one* driver? Implement arm-specific platform_get_irq() as
a band-aid. Or better, implement virtual irqs <-> hardware irqs mapping
for ARM.

[...]
> I'm a bit annoyed as this is the third time[1] this month this irq0
> discussion pops up for me.  I think people see that irq0 is involved
> somehow, start wailing and stop seeing the issues being fixed.

For this particular driver, there is NO issue whatsoever. It is
only used for PowerPC, which has VIRQ0 == invalid IRQ. And note
that there still could be HWIRQ0 on PowerPC, but it is *never*
mapped to VIRQ0.

[...]
> [1] one is:
> 	http://thread.gmane.org/gmane.linux.kernel/924739

No wonder the discussion popped up. You're adding some ugly
#ifdef stuff that adds some arch-specific knowledge to a generic
code.

Sure, there's a lot of ugly code even in the kernel/ directly, but
you have to prepare for resistance when you add more of it.

So, if you want to fix the root cause of the issue: revert the
305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0, and try to improve the
ARM land, do not band-aid the whole kernel all over the place.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
