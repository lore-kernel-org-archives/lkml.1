Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYIRP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYIRP60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYIRP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:58:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:3929 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbYIRP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fkroq0HzZHmwdmHw9Ibgoi6ljymRmgPCzZQjuMIQuwtTO1IsOIa00mds1+F/jE1OOV
         rXYoKLTdO6cBQXBeTTWRzNERRYV9TmdvYOdwGE/Stz2ho63zej/94771fX2Sy82JPphk
         4R1I79sAed/w0QR/quBRdvx0PdmP8IStcvq10=
Message-ID: <5767b9100809180858r3bb9952el3bc76dab18930713@mail.gmail.com>
Date: Thu, 18 Sep 2008 23:58:14 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: s3c24xx nand: add command line partition table parsing support (resend)
Cc: Linux-arm-kernel@lists.arm.linux.org.uk, "Ben Dooks" <ben-linux@fluff.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <5767b9100809180855j58150b4ct4e2a4b9bb5ac7885@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100809171813u7e26d516x12558a178b78f852@mail.gmail.com>
	 <20080918112703.GA25491@flint.arm.linux.org.uk>
	 <5767b9100809180855j58150b4ct4e2a4b9bb5ac7885@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mtd id and  command line partition table parsing support for
s3c24xx nand driver.

Signed-off-by: Conke Hu <conke.hu@gmail.com>
Signed-off-by: Linke Wang <linke.wang@gmail.com>
------------------
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 556139e..db0d331 100644
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
@@ -80,6 +85,7 @@ struct s3c2410_nand_mtd {
 	struct s3c2410_nand_set		*set;
 	struct s3c2410_nand_info	*info;
 	int				scan_res;
+	char			name[S3C_NAND_NAME_LEN];
 };

 enum s3c_cpu_type {
@@ -649,6 +655,15 @@ static int s3c2410_nand_add_partition(struct
s3c2410_nand_info *info,
 				      struct s3c2410_nand_mtd *mtd,
 				      struct s3c2410_nand_set *set)
 {
+#ifdef CONFIG_MTD_CMDLINE_PARTS
+	int nr_parts;
+	struct mtd_partition *partitions;
+
+	nr_parts = parse_mtd_partitions(&mtd->mtd, s3c_part_probes, &partitions, 0);
+	if (nr_parts > 0 && partitions != NULL)
+		return add_mtd_partitions(&mtd->mtd, partitions, nr_parts);
+#endif
+
 	if (set == NULL)
 		return add_mtd_device(&mtd->mtd);

@@ -892,6 +907,9 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,
 	for (setno = 0; setno < nr_sets; setno++, nmtd++) {
 		pr_debug("initialising set %d (%p, info %p)\n", setno, nmtd, info);

+		snprintf(nmtd->name, sizeof(nmtd->name), "s3c_nand%d", setno);
+		nmtd->mtd.name = nmtd->name;
+
 		s3c2410_nand_init_chip(info, nmtd, sets);

 		nmtd->scan_res = nand_scan_ident(&nmtd->mtd,
