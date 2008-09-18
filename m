Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYIRBNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYIRBNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 21:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYIRBNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 21:13:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:18801 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYIRBND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 21:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=PfxwdHVjPElhdLgG2T6Su1UpdSAZeMh6jekxgZIvu+9aM6eGxstC/a0j7XZ1jfQQ3p
         3ub6Mk1uqqfVjnFi6JXNNsDNsadWjij3e/PtmwZP18clGckny/1j+gVR013g4RO0rV7H
         hYjNOGk0tR2woKLto93K+eHoAP6fWmqgkPvx0=
Message-ID: <5767b9100809171813u7e26d516x12558a178b78f852@mail.gmail.com>
Date: Thu, 18 Sep 2008 09:13:01 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: Linux-arm-kernel@lists.arm.linux.org.uk, "Ben Dooks" <ben-linux@fluff.org>
Subject: s3c24xx nand: add command line partition table parsing support (resend)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-arm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mtd id and  command line partition table parsing support for
s3c24xx nand driver.

Signed-off-by: Conke Hu <conke.hu@gmail.com>
Signed-off-by: Linke Wang <linke.wang@gmail.com>
------------------
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 556139e..bab7216 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -48,6 +48,8 @@
 #include <asm/plat-s3c/regs-nand.h>
 #include <asm/plat-s3c/nand.h>

+#define S3C_NAND_NAME_LEN 16
+
 #ifdef CONFIG_MTD_NAND_S3C2410_HWECC
 static int hardware_ecc = 1;
 #else
@@ -60,6 +62,9 @@ static int clock_stop = 1;
 static const int clock_stop = 0;
 #endif

+#ifdef CONFIG_MTD_PARTITIONS
+static const char *s3c_part_probes[] = {"cmdlinepart", NULL};
+#endif

 /* new oob placement block for use with hardware ecc generation
 */
@@ -649,6 +654,15 @@ static int s3c2410_nand_add_partition(struct
s3c2410_nand_info *info,
                                    struct s3c2410_nand_mtd *mtd,
                                    struct s3c2410_nand_set *set)
 {
+#ifdef CONFIG_MTD_CMDLINE_PARTS
+       int nr_parts;
+       struct mtd_partition *partitions;
+
+       nr_parts = parse_mtd_partitions(&mtd->mtd, s3c_part_probes,
&partitions, 0);
+       if (nr_parts > 0 && partitions != NULL)
+               return add_mtd_partitions(&mtd->mtd, partitions, nr_parts);
+#endif
+
      if (set == NULL)
              return add_mtd_device(&mtd->mtd);

@@ -808,6 +822,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,
      int size;
      int nr_sets;
      int setno;
+       char *name;

      pr_debug("s3c2410_nand_probe(%p)\n", pdev);

@@ -875,7 +890,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,

      /* allocate our information */

-       size = nr_sets * sizeof(*info->mtds);
+       size = nr_sets * (sizeof(*info->mtds) + S3C_NAND_NAME_LEN);
      info->mtds = kmalloc(size, GFP_KERNEL);
      if (info->mtds == NULL) {
              dev_err(&pdev->dev, "failed to allocate mtd storage\n");
@@ -888,10 +903,15 @@ static int s3c24xx_nand_probe(struct
platform_device *pdev,
      /* initialise all possible chips */

      nmtd = info->mtds;
+       name = (char *)(info->mtds + nr_sets);

      for (setno = 0; setno < nr_sets; setno++, nmtd++) {
              pr_debug("initialising set %d (%p, info %p)\n", setno,
nmtd, info);

+               sprintf(name, "s3c_nand%d", setno);
+               nmtd->mtd.name = name;
+               name += S3C_NAND_NAME_LEN;
+
              s3c2410_nand_init_chip(info, nmtd, sets);

              nmtd->scan_res = nand_scan_ident(&nmtd->mtd,
