Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZLPRtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZLPRtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZLPRtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:49:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56480 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZLPRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:49:15 -0500
Date: Wed, 16 Dec 2009 18:49:04 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
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
Message-ID: <20091216174904.GB26325@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de> <20091216163229.GA26350@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091216163229.GA26350@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[Note the email address used for David Vrabel isn't valid any more,
this mail uses his last used address.]

On Wed, Dec 16, 2009 at 07:32:29PM +0300, Anton Vorontsov wrote:
> On Wed, Dec 16, 2009 at 05:10:08PM +0100, Uwe Kleine-König wrote:
> > platform_get_irq returns -ENXIO on failure, so !irq was probably
> > always true.  Better use (int)irq <= 0.  Note that a return value of
> > zero is still handled as error even though this could mean irq0.
> > 
> > This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> > changed the return value of platform_get_irq from 0 to -ENXIO on error.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> 
> Noooooo... :-(
> 
> Please revert 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 instead,
> and fix platforms to remap HWIRQ0 to something that is not VIRQ0.
> 
> IRQ0 is invalid for everything that is outside of arch/*.
> 
> http://lkml.org/lkml/2005/11/22/159
> http://lkml.org/lkml/2005/11/22/213
> http://lkml.org/lkml/2005/11/22/227
First note that my check is safe with both variants (e.g. it does the
right thing independent of the error being signaled by 0 or
-ESOMETHING.)

Then arch/arm/mach-pxa/devices.c has:

static struct resource pxa27x_resource_ssp3[] = {
	...
	[1] = {
		.start  = IRQ_SSP3,
		.end    = IRQ_SSP3,
		.flags  = IORESOURCE_IRQ,
	},
	...
}

with IRQ_SSP3 being zero (sometimes).  The driver is implemented in
arch/arm/mach-pxa/ssp.c and uses platform_get_irq.  So according to your
definition it's allowed (arch/* only).  Still this would break if you
revert 305b3228f9.

Actually I don't care much, but as platform_get_irq returns an int I
think it's fine for it to signal an error using a value < 0 as irqs are
not negative.

My position regarding irq0 is:  If a variable holds either a valid irq
or a value indicating "no irq", then feel free to use 0 as "no irq" and
a value > 0 for a valid irq (without offset).  If you want irq0 here,
you're out of luck.  But if you have a variable holding a valid irq only
(that is, there is no doubt if the value is valid or not) I see no
reason to dogmatically prohibit irq0.

I'm a bit annoyed as this is the third time[1] this month this irq0
discussion pops up for me.  I think people see that irq0 is involved
somehow, start wailing and stop seeing the issues being fixed.

Best regards
Uwe

[1] one is:
	http://thread.gmane.org/gmane.linux.kernel/924739
    the other wasn't on lkml, only mm-commits.  Cannot find it on the
    net now.
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
