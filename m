Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbZBZXSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbZBZXSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbZBZXSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:18:20 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:42004 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759251AbZBZXST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:18:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Osk0gBezYcN2z+mF6Fm6gWEsgt2iwn2D2ZabxaCQpg4xZJbCNhPtg2kJBy3xhk6ciBv4NTOOFapK4Pt3z3aOmasBLa0kxxKr2wpCqsE7LXt9o5r7qb/nJHTi/nZ3OPLdU0ApvgQAViNAc9uWPTpt7TdzaE/cLhEuGi/gfBsxAeU=  ;
X-YMail-OSG: T8dHRCwVM1mn97S0VcwqXv6Y.Qi0GPpQ7n0QKCiqXL5OSmkPGQRPE.yTJ0VphAzVx0LgUN1dqkOebX.HvqclR3TZXKlzDVauVUJI_hJWUXca4So2f8fqIY_bB9uTSN41VWA1R6bxZXSkiuwIKLUKM2sQQ4UMmpoWsR6ffFIZRCQmVyUSq2XNe_x5mqHiEF1G_qMz_9G2DhvcI62OpXpFq3Z2Kp9wyWtqjwk24Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org
Subject: [patch 2.6.29-rc6-mmotm] MTD: partitioning utility predicates
Date: Thu, 26 Feb 2009 15:18:16 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200902241509.54649.david-b@pacbell.net> <20090226123341.a2421733.akpm@linux-foundation.org>
In-Reply-To: <20090226123341.a2421733.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261518.16378.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Move mtd_has_partitions() and mtd_has_cmdlinepart() inlines from
a DaVinci-specific driver to the <linux/mtd/partitions.h> header.

Use those to eliminate #ifdefs in two drivers which had their
own definitions of mtd_has_partitions().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Quite a lot of other MTD drivers could benefit from using use one
or both of these to remove #ifdeffery.  Maybe some Janitors
would like to help?

 drivers/mtd/devices/m25p80.c        |   17 ++++++-----------
 drivers/mtd/devices/mtd_dataflash.c |   16 ++++++----------
 drivers/mtd/nand/davinci_nand.c     |   13 -------------
 include/linux/mtd/partitions.h      |   12 ++++++++++++
 4 files changed, 24 insertions(+), 34 deletions(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -65,12 +65,6 @@
 #define FAST_READ_DUMMY_BYTE 0
 #endif
 
-#ifdef CONFIG_MTD_PARTITIONS
-#define	mtd_has_partitions()	(1)
-#else
-#define	mtd_has_partitions()	(0)
-#endif
-
 /****************************************************************************/
 
 struct m25p {
@@ -708,12 +702,13 @@ static int __devinit m25p_probe(struct s
 		struct mtd_partition	*parts = NULL;
 		int			nr_parts = 0;
 
-#ifdef CONFIG_MTD_CMDLINE_PARTS
-		static const char *part_probes[] = { "cmdlinepart", NULL, };
+		if (mtd_has_cmdlinepart()) {
+			static const char *part_probes[]
+					= { "cmdlinepart", NULL, };
 
-		nr_parts = parse_mtd_partitions(&flash->mtd,
-				part_probes, &parts, 0);
-#endif
+			nr_parts = parse_mtd_partitions(&flash->mtd,
+					part_probes, &parts, 0);
+		}
 
 		if (nr_parts <= 0 && data && data->parts) {
 			parts = data->parts;
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -98,12 +98,6 @@ struct dataflash {
 	struct mtd_info		mtd;
 };
 
-#ifdef CONFIG_MTD_PARTITIONS
-#define	mtd_has_partitions()	(1)
-#else
-#define	mtd_has_partitions()	(0)
-#endif
-
 /* ......................................................................... */
 
 /*
@@ -682,11 +676,13 @@ add_dataflash_otp(struct spi_device *spi
 		struct mtd_partition	*parts;
 		int			nr_parts = 0;
 
-#ifdef CONFIG_MTD_CMDLINE_PARTS
-		static const char *part_probes[] = { "cmdlinepart", NULL, };
+		if (mtd_has_cmdlinepart()) {
+			static const char *part_probes[]
+					= { "cmdlinepart", NULL, };
 
-		nr_parts = parse_mtd_partitions(device, part_probes, &parts, 0);
-#endif
+			nr_parts = parse_mtd_partitions(device,
+					part_probes, &parts, 0);
+		}
 
 		if (nr_parts <= 0 && pdata && pdata->parts) {
 			parts = pdata->parts;
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -39,19 +39,6 @@
 #include <asm/mach-types.h>
 
 
-#ifdef CONFIG_MTD_PARTITIONS
-static inline int mtd_has_partitions(void) { return 1; }
-#else
-static inline int mtd_has_partitions(void) { return 0; }
-#endif
-
-#ifdef CONFIG_MTD_CMDLINE_PARTS
-static inline int mtd_has_cmdlinepart(void) { return 1; }
-#else
-static inline int mtd_has_cmdlinepart(void) { return 0; }
-#endif
-
-
 /*
  * This is a device driver for the NAND flash controller found on the
  * various DaVinci family chips.  It handles up to four SoC chipselects,
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -76,4 +76,16 @@ int __devinit of_mtd_parse_partitions(st
                                       struct device_node *node,
                                       struct mtd_partition **pparts);
 
+#ifdef CONFIG_MTD_PARTITIONS
+static inline int mtd_has_partitions(void) { return 1; }
+#else
+static inline int mtd_has_partitions(void) { return 0; }
+#endif
+
+#ifdef CONFIG_MTD_CMDLINE_PARTS
+static inline int mtd_has_cmdlinepart(void) { return 1; }
+#else
+static inline int mtd_has_cmdlinepart(void) { return 0; }
+#endif
+
 #endif
