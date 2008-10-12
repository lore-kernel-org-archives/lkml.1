Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYJLUKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYJLUKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYJLUKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:10:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:5816 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbYJLUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e0dRBId7h0qUIjYfbAdPdM8ntDPNgcUP28Kv51AsdJbfAMaoficapyL4Y14HIb5Pkh
         3dy9rJAfFj+pqYfstkFUNFcPrtsjzIysUy3sAZRQS7EwrVEKB30KocMr/9u5PtLROh5O
         2v+hhr8MtTrhDSsZ1DlZAKkYZ80J4PHEPQexc=
Message-ID: <5767b9100810121309w6e131161g327e9d11bfdd05c@mail.gmail.com>
Date: Mon, 13 Oct 2008 04:09:58 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: s3c24xx nand: add command line partition table parsing support (resend)
Cc: Linux-arm-kernel@lists.arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <5767b9100809180858r3bb9952el3bc76dab18930713@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100809171813u7e26d516x12558a178b78f852@mail.gmail.com>
	 <20080918112703.GA25491@flint.arm.linux.org.uk>
	 <5767b9100809180855j58150b4ct4e2a4b9bb5ac7885@mail.gmail.com>
	 <5767b9100809180858r3bb9952el3bc76dab18930713@mail.gmail.com>
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

       struct s3c2410_nand_set         *set;
       struct s3c2410_nand_info        *info;
       int                             scan_res;
+       char                    name[S3C_NAND_NAME_LEN];
 };


 enum s3c_cpu_type {
@@ -649,6 +655,15 @@ static int s3c2410_nand_add_partition(struct

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


@@ -892,6 +907,9 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,

       for (setno = 0; setno < nr_sets; setno++, nmtd++) {
               pr_debug("initialising set %d (%p, info %p)\n", setno,
nmtd, info);

+               snprintf(nmtd->name, sizeof(nmtd->name), "s3c_nand%d", setno);
+               nmtd->mtd.name = nmtd->name;
+
               s3c2410_nand_init_chip(info, nmtd, sets);

               nmtd->scan_res = nand_scan_ident(&nmtd->mtd,
