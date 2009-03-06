Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZCFANS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZCFANS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCFANF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:13:05 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:54342 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755247AbZCFANE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:13:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mtd: plat_nand: allow platform to set partitions
Date: Thu, 5 Mar 2009 19:12:39 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909013B711F@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mtd: plat_nand: allow platform to set partitions
Thread-Index: Acmd8EKg9x2TkE2TSdy/o0lMsU5ejw==
From: "hartleys" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mtd@lists.infradead.org>, "Alexander Clouter" <alex@digriz.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>, <vitalywool@gmail.com>
X-OriginalArrivalTime: 06 Mar 2009 00:12:58.0744 (UTC) FILETIME=[4E422780:01C99DF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optional callback to allow platform to initialize partitions.

Static partitions on a nand device could vary depending on the size of
the device.  This patch allows an optional platform callback to be used
to setup this partition information at runtime.

Scan order is:
	1) chip.part_probe_types
	2) chip.set_parts
	3) chip.partitions
	4) full mtd device (fallback for no partitions)

Some of the existing nand drivers could possibly be replaced by the
plat_nand driver by using this patch.  These include autcpu12.c and
ts7250.c drivers.

This patch was originally submitted to linux-mtd but it was
suggested I post it here for a broader review.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 75f9f48..f10b5a6 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -86,6 +86,8 @@ static int __init plat_nand_probe(struct
platform_device *pdev)
 			return 0;
 		}
 	}
+	if (pdata->chip.set_parts)
+		pdata->chip.set_parts(data->mtd.size, &pdata->chip);
 	if (pdata->chip.partitions) {
 		data->parts = pdata->chip.partitions;
 		res = add_mtd_partitions(&data->mtd, data->parts,
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index db5b63d..4eaf328 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -563,6 +563,7 @@ extern int nand_do_read(struct mtd_info *mtd, loff_t
from, size_t len,
  * @options:		Option flags, e.g. 16bit buswidth
  * @ecclayout:		ecc layout info structure
  * @part_probe_types:	NULL-terminated array of probe types
+ * @set_parts:		platform specific function to set partitions
  * @priv:		hardware controller specific settings
  */
 struct platform_nand_chip {
@@ -574,6 +575,8 @@ struct platform_nand_chip {
 	int			chip_delay;
 	unsigned int		options;
 	const char		**part_probe_types;
+	void			(*set_parts)(uint64_t size,
+					struct platform_nand_chip
*chip);
 	void			*priv;
 };
  
