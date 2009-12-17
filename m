Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbZLQQZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbZLQQZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762776AbZLQQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:25:29 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:40125 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759448AbZLQQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:25:27 -0500
Date: Thu, 17 Dec 2009 19:25:22 +0300
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
Message-ID: <20091217162522.GA14745@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091216163229.GA26350@oksana.dev.rtsoft.ru>
 <20091216174904.GB26325@pengutronix.de>
 <20091216182034.GA7590@oksana.dev.rtsoft.ru>
 <20091216191839.GA23614@pengutronix.de>
 <20091216193745.GA20429@oksana.dev.rtsoft.ru>
 <20091217130549.GA9032@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091217130549.GA9032@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 02:05:49PM +0100, Uwe Kleine-König wrote:
[...]
> > > Yes, there is an issue.  If the platform device doesn't have a resource
> > > specifing the irq, platform_get_irq returns -ENXIO.  So in the driver
> > > (unsigned)(-ENXIO) is passed to mpc8xxx_spi_probe as (!(-ENXIO)) is
> > > false and so the error isn't catched.
> > 
> > If you look into how we create the platform device, you'll notice
> > that -ENXIO isn't possible.
> > It's in arch/powerpc/platforms/83xx/mpc832x_rdb.c:of_fsl_spi_probe(),
> > which is a legacy interface that I'd like to be removed anyway.
> > 
> > Though, if you want to fix the inconsistency in the platform device
> > API, then I'd suggest to fix the platform_get_irq(). The driver itself
> > is correct.
> With platform_get_irq as it is today, the check in
> 
> 	irq = platform_get_irq(pdev, 0);
> 	if (!irq)
> 		return -EINVAL;

And I see no problem with this piece of code, really. I see the
problem in platform_get_irq() implementation (not that easy to fix,
see below).

> is non-sense as !irq always evaluates to 0.  If your argue that the
> resources are right,

No, I'm arguing that there is no issue. There *could* be an issue in
the future (if someone break the platform code), but the way you're
trying to fix the *possibility* isn't quite correct.

Believe me, I'd have no problem with this particular patch if the
patch could possibly fix any real world issue with this driver.

For example, you may notice the following commit:

commit 2fac6674ddf3164da42a76d62f8912073d629a30
Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Tue Jan 6 14:42:11 2009 -0800

    rtc: bunch of drivers: fix 'no irq' case handing

    This patch fixes a bunch of irq checking misuses.  Most drivers were
    getting irq via platform_get_irq(), which returns -ENXIO or r->start.

Sounds similar, eh? But you may notice that the unfixed code
was really wrong and didn't work for every sane platform:

        m48t59->irq = platform_get_irq(pdev, 0);
-       if (m48t59->irq < 0)
+       if (m48t59->irq <= 0)

The checks were irq < 0, so the drivers were requesting irq0, and
then were failing to probe.

Unfortunately, I stopped half way, afraid to possibly break current
platforms that use these drivers, so I kept the "<" part. Which is
a shame, because... um, it seems I spread the bad example further.

Anyway, I just did 'grep platform_get_irq -A 2 -r drivers/', and
it looks horrible, most callers check for irq < 0, which means
the code won't work on anything but arches with NO_IRQ == -1
(ARM, parisc, xtensa).

It seems the situation is near to hopeless. Maybe someone needs to
sit down and cleanup this mess once and for ever...
