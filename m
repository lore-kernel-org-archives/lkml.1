Return-Path: <linux-kernel-owner+w=401wt.eu-S935411AbZLQNGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935411AbZLQNGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934243AbZLQNF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:05:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442AbZLQNF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:05:56 -0500
Date: Thu, 17 Dec 2009 14:05:49 +0100
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
Message-ID: <20091217130549.GA9032@pengutronix.de>
References: <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de> <20091216163229.GA26350@oksana.dev.rtsoft.ru> <20091216174904.GB26325@pengutronix.de> <20091216182034.GA7590@oksana.dev.rtsoft.ru> <20091216191839.GA23614@pengutronix.de> <20091216193745.GA20429@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091216193745.GA20429@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Wed, Dec 16, 2009 at 10:37:45PM +0300, Anton Vorontsov wrote:
> On Wed, Dec 16, 2009 at 08:18:39PM +0100, Uwe Kleine-König wrote:
> [...]
> > > > I'm a bit annoyed as this is the third time[1] this month this irq0
> > > > discussion pops up for me.  I think people see that irq0 is involved
> > > > somehow, start wailing and stop seeing the issues being fixed.
> > > 
> > > For this particular driver, there is NO issue whatsoever. It is
> > > only used for PowerPC, which has VIRQ0 == invalid IRQ. And note
> > > that there still could be HWIRQ0 on PowerPC, but it is *never*
> > > mapped to VIRQ0.
> > Yes, there is an issue.  If the platform device doesn't have a resource
> > specifing the irq, platform_get_irq returns -ENXIO.  So in the driver
> > (unsigned)(-ENXIO) is passed to mpc8xxx_spi_probe as (!(-ENXIO)) is
> > false and so the error isn't catched.
> 
> If you look into how we create the platform device, you'll notice
> that -ENXIO isn't possible.
> It's in arch/powerpc/platforms/83xx/mpc832x_rdb.c:of_fsl_spi_probe(),
> which is a legacy interface that I'd like to be removed anyway.
> 
> Though, if you want to fix the inconsistency in the platform device
> API, then I'd suggest to fix the platform_get_irq(). The driver itself
> is correct.
With platform_get_irq as it is today, the check in

	irq = platform_get_irq(pdev, 0);
	if (!irq)
		return -EINVAL;

is non-sense as !irq always evaluates to 0.  If your argue that the
resources are right, then the logical consequence is to strip down
plat_mpc8xxx_spi_probe to just

	struct spi_master *master;
	master = mpc8xxx_spi_probe(&pdev->dev,
		platform_get_resource(pdev, IORESOURCE_MEM, 0)
		platform_get_irq(pdev, 0));
	if (IS_ERR(master))
		return PTR_ERR(master);
	return 0;

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
