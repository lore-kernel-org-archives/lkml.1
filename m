Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZFEDLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZFEDLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZFEDLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:11:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:6816 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZFEDLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,308,1241420400"; 
   d="scan'208";a="150923503"
Subject: [PATCH] x86: MCE: Fake panic support for MCE testing
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 11:11:43 +0800
Message-Id: <1244171503.8361.493.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fake panic support for MCE testing

If "fake panic" mode is turned on, just log panic message instead of
go real panic. This is used for testing only, so that the test suite
can check for the correct panic message.

This patch is based on x86-tip.git/mce3.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |   65 +++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -218,6 +218,9 @@ static void print_mce_tail(void)
 
 static atomic_t mce_paniced;
 
+static int fake_panic;
+static atomic_t mce_fake_paniced;
+
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
 {
@@ -236,15 +239,21 @@ static void mce_panic(char *msg, struct 
 	int i;
 	int first = 1;
 
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
 	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		struct mce *m = &mcelog.entry[i];
@@ -267,9 +276,12 @@ static void mce_panic(char *msg, struct 
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
@@ -1671,9 +1683,38 @@ static ssize_t store_int_with_restart(st
 	return ret;
 }
 
+static void mce_reset(void)
+{
+	cpu_missing = 0;
+	atomic_set(&mce_fake_paniced, 0);
+	atomic_set(&mce_executing, 0);
+	atomic_set(&mce_callin, 0);
+	atomic_set(&global_nwo, 0);
+}
+
+static ssize_t show_fake_panic(struct sys_device *s,
+			       struct sysdev_attribute *attr,
+			       char *buf)
+{
+	return sprintf(buf, "%d\n", fake_panic);
+}
+
+static ssize_t set_fake_panic(struct sys_device *s,
+			      struct sysdev_attribute *attr,
+			      const char *buf, size_t siz)
+{
+	u64 new;
+	if (strict_strtoull(buf, 0, &new) < 0)
+		return -EINVAL;
+	mce_reset();
+	fake_panic = new;
+	return siz;
+}
+
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
+static SYSDEV_ATTR(fake_panic, 0644, show_fake_panic, set_fake_panic);
 
 static struct sysdev_ext_attribute attr_check_interval = {
 	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
@@ -1683,7 +1724,7 @@ static struct sysdev_ext_attribute attr_
 
 static struct sysdev_attribute *mce_attrs[] = {
 	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
-	&attr_monarch_timeout.attr,
+	&attr_monarch_timeout.attr, &attr_fake_panic,
 	NULL
 };
 


