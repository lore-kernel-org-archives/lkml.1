Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZBTCF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZBTCF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZBTCFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:05:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZBTCFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:05:48 -0500
Date: Thu, 19 Feb 2009 21:05:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, fweisbec@gmail.com, torvalds@linux-foundation.org,
       arjan@infradead.org, rusty@rustcorp.com.au,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, srostedt@redhat.com
Subject: [PATCH][git pull] update to tip/tracing/ftrace
In-Reply-To: <alpine.DEB.1.10.0902192041200.31658@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0902192104410.31658@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <20090219173210.73318ebc.akpm@linux-foundation.org> <alpine.DEB.1.10.0902192041200.31658@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      ftrace, x86: do not depend on system state for kernel text info

----
 arch/x86/kernel/ftrace.c |    8 --------
 arch/x86/mm/init_32.c    |   10 ++++++++++
 arch/x86/mm/init_64.c    |   10 ++++++++++
 3 files changed, 20 insertions(+), 8 deletions(-)
---------------------------
commit 5d8ecb6568c598de6b6e678329e2ec0703a821f7
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Feb 19 20:51:45 2009 -0500

    ftrace, x86: do not depend on system state for kernel text info
    
    Andrew Morton pointed out that using SYSTEM_STATE is a bad idea
    since there is no guarantee to what its state will actually be.
    
    Instead, I moved the check into the set_kernel_text_* functions
    themselves, and use a local variable to determine when it is
    OK to change the kernel text RW permissions.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 26b64a8..4f4e82c 100644
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


