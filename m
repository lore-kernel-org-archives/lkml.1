Return-Path: <linux-kernel-owner+w=401wt.eu-S968727AbXFHLU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968727AbXFHLU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967747AbXFHLUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:20:17 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:50115 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966905AbXFHLUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:20:15 -0400
Subject: Re: [PATCH 1/1] Watchdog driver for AT32AP700X devices
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Wim Van Sebroeck <wim@iguana.be>
In-Reply-To: <1181287407.28296.17.camel@localhost.localdomain>
References: <1181138647434-git-send-email-hcegtvedt@atmel.com>
	 <20070607160910.34d64842.akpm@linux-foundation.org>
	 <1181287407.28296.17.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-HPl7lfPaFD+su+3aOXhX"
Date: Fri, 08 Jun 2007 13:20:08 +0200
Message-Id: <1181301608.28296.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HPl7lfPaFD+su+3aOXhX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-06-08 at 09:23 +0200, Hans-Christian Egtvedt wrote:
> On Thu, 2007-06-07 at 16:09 -0700, Andrew Morton wrote:
> > On Wed,  6 Jun 2007 16:04:07 +0200
> > Hans-Christian Egtvedt <hcegtvedt@atmel.com> wrote:
> > 
> > > This patch adds support for the built in watchdog in AT32AP700X devices.
> > > 
> > > Tested on AT32AP7000 and ATSTK1000.
> > > 
> > > Hardware documentation can be found in the AT32AP7000 datasheet.
> > > 
> > > ...
> > >
> > > +static int __init at32_wdt_probe(struct platform_device *pdev)
> > > +{
> 
> <cut start of _probe>
> 
> > > +	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
> > 
> > I see an ioremap(), but there are no iounmap()s anywhere.
> 
> Hmm, that would be my fault, please see the attach patch, it should
> apply clean to -mm after your two -fix{1,2} patches.

I missed iounmap if the probe function fails, the included patch
corrects this. Applies after the previous patches.

Do you want me to fold all five patches? original + fix1 and fix2 +
iounmap patches.

Sorry for the minor fixes.

-- 
With kind regards,

Hans-Christian Egtvedt, siv.ing. (M.Sc.)
Applications Engineer - AVR32 System Solutions - Atmel Norway

--=-HPl7lfPaFD+su+3aOXhX
Content-Disposition: attachment; filename=0001-at32ap700x-wdt-add-iounmap-if-probe-function-fails.txt
Content-Type: application/mbox; name=0001-at32ap700x-wdt-add-iounmap-if-probe-function-fails.txt
Content-Transfer-Encoding: 7bit

>From 9618b7b2f49f3d5cb628741e4022097c8836a06a Mon Sep 17 00:00:00 2001
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Date: Fri, 8 Jun 2007 13:17:13 +0200
Subject: [PATCH 1/1] at32ap700x-wdt: add iounmap if probe function fails

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
---
 drivers/char/watchdog/at32ap700x_wdt.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/watchdog/at32ap700x_wdt.c b/drivers/char/watchdog/at32ap700x_wdt.c
index 56ace8c..9b598d9 100644
--- a/drivers/char/watchdog/at32ap700x_wdt.c
+++ b/drivers/char/watchdog/at32ap700x_wdt.c
@@ -223,6 +223,11 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 	}
 
 	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!wdt->regs) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "could not map I/O memory\n");
+		goto err_free;
+	}
 	wdt->users = 0;
 	wdt->miscdev.minor = WATCHDOG_MINOR;
 	wdt->miscdev.name = "watchdog";
@@ -238,7 +243,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 	ret = misc_register(&wdt->miscdev);
 	if (ret) {
 		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
-		goto err_register;
+		goto err_iounmap;
 	}
 
 	platform_set_drvdata(pdev, wdt);
@@ -247,7 +252,9 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_register:
+err_iounmap:
+	iounmap(wdt->regs);
+err_free:
 	kfree(wdt);
 	wdt = NULL;
 	return ret;
-- 
1.4.4.2


--=-HPl7lfPaFD+su+3aOXhX--

