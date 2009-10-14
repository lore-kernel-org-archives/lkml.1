Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZJNGEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZJNGEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZJNGEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:04:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:58704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbZJNGD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:59 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: [PATCH 12/16] percpu: make misc percpu symbols unique
Date: Wed, 14 Oct 2009 15:02:01 +0900
Message-Id: <1255500125-3210-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates misc percpu related symbols such that percpu
symbols are unique and don't clash with local symbols.  This serves
two purposes of decreasing the possibility of global percpu symbol
collision and allowing dropping per_cpu__ prefix from percpu symbols.

* drivers/crypto/padlock-aes.c: s/last_cword/paes_last_cword/

* drivers/lguest/x86/core.c: s/last_cpu/lg_last_cpu/

* drivers/s390/net/netiucv.c: rename the variable used in a macro to
  avoid clashing with percpu symbol

* arch/mn10300/kernel/kprobes.c: replace current_ prefix with cur_ for
  static variables.  Please note that percpu symbol current_kprobe
  can't be changed as it's used by generic code.

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
---
 arch/mn10300/kernel/kprobes.c |   61 ++++++++++++++++++++---------------------
 drivers/crypto/padlock-aes.c  |   12 ++++----
 drivers/lguest/x86/core.c     |    6 ++--
 drivers/s390/net/netiucv.c    |    8 ++---
 4 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/arch/mn10300/kernel/kprobes.c b/arch/mn10300/kernel/kprobes.c
index dacafab..67e6389 100644
--- a/arch/mn10300/kernel/kprobes.c
+++ b/arch/mn10300/kernel/kprobes.c
@@ -31,13 +31,13 @@ const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 #define KPROBE_HIT_ACTIVE	0x00000001
 #define KPROBE_HIT_SS		0x00000002
 
-static struct kprobe *current_kprobe;
-static unsigned long current_kprobe_orig_pc;
-static unsigned long current_kprobe_next_pc;
-static int current_kprobe_ss_flags;
+static struct kprobe *cur_kprobe;
+static unsigned long cur_kprobe_orig_pc;
+static unsigned long cur_kprobe_next_pc;
+static int cur_kprobe_ss_flags;
 static unsigned long kprobe_status;
-static kprobe_opcode_t current_kprobe_ss_buf[MAX_INSN_SIZE + 2];
-static unsigned long current_kprobe_bp_addr;
+static kprobe_opcode_t cur_kprobe_ss_buf[MAX_INSN_SIZE + 2];
+static unsigned long cur_kprobe_bp_addr;
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 
@@ -399,26 +399,25 @@ void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
 	unsigned long nextpc;
 
-	current_kprobe_orig_pc = regs->pc;
-	memcpy(current_kprobe_ss_buf, &p->ainsn.insn[0], MAX_INSN_SIZE);
-	regs->pc = (unsigned long) current_kprobe_ss_buf;
+	cur_kprobe_orig_pc = regs->pc;
+	memcpy(cur_kprobe_ss_buf, &p->ainsn.insn[0], MAX_INSN_SIZE);
+	regs->pc = (unsigned long) cur_kprobe_ss_buf;
 
-	nextpc = find_nextpc(regs, &current_kprobe_ss_flags);
-	if (current_kprobe_ss_flags & SINGLESTEP_PCREL)
-		current_kprobe_next_pc =
-			current_kprobe_orig_pc + (nextpc - regs->pc);
+	nextpc = find_nextpc(regs, &cur_kprobe_ss_flags);
+	if (cur_kprobe_ss_flags & SINGLESTEP_PCREL)
+		cur_kprobe_next_pc = cur_kprobe_orig_pc + (nextpc - regs->pc);
 	else
-		current_kprobe_next_pc = nextpc;
+		cur_kprobe_next_pc = nextpc;
 
 	/* branching instructions need special handling */
-	if (current_kprobe_ss_flags & SINGLESTEP_BRANCH)
+	if (cur_kprobe_ss_flags & SINGLESTEP_BRANCH)
 		nextpc = singlestep_branch_setup(regs);
 
-	current_kprobe_bp_addr = nextpc;
+	cur_kprobe_bp_addr = nextpc;
 
 	*(u8 *) nextpc = BREAKPOINT_INSTRUCTION;
-	mn10300_dcache_flush_range2((unsigned) current_kprobe_ss_buf,
-				    sizeof(current_kprobe_ss_buf));
+	mn10300_dcache_flush_range2((unsigned) cur_kprobe_ss_buf,
+				    sizeof(cur_kprobe_ss_buf));
 	mn10300_icache_inv();
 }
 
@@ -440,7 +439,7 @@ static inline int __kprobes kprobe_handler(struct pt_regs *regs)
 			disarm_kprobe(p, regs);
 			ret = 1;
 		} else {
-			p = current_kprobe;
+			p = cur_kprobe;
 			if (p->break_handler && p->break_handler(p, regs))
 				goto ss_probe;
 		}
@@ -464,7 +463,7 @@ static inline int __kprobes kprobe_handler(struct pt_regs *regs)
 	}
 
 	kprobe_status = KPROBE_HIT_ACTIVE;
-	current_kprobe = p;
+	cur_kprobe = p;
 	if (p->pre_handler(p, regs)) {
 		/* handler has already set things up, so skip ss setup */
 		return 1;
@@ -491,8 +490,8 @@ no_kprobe:
 static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
 {
 	/* we may need to fixup regs/stack after singlestepping a call insn */
-	if (current_kprobe_ss_flags & SINGLESTEP_BRANCH) {
-		regs->pc = current_kprobe_orig_pc;
+	if (cur_kprobe_ss_flags & SINGLESTEP_BRANCH) {
+		regs->pc = cur_kprobe_orig_pc;
 		switch (p->ainsn.insn[0]) {
 		case 0xcd:	/* CALL (d16,PC) */
 			*(unsigned *) regs->sp = regs->mdr = regs->pc + 5;
@@ -523,8 +522,8 @@ static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
 		}
 	}
 
-	regs->pc = current_kprobe_next_pc;
-	current_kprobe_bp_addr = 0;
+	regs->pc = cur_kprobe_next_pc;
+	cur_kprobe_bp_addr = 0;
 }
 
 static inline int __kprobes post_kprobe_handler(struct pt_regs *regs)
@@ -532,10 +531,10 @@ static inline int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	if (!kprobe_running())
 		return 0;
 
-	if (current_kprobe->post_handler)
-		current_kprobe->post_handler(current_kprobe, regs, 0);
+	if (cur_kprobe->post_handler)
+		cur_kprobe->post_handler(cur_kprobe, regs, 0);
 
-	resume_execution(current_kprobe, regs);
+	resume_execution(cur_kprobe, regs);
 	reset_current_kprobe();
 	preempt_enable_no_resched();
 	return 1;
@@ -545,12 +544,12 @@ static inline int __kprobes post_kprobe_handler(struct pt_regs *regs)
 static inline
 int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
-	if (current_kprobe->fault_handler &&
-	    current_kprobe->fault_handler(current_kprobe, regs, trapnr))
+	if (cur_kprobe->fault_handler &&
+	    cur_kprobe->fault_handler(cur_kprobe, regs, trapnr))
 		return 1;
 
 	if (kprobe_status & KPROBE_HIT_SS) {
-		resume_execution(current_kprobe, regs);
+		resume_execution(cur_kprobe, regs);
 		reset_current_kprobe();
 		preempt_enable_no_resched();
 	}
@@ -567,7 +566,7 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 
 	switch (val) {
 	case DIE_BREAKPOINT:
-		if (current_kprobe_bp_addr != args->regs->pc) {
+		if (cur_kprobe_bp_addr != args->regs->pc) {
 			if (kprobe_handler(args->regs))
 				return NOTIFY_STOP;
 		} else {
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index a9952b1..721d004 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -64,7 +64,7 @@ struct aes_ctx {
 	u32 *D;
 };
 
-static DEFINE_PER_CPU(struct cword *, last_cword);
+static DEFINE_PER_CPU(struct cword *, paes_last_cword);
 
 /* Tells whether the ACE is capable to generate
    the extended key for a given key_len. */
@@ -152,9 +152,9 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 ok:
 	for_each_online_cpu(cpu)
-		if (&ctx->cword.encrypt == per_cpu(last_cword, cpu) ||
-		    &ctx->cword.decrypt == per_cpu(last_cword, cpu))
-			per_cpu(last_cword, cpu) = NULL;
+		if (&ctx->cword.encrypt == per_cpu(paes_last_cword, cpu) ||
+		    &ctx->cword.decrypt == per_cpu(paes_last_cword, cpu))
+			per_cpu(paes_last_cword, cpu) = NULL;
 
 	return 0;
 }
@@ -166,7 +166,7 @@ static inline void padlock_reset_key(struct cword *cword)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (cword != per_cpu(last_cword, cpu))
+	if (cword != per_cpu(paes_last_cword, cpu))
 #ifndef CONFIG_X86_64
 		asm volatile ("pushfl; popfl");
 #else
@@ -176,7 +176,7 @@ static inline void padlock_reset_key(struct cword *cword)
 
 static inline void padlock_store_cword(struct cword *cword)
 {
-	per_cpu(last_cword, raw_smp_processor_id()) = cword;
+	per_cpu(paes_last_cword, raw_smp_processor_id()) = cword;
 }
 
 /*
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 6ae3888..fb2b7ef 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -69,7 +69,7 @@ static struct lguest_pages *lguest_pages(unsigned int cpu)
 		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
 }
 
-static DEFINE_PER_CPU(struct lg_cpu *, last_cpu);
+static DEFINE_PER_CPU(struct lg_cpu *, lg_last_cpu);
 
 /*S:010
  * We approach the Switcher.
@@ -90,8 +90,8 @@ static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
 	 * meanwhile).  If that's not the case, we pretend everything in the
 	 * Guest has changed.
 	 */
-	if (__get_cpu_var(last_cpu) != cpu || cpu->last_pages != pages) {
-		__get_cpu_var(last_cpu) = cpu;
+	if (__get_cpu_var(lg_last_cpu) != cpu || cpu->last_pages != pages) {
+		__get_cpu_var(lg_last_cpu) = cpu;
 		cpu->last_pages = pages;
 		cpu->changed = CHANGED_ALL;
 	}
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index c84eadd..14e6144 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -113,11 +113,9 @@ static inline int iucv_dbf_passes(debug_info_t *dbf_grp, int level)
 #define IUCV_DBF_TEXT_(name, level, text...) \
 	do { \
 		if (iucv_dbf_passes(iucv_dbf_##name, level)) { \
-			char* iucv_dbf_txt_buf = \
-					get_cpu_var(iucv_dbf_txt_buf); \
-			sprintf(iucv_dbf_txt_buf, text); \
-			debug_text_event(iucv_dbf_##name, level, \
-						iucv_dbf_txt_buf); \
+			char* __buf = get_cpu_var(iucv_dbf_txt_buf); \
+			sprintf(__buf, text); \
+			debug_text_event(iucv_dbf_##name, level, __buf); \
 			put_cpu_var(iucv_dbf_txt_buf); \
 		} \
 	} while (0)
-- 
1.6.4.2

