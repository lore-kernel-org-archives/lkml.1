Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZLIJ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZLIJ6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZLIJ6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:58:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:45779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbZLIJ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:53 -0500
Date: Wed, 9 Dec 2009 09:56:44 GMT
From: tip-bot for Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       hancockrwd@gmail.com, arjan@linux.intel.com, rz@linux-m68k.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adi@hexapodia.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hancockrwd@gmail.com, rz@linux-m68k.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adi@hexapodia.org
In-Reply-To: <20091208082942.GA27174@hexapodia.org>
References: <20091208082942.GA27174@hexapodia.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Factor duplicated code out of __show_regs() into show_regs_common()
Message-ID: <tip-814e2c84a722c45650a9b8f52285d7ba6874f63b@git.kernel.org>
Git-Commit-ID: 814e2c84a722c45650a9b8f52285d7ba6874f63b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  814e2c84a722c45650a9b8f52285d7ba6874f63b
Gitweb:     http://git.kernel.org/tip/814e2c84a722c45650a9b8f52285d7ba6874f63b
Author:     Andy Isaacson <adi@hexapodia.org>
AuthorDate: Tue, 8 Dec 2009 00:29:42 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:17:58 +0100

x86: Factor duplicated code out of __show_regs() into show_regs_common()

Unify x86_32 and x86_64 implementations of __show_regs() header,
standardizing on the x86_64 format string in the process. Also,
32-bit will now call print_modules.

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: Richard Zidlicky <rz@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20091208082942.GA27174@hexapodia.org>
[ v2: resolved conflict ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system.h |    1 +
 arch/x86/kernel/process.c     |   18 ++++++++++++++++++
 arch/x86/kernel/process_32.c  |   14 +-------------
 arch/x86/kernel/process_64.c  |   16 ++--------------
 4 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 022a843..ecb544e 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -23,6 +23,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
+extern void show_regs_common(void);
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5e2ba63..90cf125 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -10,6 +10,8 @@
 #include <linux/clockchips.h>
 #include <linux/random.h>
 #include <linux/user-return-notifier.h>
+#include <linux/dmi.h>
+#include <linux/utsname.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/system.h>
@@ -90,6 +92,22 @@ void exit_thread(void)
 	}
 }
 
+void show_regs_common(void)
+{
+	const char *board;
+
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!board)
+		board = "";
+
+	printk("\n");
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version, board);
+}
+
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 075580b..120b887 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -23,7 +23,6 @@
 #include <linux/vmalloc.h>
 #include <linux/user.h>
 #include <linux/interrupt.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
@@ -35,7 +34,6 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
-#include <linux/dmi.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
@@ -128,7 +126,6 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned long sp;
 	unsigned short ss, gs;
-	const char *board;
 
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
@@ -140,16 +137,7 @@ void __show_regs(struct pt_regs *regs, int all)
 		savesegment(gs, gs);
 	}
 
-	printk("\n");
-
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!board)
-		board = "";
-	printk("Pid: %d, comm: %s %s (%s %.*s) %s\n",
-			task_pid_nr(current), current->comm,
-			print_tainted(), init_utsname()->release,
-			(int)strcspn(init_utsname()->version, " "),
-			init_utsname()->version, board);
+	show_regs_common();
 
 	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c95c8f4..e5ab0cd 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/interrupt.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
@@ -38,7 +37,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
-#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -163,18 +161,8 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
-	const char *board;
-
-	printk("\n");
-	print_modules();
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!board)
-		board = "";
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version, board);
+
+	show_regs_common();
 	printk(KERN_INFO "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_INFO "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
