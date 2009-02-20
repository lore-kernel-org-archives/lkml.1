Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZBTQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZBTQly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZBTQku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:40:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZBTQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:40:48 -0500
Message-Id: <20090220164046.528070886@goodmis.org>
References: <20090220163846.709775139@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 11:38:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace, x86: do not depend on system state for kernel text info
Content-Disposition: inline; filename=0005-ftrace-x86-do-not-depend-on-system-state-for-kerne.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Andrew Morton pointed out that using SYSTEM_STATE is a bad idea
since there is no guarantee to what its state will actually be.

Instead, I moved the check into the set_kernel_text_* functions
themselves, and use a local variable to determine when it is
OK to change the kernel text RW permissions.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    8 --------
 arch/x86/mm/init_32.c    |   10 ++++++++++
 arch/x86/mm/init_64.c    |   10 ++++++++++
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index c9ba2f9..025d783 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -28,20 +28,12 @@
 
 int ftrace_arch_modify_prepare(void)
 {
-	/* at boot up, we are still writable */
-	if (system_state != SYSTEM_RUNNING)
-		return 0;
-
 	set_kernel_text_rw();
 	return 0;
 }
 
 int ftrace_arch_modify_post_process(void)
 {
-	/* at boot up, we are still writable */
-	if (system_state != SYSTEM_RUNNING)
-		return 0;
-
 	set_kernel_text_ro();
 	return 0;
 }
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bcd7f00..9ca4c57 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1155,12 +1155,17 @@ static noinline int do_test_wp_bit(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
+static int kernel_set_to_readonly;
+
 /* used by ftrace */
 void set_kernel_text_rw(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
+	if (!kernel_set_to_readonly)
+		return;
+
 	printk(KERN_INFO "Set kernel text: %lx - %lx for read write\n",
 	       start, start+size);
 
@@ -1173,6 +1178,9 @@ void set_kernel_text_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
+	if (!kernel_set_to_readonly)
+		return;
+
 	printk(KERN_INFO "Set kernel text: %lx - %lx for read only\n",
 	       start, start+size);
 
@@ -1188,6 +1196,8 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
 		size >> 10);
 
+	kernel_set_to_readonly = 1;
+
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
 		start, start+size);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8c1b5ee..c204433 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -986,12 +986,17 @@ void free_initmem(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
+static int kernel_set_to_readonly;
+
 /* used by ftrace */
 void set_kernel_text_rw(void)
 {
 	unsigned long start = PFN_ALIGN(_stext);
 	unsigned long end = PFN_ALIGN(__start_rodata);
 
+	if (!kernel_set_to_readonly)
+		return;
+
 	printk(KERN_INFO "Set kernel text: %lx - %lx for read write\n",
 	       start, end);
 
@@ -1004,6 +1009,9 @@ void set_kernel_text_ro(void)
 	unsigned long start = PFN_ALIGN(_stext);
 	unsigned long end = PFN_ALIGN(__start_rodata);
 
+	if (!kernel_set_to_readonly)
+		return;
+
 	printk(KERN_INFO "Set kernel text: %lx - %lx for read only\n",
 	       start, end);
 
@@ -1020,6 +1028,8 @@ void mark_rodata_ro(void)
 	       (end - start) >> 10);
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 
+	kernel_set_to_readonly = 1;
+
 	/*
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
-- 
1.5.6.5

-- 
