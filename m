Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZG3IxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZG3IxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZG3IxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:53:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:47187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZG3IxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:53:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,294,1246863600"; 
   d="scan'208";a="479226487"
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v4 4/4] x86: MCE: Fake panic support for MCE testing
Date: Thu, 30 Jul 2009 16:52:33 +0800
Message-Id: <1248943953-26100-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248943953-26100-4-git-send-email-ying.huang@intel.com>
References: <1248943953-26100-1-git-send-email-ying.huang@intel.com>
 <1248943953-26100-2-git-send-email-ying.huang@intel.com>
 <1248943953-26100-3-git-send-email-ying.huang@intel.com>
 <1248943953-26100-4-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "fake panic" mode is turned on, just log panic message instead of
go real panic. This is used for testing only, so that the test suite
can check for the correct panic message and do regression testing for
MCE would go panic.

This patch is based on x86-tip.git/mce3.

Signed-off-by: Huang Ying <ying.huang@intel.com>


ChangeLog:

v4:

- Move config file from sysfs to debugfs
---
 arch/x86/kernel/cpu/mcheck/mce.c |   75 ++++++++++++++++++++++++++++++++------
 1 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b57b6aa..c3a9f07 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -223,6 +223,9 @@ static void print_mce_tail(void)
 
 static atomic_t mce_paniced;
 
+static int fake_panic;
+static atomic_t mce_fake_paniced;
+
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
 {
@@ -240,15 +243,21 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i;
 
-	/*
-	 * Make sure only one CPU runs in machine check panic
-	 */
-	if (atomic_add_return(1, &mce_paniced) > 1)
-		wait_for_panic();
-	barrier();
+	if (!fake_panic) {
+		/*
+		 * Make sure only one CPU runs in machine check panic
+		 */
+		if (atomic_add_return(1, &mce_paniced) > 1)
+			wait_for_panic();
+		barrier();
 
-	bust_spinlocks(1);
-	console_verbose();
+		bust_spinlocks(1);
+		console_verbose();
+	} else {
+		/* Don't log too much for fake panic */
+		if (atomic_add_return(1, &mce_fake_paniced) > 1)
+			return;
+	}
 	print_mce_head();
 	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
@@ -275,9 +284,12 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 	print_mce_tail();
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
-	if (panic_timeout == 0)
-		panic_timeout = mce_panic_timeout;
-	panic(msg);
+	if (!fake_panic) {
+		if (panic_timeout == 0)
+			panic_timeout = mce_panic_timeout;
+		panic(msg);
+	} else
+		printk(KERN_EMERG "Fake kernel panic: %s\n", msg);
 }
 
 /* Support code for software error injection */
@@ -2059,4 +2071,45 @@ struct dentry *mce_get_debugfs_dir(void)
 
 	return dmce;
 }
+
+static void mce_reset(void)
+{
+	cpu_missing = 0;
+	atomic_set(&mce_fake_paniced, 0);
+	atomic_set(&mce_executing, 0);
+	atomic_set(&mce_callin, 0);
+	atomic_set(&global_nwo, 0);
+}
+
+static int fake_panic_get(void *data, u64 *val)
+{
+	*val = fake_panic;
+	return 0;
+}
+
+static int fake_panic_set(void *data, u64 val)
+{
+	mce_reset();
+	fake_panic = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
+			fake_panic_set, "%llu\n");
+
+static int __init mce_debugfs_init(void)
+{
+	struct dentry *dmce, *ffake_panic;
+
+	dmce = mce_get_debugfs_dir();
+	if (!dmce)
+		return -ENOMEM;
+	ffake_panic = debugfs_create_file("fake_panic", 0444, dmce, NULL,
+					  &fake_panic_fops);
+	if (!ffake_panic)
+		return -ENOMEM;
+
+	return 0;
+}
+late_initcall(mce_debugfs_init);
 #endif
-- 
1.6.3.3

