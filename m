Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbXHWWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbXHWWfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXHWW3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33135 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXHWW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:06 -0400
Date: Thu, 23 Aug 2007 15:27:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/28] SPARC64: Fix sparc64 task stack traces.
Message-ID: <20070823222706.GP18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-sparc64-task-stack-traces.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

It didn't handle that case at all, and now dump_stack()
can be implemented directly as show_stack(current, NULL)

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/traps.c |   18 +++++++++++-------
 arch/sparc64/mm/fault.c     |    5 +----
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -2134,12 +2134,20 @@ static void user_instruction_dump (unsig
 void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 {
 	unsigned long pc, fp, thread_base, ksp;
-	void *tp = task_stack_page(tsk);
+	struct thread_info *tp;
 	struct reg_window *rw;
 	int count = 0;
 
 	ksp = (unsigned long) _ksp;
-
+	if (!tsk)
+		tsk = current;
+	tp = task_thread_info(tsk);
+	if (ksp == 0UL) {
+		if (tsk == current)
+			asm("mov %%fp, %0" : "=r" (ksp));
+		else
+			ksp = tp->ksp;
+	}
 	if (tp == current_thread_info())
 		flushw_all();
 
@@ -2168,11 +2176,7 @@ void show_stack(struct task_struct *tsk,
 
 void dump_stack(void)
 {
-	unsigned long *ksp;
-
-	__asm__ __volatile__("mov	%%fp, %0"
-			     : "=r" (ksp));
-	show_stack(current, ksp);
+	show_stack(current, NULL);
 }
 
 EXPORT_SYMBOL(dump_stack);
--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -112,15 +112,12 @@ static void __kprobes unhandled_fault(un
 
 static void bad_kernel_pc(struct pt_regs *regs, unsigned long vaddr)
 {
-	unsigned long *ksp;
-
 	printk(KERN_CRIT "OOPS: Bogus kernel PC [%016lx] in fault handler\n",
 	       regs->tpc);
 	printk(KERN_CRIT "OOPS: RPC [%016lx]\n", regs->u_regs[15]);
 	print_symbol("RPC: <%s>\n", regs->u_regs[15]);
 	printk(KERN_CRIT "OOPS: Fault was to vaddr[%lx]\n", vaddr);
-	__asm__("mov %%sp, %0" : "=r" (ksp));
-	show_stack(current, ksp);
+	dump_stack();
 	unhandled_fault(regs->tpc, current, regs);
 }
 

-- 
