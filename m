Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904Ab0COAc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:32:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58935 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934836Ab0COAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:32:50 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, kernel-janitors@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-mips@linux-mips.org,
       rtc-linux@googlegroups.com
Date: Mon, 15 Mar 2010 01:29:41 +0100
Message-Id: <1268612981-9009-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH] init dynamic bin_attribute structures
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6992f5334995af474c2b58d010d08bc597f0f2fe introduced this requirement.
First, at25 was fixed manually. Then, other occurences were found with
coccinelle and the following semantic patch. Results were reviewed and fixed
up:

@ init @
identifier struct_name, bin;
@@

	struct struct_name {
		...
		struct bin_attribute bin;
		...
	};

@ main extends init @
expression E;
statement S;
identifier name, err;
@@

(
	struct struct_name *name;
|
-	struct struct_name *name = NULL;
+	struct struct_name *name;
)
	...
(
	sysfs_bin_attr_init(&name->bin);
|
+	sysfs_bin_attr_init(&name->bin);
	if (sysfs_create_bin_file(E, &name->bin))
		S
|
+	sysfs_bin_attr_init(&name->bin);
	err = sysfs_create_bin_file(E, &name->bin);
)

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/mips/txx9/generic/setup.c |    1 +
 drivers/misc/eeprom/at25.c     |    1 +
 drivers/rtc/rtc-ds1742.c       |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 7174d83..95184a0 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -956,6 +956,7 @@ void __init txx9_sramc_init(struct resource *r)
 	if (!dev->base)
 		goto exit;
 	dev->dev.cls = &txx9_sramc_sysdev_class;
+	sysfs_bin_attr_init(&dev->bindata_attr);
 	dev->bindata_attr.attr.name = "bindata";
 	dev->bindata_attr.attr.mode = S_IRUSR | S_IWUSR;
 	dev->bindata_attr.read = txx9_sram_read;
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index d902d81..d194212 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -347,6 +347,7 @@ static int at25_probe(struct spi_device *spi)
 	 * that's sensitive for read and/or write, like ethernet addresses,
 	 * security codes, board-specific manufacturing calibrations, etc.
 	 */
+	sysfs_bin_attr_init(&at25->bin);
 	at25->bin.attr.name = "eeprom";
 	at25->bin.attr.mode = S_IRUSR;
 	at25->bin.read = at25_bin_read;
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index a127336..cad9ceb 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -184,6 +184,7 @@ static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 	pdata->size_nvram = pdata->size - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
+	sysfs_bin_attr_init(&pdata->nvram_attr);
 	pdata->nvram_attr.attr.name = "nvram";
 	pdata->nvram_attr.attr.mode = S_IRUGO | S_IWUSR;
 	pdata->nvram_attr.read = ds1742_nvram_read;
-- 
1.7.0

