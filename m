Return-Path: <linux-kernel-owner+w=401wt.eu-S1763914AbYCGWgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763914AbYCGWgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbYCGWfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:35:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:62929 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbYCGWfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:35:46 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/2] kgdb: fix several kgdb regressions
Date: Fri,  7 Mar 2008 16:34:16 -0600
Message-Id: <1204929257-9967-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204929257-9967-1-git-send-email-jason.wessel@windriver.com>
References: <1204929257-9967-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Mar 2008 22:34:18.0546 (UTC) FILETIME=[61986120:01C880A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kgdb core fixes:
- Check to see that mm->mmap_cache is not null before calling
  flush_cache_range(), else on arch=ARM it will cause a fatal
  fault.

- Breakpoints should only be restored if they are in the BP_ACTIVE
  state.

- Fix a typo in comments to "kgdb_register_io_module"

x86 kgdb fixes:
- Fix the x86 arch handler such that on a kill or detach that the
  appropriate cleanup on the single stepping flags gets run.

- Add in the DIE_NMIWATCHDOG call for x86_64

- Touch the nmi watchdog before returning the system to normal
  operation after performing any kind of kgdb operation, else
  the possibility exists to trigger the watchdog.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c     |    4 ++++
 arch/x86/kernel/traps_64.c |    7 ++++++-
 kernel/kgdb.c              |   14 ++++++++------
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 7d651ad..8c7e555 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -370,6 +370,8 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 		ptr = &remcomInBuffer[1];
 		if (kgdb_hex2long(&ptr, &addr))
 			linux_regs->ip = addr;
+	case 'D':
+	case 'k':
 		newPC = linux_regs->ip;
 
 		/* clear the trace bit */
@@ -480,6 +482,8 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 	if (kgdb_handle_exception(args->trapnr, args->signr, args->err, regs))
 		return NOTIFY_DONE;
 
+	/* Must touch watchdog before return to normal operation */
+	touch_nmi_watchdog();
 	return NOTIFY_STOP;
 }
 
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 055b165..4e07332 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -600,8 +600,13 @@ void die(const char * str, struct pt_regs * regs, long err)
 
 void __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
-	unsigned long flags = oops_begin();
+	unsigned long flags;
+
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) ==
+	    NOTIFY_STOP)
+		return;
 
+	flags = oops_begin();
 	/*
 	 * We are in trouble anyway, lets at least try
 	 * to get a message out.
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 31425e0..85b7e5b 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -600,7 +600,7 @@ static void kgdb_flush_swbreak_addr(unsigned long addr)
 	if (!CACHE_FLUSH_IS_SAFE)
 		return;
 
-	if (current->mm) {
+	if (current->mm && current->mm->mmap_cache) {
 		flush_cache_range(current->mm->mmap_cache,
 				  addr, addr + BREAK_INSTR_SIZE);
 	} else {
@@ -729,14 +729,16 @@ int remove_all_break(void)
 
 	/* Clear memory breakpoints. */
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
-		if (kgdb_break[i].state != BP_SET)
-			continue;
+		if (kgdb_break[i].state != BP_ACTIVE)
+			goto setundefined;
 		addr = kgdb_break[i].bpt_addr;
 		error = kgdb_arch_remove_breakpoint(addr,
 				kgdb_break[i].saved_instr);
 		if (error)
-			return error;
-		kgdb_break[i].state = BP_REMOVED;
+			printk(KERN_ERR "KGDB: breakpoint remove failed: %lx\n",
+			   addr);
+setundefined:
+		kgdb_break[i].state = BP_UNDEFINED;
 	}
 
 	/* Clear hardware breakpoints. */
@@ -1605,7 +1607,7 @@ static void kgdb_initial_breakpoint(void)
 }
 
 /**
- *	kkgdb_register_io_module - register KGDB IO module
+ *	kgdb_register_io_module - register KGDB IO module
  *	@new_kgdb_io_ops: the io ops vector
  *
  *	Register it with the KGDB core.
-- 
1.5.4

