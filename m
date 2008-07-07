Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYGGXKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYGGXKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYGGXKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:10:09 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2492 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYGGXKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:10:07 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/10] MCE: Make 64bit mce code 32bit clean v2
Message-Id: <20080707231003.869001B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:03 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:39.0573 (UTC) FILETIME=[8DE20050:01C8E085]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly replace unsigned long with u64s if they need to contain 64bit
values.

Also replace the simple_strtouls with strict_strtouls to shut
up checkpatch warnings.

v2: Do the strict_strtoull conversions correctly.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   12 ++++++------
 include/asm-x86/mce.h               |   24 ++++++++++++------------
 2 files changed, 18 insertions(+), 18 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -46,7 +46,7 @@ static int mce_dont_init;
  */
 static int tolerant = 1;
 static int banks;
-static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
+static u64 bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
 static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = -1;
@@ -129,15 +129,15 @@ static void print_mce(struct mce *m)
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *backup, unsigned long start)
+static void mce_panic(char *msg, struct mce *backup, u64 start)
 {
 	int i;
 
 	oops_begin();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
-		unsigned long tsc = mcelog.entry[i].tsc;
+		u64 tsc = mcelog.entry[i].tsc;
 
-		if (time_before(tsc, start))
+		if (time_before64(tsc, start))
 			continue;
 		print_mce(&mcelog.entry[i]);
 		if (backup && mcelog.entry[i].tsc == backup->tsc)
@@ -754,15 +754,15 @@ DEFINE_PER_CPU(struct sys_device, device
 /* Why are there no generic functions for this? */
 #define ACCESSOR(name, var, start) \
 	static ssize_t show_ ## name(struct sys_device *s, char *buf) {	\
-		return sprintf(buf, "%lx\n", (unsigned long)var);	\
+		return sprintf(buf, "%Lx\n", (u64)var); 		\
 	}								\
 	static ssize_t set_ ## name(struct sys_device *s,const char *buf,size_t siz) { \
-		char *end;						\
-		unsigned long new = simple_strtoul(buf, &end, 0);	\
-		if (end == buf) return -EINVAL;				\
+		u64 new;						\
+		int err = strict_strtoull(buf, 0, &new);		\
+		if (err) return err;					\
 		var = new;						\
 		start;							\
-		return end-buf;						\
+		return strlen(buf);					\
 	}								\
 	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
 
Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -10,19 +10,19 @@
  * Machine Check support for x86
  */
 
-#define MCG_CTL_P	 (1UL<<8)   /* MCG_CAP register available */
+#define MCG_CTL_P	 (1ULL<<8)   /* MCG_CAP register available */
 
-#define MCG_STATUS_RIPV  (1UL<<0)   /* restart ip valid */
-#define MCG_STATUS_EIPV  (1UL<<1)   /* ip points to correct instruction */
-#define MCG_STATUS_MCIP  (1UL<<2)   /* machine check in progress */
-
-#define MCI_STATUS_VAL   (1UL<<63)  /* valid error */
-#define MCI_STATUS_OVER  (1UL<<62)  /* previous errors lost */
-#define MCI_STATUS_UC    (1UL<<61)  /* uncorrected error */
-#define MCI_STATUS_EN    (1UL<<60)  /* error enabled */
-#define MCI_STATUS_MISCV (1UL<<59)  /* misc error reg. valid */
-#define MCI_STATUS_ADDRV (1UL<<58)  /* addr reg. valid */
-#define MCI_STATUS_PCC   (1UL<<57)  /* processor context corrupt */
+#define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
+#define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
+#define MCG_STATUS_MCIP  (1ULL<<2)   /* machine check in progress */
+
+#define MCI_STATUS_VAL	 (1ULL<<63)  /* valid error */
+#define MCI_STATUS_OVER  (1ULL<<62)  /* previous errors lost */
+#define MCI_STATUS_UC	 (1ULL<<61)  /* uncorrected error */
+#define MCI_STATUS_EN	 (1ULL<<60)  /* error enabled */
+#define MCI_STATUS_MISCV (1ULL<<59)  /* misc error reg. valid */
+#define MCI_STATUS_ADDRV (1ULL<<58)  /* addr reg. valid */
+#define MCI_STATUS_PCC	 (1ULL<<57)  /* processor context corrupt */
 
 /* Fields are zero when not available */
 struct mce {
