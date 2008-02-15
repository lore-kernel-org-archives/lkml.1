Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbYBOXeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbYBOXeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbYBOXeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:34:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45356 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760500AbYBOXd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:33:57 -0500
Date: Fri, 15 Feb 2008 15:33:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [PATCH] x86: add CONFIG_CC_STACKPROTECTOR selftest
Message-ID: <20080215153312.56d580fe@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(against x86/mm git)

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] x86: add CONFIG_CC_STACKPROTECTOR selftest

This patch adds a simple self-test capability to the stackprotector
feature. The test deliberately overflows a stack buffer and then
checks if the canary trap function gets called.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/panic.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b91cac1..c3d7dee 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -320,14 +320,71 @@ EXPORT_SYMBOL(warn_on_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
+
+static unsigned long __stack_check_testing;
+/*
+ * Self test function for the stack-protector feature.
+ * This test requires that the local variable absolutely has
+ * a stack slot, hence the barrier()s.
+ */
+static noinline void __stack_chk_test_func(void)
+{
+	unsigned long foo;
+	barrier();
+	/*
+	 * we need to make sure we're not about to clobber the return address,
+	 * while real exploits do this, it's unhealthy on a running system.
+	 * Besides, if we would, the test is already failed anyway so
+	 * time to pull the emergency brake on it.
+	 */
+	if ((unsigned long)__builtin_return_address(0) == 
+					*(((unsigned long *)&foo)+2)) {
+		printk(KERN_ERR "No -fstack-protector-stack-frame!\n");
+		return;
+	}
+	barrier();
+	memset(&foo, 0, 2*sizeof(foo)); /* deliberate buffer overflow */
+	barrier();
+}
+
+static int __stack_chk_test(void)
+{
+	printk(KERN_INFO "Testing -fstack-protector-all feature\n");
+	__stack_check_testing = (unsigned long)&__stack_chk_test_func;
+	__stack_chk_test_func();
+	if (__stack_check_testing) {
+		printk(KERN_ERR "-fstack-protector-all test failed\n");
+		WARN_ON(1);
+	}
+	return 0;
+}
 /*
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
 void __stack_chk_fail(void)
 {
+	if (__stack_check_testing == (unsigned long)&__stack_chk_test_func) {
+		long delta;
+
+		delta = (unsigned long)__builtin_return_address(0) -
+				__stack_check_testing;
+		/*
+		 * The test needs to happen inside the test function, so
+		 * check if the return address is close to that function.
+		 * The function is only 2 dozen bytes long, but keep a wide
+		 * safety margin to avoid panic()s for normal users regardless
+		 * of the quality of the compiler.
+		 */
+		if (delta >= 0 && delta <= 400) {
+			__stack_check_testing = 0;
+			return;
+		}
+	}
 	panic("stack-protector: Kernel stack is corrupted in: %p\n",
 		__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__stack_chk_fail);
+
+late_initcall(__stack_chk_test);
 #endif
-- 
1.5.4.1



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
