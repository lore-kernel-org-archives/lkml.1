Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZKJK0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZKJK0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZKJK0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:26:06 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63374 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZKJK0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:26:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MUTVT/CW3iujeUFsQoWq9x6XX9TrbY3of6q/fpq/1vEu2wGAqCX2hi2YiZNsQ2huEc
         02VYjp56SZ9DVxUyadO1NsPSiEHKMUJPY3IDLGs1h03McFJvFCPuaW43oekwQ3dQDwXI
         zXXlycX4zNM6NwFINaSfSqDhjtoO8WJZawEl0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 3/4] hw-breakpoints: Fix broken hw-breakpoint sample module
Date: Tue, 10 Nov 2009 11:25:59 +0100
Message-Id: <1257848760-9407-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
References: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw-breakpoint sample module has been broken during the
hw-breakpoint internals refactoring. Propagate the changes
to it.

Reported-by: "K. Prasad" <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hw_breakpoint.c                  |    3 +-
 kernel/kallsyms.c                       |    1 +
 samples/hw_breakpoint/data_breakpoint.c |   43 +++++++++++++++++-------------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index e662dc9..9ea9414 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -454,6 +454,7 @@ fail:
 	/* return the error if any */
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 
 /**
  * unregister_wide_hw_breakpoint - unregister a wide breakpoint in the kernel
@@ -470,7 +471,7 @@ void unregister_wide_hw_breakpoint(struct perf_event **cpu_events)
 	}
 	free_percpu(cpu_events);
 }
-
+EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
 
 static struct notifier_block hw_breakpoint_exceptions_nb = {
 	.notifier_call = hw_breakpoint_exceptions_notify,
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 8b6b8b6..8e5288a 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -181,6 +181,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	}
 	return module_kallsyms_lookup_name(name);
 }
+EXPORT_SYMBOL_GPL(kallsyms_lookup_name);
 
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 9cbdbb8..5bc9819 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -27,18 +27,19 @@
 #include <linux/module.h>	/* Needed by all modules */
 #include <linux/kernel.h>	/* Needed for KERN_INFO */
 #include <linux/init.h>		/* Needed for the macros */
+#include <linux/kallsyms.h>
 
-#include <asm/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
 
-struct hw_breakpoint sample_hbp;
+struct perf_event **sample_hbp;
 
 static char ksym_name[KSYM_NAME_LEN] = "pid_max";
 module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
 MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
 			" write operations on the kernel symbol");
 
-void sample_hbp_handler(struct hw_breakpoint *temp, struct pt_regs
-								*temp_regs)
+static void sample_hbp_handler(struct perf_event *temp, void *data)
 {
 	printk(KERN_INFO "%s value is changed\n", ksym_name);
 	dump_stack();
@@ -48,30 +49,34 @@ void sample_hbp_handler(struct hw_breakpoint *temp, struct pt_regs
 static int __init hw_break_module_init(void)
 {
 	int ret;
+	unsigned long addr;
 
-#ifdef CONFIG_X86
-	sample_hbp.info.name = ksym_name;
-	sample_hbp.info.type = HW_BREAKPOINT_WRITE;
-	sample_hbp.info.len = HW_BREAKPOINT_LEN_4;
-#endif /* CONFIG_X86 */
+	addr = kallsyms_lookup_name(ksym_name);
 
-	sample_hbp.triggered = (void *)sample_hbp_handler;
+	sample_hbp = register_wide_hw_breakpoint(addr, HW_BREAKPOINT_LEN_4,
+						 HW_BREAKPOINT_W | HW_BREAKPOINT_R,
+						 sample_hbp_handler, true);
+	if (IS_ERR(sample_hbp)) {
+		ret = PTR_ERR(sample_hbp);
+		goto fail;
+	} else if (!sample_hbp) {
+		ret = -EINVAL;
+		goto fail;
+	}
 
-	ret = register_kernel_hw_breakpoint(&sample_hbp);
-
-	if (ret < 0) {
-		printk(KERN_INFO "Breakpoint registration failed\n");
-		return ret;
-	} else
-		printk(KERN_INFO "HW Breakpoint for %s write installed\n",
-								ksym_name);
+	printk(KERN_INFO "HW Breakpoint for %s write installed\n", ksym_name);
 
 	return 0;
+
+fail:
+	printk(KERN_INFO "Breakpoint registration failed\n");
+
+	return ret;
 }
 
 static void __exit hw_break_module_exit(void)
 {
-	unregister_kernel_hw_breakpoint(&sample_hbp);
+	unregister_wide_hw_breakpoint(sample_hbp);
 	printk(KERN_INFO "HW Breakpoint for %s write uninstalled\n", ksym_name);
 }
 
-- 
1.6.2.3

