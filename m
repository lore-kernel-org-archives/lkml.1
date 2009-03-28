Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZC1KBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZC1KBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 06:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZC1KBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 06:01:15 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:54866 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZC1KBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 06:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mWNlNkpJz3nxqhauq3xABFDMB8TY2BunUZr8Cv9KsBxIjwYRS+xGGGHaHIXItOqOgX
         aP2qj8A79OC5oNyqBsnXD6/DRHkhcptNOCIhsR5AhXewwDo4Q+ZYFbhgN1mSTN+s6v7k
         76r475v6bnTd9axBRrq7Bc5e/jwk3Bt62hptU=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-57-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-57-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sat, 28 Mar 2009 11:01:10 +0100
Message-ID: <74d0deb30903280301x7408963ek22e6452d1f3e849c@mail.gmail.com>
Subject: Re: [PATCH 57/58] move w100fb's probe function to .devinit.text
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ian Molton <spyro@f2s.com>, Richard Purdie <rpurdie@rpsys.net>,
       Antonino Daplas <adaplas@gmail.com>,
       Alberto Mardegan <mardy@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A pointer to w100fb_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

The ATI Imageon chips handled by this driver are not hotpluggable,
I think the proposed alternative is the right way.
Also, shouldn't w100fb_init be moved from __devinit to __init and
w100fb_remove be put into __exit?

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Ian Molton <spyro@f2s.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Antonino Daplas <adaplas@gmail.com>
> Cc: Alberto Mardegan <mardy@users.sourceforge.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>

---
 drivers/video/w100fb.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index d0674f1..157e7bd 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -781,7 +781,7 @@ out:
 }


-static int w100fb_remove(struct platform_device *pdev)
+static int __exit w100fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 	struct w100fb_par *par=info->par;
@@ -1609,8 +1609,7 @@ static void w100_vsync(void)
 }

 static struct platform_driver w100fb_driver = {
-	.probe		= w100fb_probe,
-	.remove		= w100fb_remove,
+	.remove		= __exit_p(w100fb_remove),
 	.suspend	= w100fb_suspend,
 	.resume		= w100fb_resume,
 	.driver		= {
@@ -1618,9 +1617,9 @@ static struct platform_driver w100fb_driver = {
 	},
 };

-int __devinit w100fb_init(void)
+int __init w100fb_init(void)
 {
-	return platform_driver_register(&w100fb_driver);
+	return platform_driver_probe(&w100fb_driver, w100fb_probe);
 }

 void __exit w100fb_cleanup(void)
-- 
1.6.2.1
