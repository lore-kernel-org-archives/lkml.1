Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0BYJzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:55:43 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:53172 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0BYJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t7GLK1tnNgrNdOPP+5l2isMAc4cdwxq0BedyxuAZRe/RvlzqTZ3kbpQt3mN6c1lbKQ
         MPvC3u0iT/boLVxdzCxJCT6m8ADCocw5TvZWWEreZKRvN+tfDIMS5ecUitFV7owzG91S
         +CMO52AkfiH3o2/wdul/UuH/2IASnLvamjRZI=
Date: Thu, 25 Feb 2010 01:55:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver data
 handling
Message-ID: <20100225095536.GC10823@core.coreip.homeip.net>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073849.15964.62321.stgit@localhost.localdomain>
 <20100224102548.GG18896@rakim.wolfsonmicro.main>
 <20100224190234.GD25304@core.coreip.homeip.net>
 <20100224191402.GA8316@rakim.wolfsonmicro.main>
 <20100224192126.GE25304@core.coreip.homeip.net>
 <20100224204056.GA6824@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224204056.GA6824@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 08:40:56PM +0000, Mark Brown wrote:
> On Wed, Feb 24, 2010 at 11:21:26AM -0800, Dmitry Torokhov wrote:
> > On Wed, Feb 24, 2010 at 07:14:03PM +0000, Mark Brown wrote:
> 
> > > This doesn't help unless you also provide a way for users to obtain a
> > > struct wm8400.
> 
> > Why would they need it? Only code that creates instances of wm8400 needs
> > to know the definition of the sturcture, the rest can simply pass the
> > pointer around.
> 
> > I guess there is disconnect between us and I do not see any users of
> > wm8400_register_regulator() in linux-next... Is there another tree I
> > could peek at?
> 
> There are no users in mainline.  This would be called by board specific
> code from the init callback of the wm8400 - you'd need to pass that
> callback the struct wm8400.
> 
> In any case, this is clearly an unrelated change to whatever else you
> were doing to the driver so should be split off into a separate patch,
> but if this is being changed at all then it'd be much more sensible to
> change it to use a more modern pattern which completely removes the
> wm8400_register_regulator() function and just uses platform data.

Fair enough, I removed the offending part, updated patch below.

-- 
Dmitry

regulator: wm8400 - cleanup platform driver data handling

Driver data set by platform_set_drvdata() is for private use of
the driver currently bound to teh device and not for use by parent,
subsystem and anyone else.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/wm8400-regulator.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index d9a2c98..924c7eb 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -317,14 +317,17 @@ static struct regulator_desc regulators[] = {
 
 static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
 {
+	struct wm8400 *wm8400 = container_of(pdev, struct wm8400, regulators[pdev->id]);
 	struct regulator_dev *rdev;
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-		pdev->dev.platform_data, dev_get_drvdata(&pdev->dev));
+				  pdev->dev.platform_data, wm8400);
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
+	platform_set_drvdata(pdev, rdev);
+
 	return 0;
 }
 
@@ -332,6 +335,7 @@ static int __devexit wm8400_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
 
 	return 0;
@@ -370,7 +374,6 @@ int wm8400_register_regulator(struct device *dev, int reg,
 	wm8400->regulators[reg].id = reg;
 	wm8400->regulators[reg].dev.parent = dev;
 	wm8400->regulators[reg].dev.platform_data = initdata;
-	dev_set_drvdata(&wm8400->regulators[reg].dev, wm8400);
 
 	return platform_device_register(&wm8400->regulators[reg]);
 }
