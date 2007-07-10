Return-Path: <linux-kernel-owner+w=401wt.eu-S1764320AbXGJJ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764320AbXGJJ3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764137AbXGJJ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:28:48 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:32119 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763554AbXGJJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:45 -0400
Message-Id: <20070710093106.788578966@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/16] sclp: Test facility list before executing a service call.
Content-Disposition: inline; filename=004-sclp-detect.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Check if a command is available before executing. Saves some
superfluous service calls that won't succeed anyway.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c      |    1 +
 drivers/s390/char/sclp.h      |    5 +++++
 drivers/s390/char/sclp_chp.c  |    4 ++++
 drivers/s390/char/sclp_info.c |    9 +++++++++
 include/asm-s390/sclp.h       |    1 +
 5 files changed, 20 insertions(+)

Index: quilt-2.6/arch/s390/kernel/early.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/early.c
+++ quilt-2.6/arch/s390/kernel/early.c
@@ -275,6 +275,7 @@ void __init startup_init(void)
 	sort_main_extable();
 	setup_lowcore_early();
 	sclp_readinfo_early();
+	sclp_facilities_detect();
 	memsize = sclp_memory_detect();
 #ifndef CONFIG_64BIT
 	/*
Index: quilt-2.6/drivers/s390/char/sclp_chp.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/sclp_chp.c
+++ quilt-2.6/drivers/s390/char/sclp_chp.c
@@ -55,6 +55,8 @@ static int do_configure(sclp_cmdw_t cmd)
 	struct chp_cfg_data *data;
 	int rc;
 
+	if (!SCLP_HAS_CHP_RECONFIG)
+		return -EOPNOTSUPP;
 	/* Prepare sccb. */
 	data = (struct chp_cfg_data *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!data)
@@ -152,6 +154,8 @@ int sclp_chp_read_info(struct sclp_chp_i
 	struct chp_info_data *data;
 	int rc;
 
+	if (!SCLP_HAS_CHP_INFO)
+		return -EOPNOTSUPP;
 	/* Prepare sccb. */
 	data = (struct chp_info_data *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!data)
Index: quilt-2.6/drivers/s390/char/sclp.h
===================================================================
--- quilt-2.6.orig/drivers/s390/char/sclp.h
+++ quilt-2.6/drivers/s390/char/sclp.h
@@ -79,6 +79,11 @@ struct sccb_header {
 	u16	response_code;
 } __attribute__((packed));
 
+extern u64 sclp_facilities;
+
+#define SCLP_HAS_CHP_INFO	(sclp_facilities & 0x8000000000000000ULL)
+#define SCLP_HAS_CHP_RECONFIG	(sclp_facilities & 0x2000000000000000ULL)
+
 struct gds_subvector {
 	u8	length;
 	u8	key;
Index: quilt-2.6/drivers/s390/char/sclp_info.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/sclp_info.c
+++ quilt-2.6/drivers/s390/char/sclp_info.c
@@ -30,6 +30,8 @@ struct sclp_readinfo_sccb {
 static struct sclp_readinfo_sccb __initdata early_readinfo_sccb;
 static int __initdata early_readinfo_sccb_valid;
 
+u64 sclp_facilities;
+
 void __init sclp_readinfo_early(void)
 {
 	int ret;
@@ -70,6 +72,13 @@ void __init sclp_readinfo_early(void)
 	__ctl_clear_bit(0, 9);
 }
 
+void __init sclp_facilities_detect(void)
+{
+	if (!early_readinfo_sccb_valid)
+		return;
+	sclp_facilities = early_readinfo_sccb.facilities;
+}
+
 unsigned long long __init sclp_memory_detect(void)
 {
 	unsigned long long memsize;
Index: quilt-2.6/include/asm-s390/sclp.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/sclp.h
+++ quilt-2.6/include/asm-s390/sclp.h
@@ -28,6 +28,7 @@ struct sclp_ipl_info {
 };
 
 void sclp_readinfo_early(void);
+void sclp_facilities_detect(void);
 unsigned long long sclp_memory_detect(void);
 int sclp_sdias_blk_count(void);
 int sclp_sdias_copy(void *dest, int blk_num, int nr_blks);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

