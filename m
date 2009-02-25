Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZBYA11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZBYA11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZBYA1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:27:13 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65507 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbZBYA1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:27:11 -0500
From: Tim Abbott <tabbott@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Jeff Arnold <jbarnold@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 3/4] Ksplice: Export symbols needed for Ksplice
Date: Tue, 24 Feb 2009 19:21:54 -0500
Message-Id: <1235521315-3424-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235521315-3424-3-git-send-email-tabbott@mit.edu>
References: <1235521315-3424-1-git-send-email-tabbott@mit.edu>
 <1235521315-3424-2-git-send-email-tabbott@mit.edu>
 <1235521315-3424-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ksplice uses __module_address and __module_text_address to determine
which module contains various addresses.

Ksplice uses __kernel_text_address to limit its check for trampolines
(jump instructions inserted by Ksplice) to only text addresses.

Ksplice uses task_curr in order to confirm that no other tasks are
executing during Ksplice's kernel stack check.

Ksplice uses find_bug and search_exception_tables as part of its
conservative check that the user provided the correct source code for
the running kernel.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 kernel/extable.c |    3 +++
 kernel/module.c  |    2 ++
 kernel/sched.c   |    1 +
 lib/bug.c        |    1 +
 4 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 384f0da..ce08fe8 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -40,6 +40,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 		e = search_module_extables(addr);
 	return e;
 }
+EXPORT_SYMBOL_GPL(search_exception_tables);
 
 __notrace_funcgraph int core_kernel_text(unsigned long addr)
 {
@@ -60,6 +61,7 @@ __notrace_funcgraph int __kernel_text_address(unsigned long addr)
 		return 1;
 	return is_module_text_address(addr);
 }
+EXPORT_SYMBOL_GPL(__kernel_text_address);
 
 int kernel_text_address(unsigned long addr)
 {
@@ -83,3 +85,4 @@ int func_ptr_is_kernel_text(void *ptr)
 		return 1;
 	return is_module_text_address(addr);
 }
+EXPORT_SYMBOL_GPL(kernel_text_address);
diff --git a/kernel/module.c b/kernel/module.c
index 77fbf38..b3135db 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2760,6 +2760,7 @@ __notrace_funcgraph struct module *__module_address(unsigned long addr)
 			return mod;
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__module_address);
 
 /*
  * is_module_text_address - is this address inside module code?
@@ -2798,6 +2799,7 @@ struct module *__module_text_address(unsigned long addr)
 	}
 	return mod;
 }
+EXPORT_SYMBOL_GPL(__module_text_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index c1d0ed3..a35f940 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1801,6 +1801,7 @@ inline int task_curr(const struct task_struct *p)
 {
 	return cpu_curr(task_cpu(p)) == p;
 }
+EXPORT_SYMBOL_GPL(task_curr);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
diff --git a/lib/bug.c b/lib/bug.c
index 300e41a..c8491f9 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -124,6 +124,7 @@ const struct bug_entry *find_bug(unsigned long bugaddr)
 
 	return module_find_bug(bugaddr);
 }
+EXPORT_SYMBOL_GPL(find_bug);
 
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
-- 
1.6.1.3

