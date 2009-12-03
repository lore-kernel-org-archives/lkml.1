Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZLCVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZLCVOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZLCVOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:14:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZLCVOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:14:52 -0500
Date: Thu, 3 Dec 2009 22:14:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86/process for v2.6.33
Message-ID: <20091203211443.GA15049@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-process-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-process-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86-64: make compat_start_thread() match start_thread()
      x86-64: merge the standard and compat start_thread() functions


 arch/x86/include/asm/elf.h   |   20 ++------------------
 arch/x86/kernel/process_64.c |   32 ++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 456a304..8a024ba 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -157,19 +157,6 @@ do {						\
 
 #define compat_elf_check_arch(x)	elf_check_arch_ia32(x)
 
-static inline void start_ia32_thread(struct pt_regs *regs, u32 ip, u32 sp)
-{
-	loadsegment(fs, 0);
-	loadsegment(ds, __USER32_DS);
-	loadsegment(es, __USER32_DS);
-	load_gs_index(0);
-	regs->ip = ip;
-	regs->sp = sp;
-	regs->flags = X86_EFLAGS_IF;
-	regs->cs = __USER32_CS;
-	regs->ss = __USER32_DS;
-}
-
 static inline void elf_common_init(struct thread_struct *t,
 				   struct pt_regs *regs, const u16 ds)
 {
@@ -191,11 +178,8 @@ do {							\
 #define	COMPAT_ELF_PLAT_INIT(regs, load_addr)		\
 	elf_common_init(&current->thread, regs, __USER_DS)
 
-#define	compat_start_thread(regs, ip, sp)		\
-do {							\
-	start_ia32_thread(regs, ip, sp);		\
-	set_fs(USER_DS);				\
-} while (0)
+void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp);
+#define compat_start_thread start_thread_ia32
 
 #define COMPAT_SET_PERSONALITY(ex)			\
 do {							\
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..eb261c5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -344,26 +344,42 @@ out:
 	return err;
 }
 
-void
-start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
+static void
+start_thread_common(struct pt_regs *regs, unsigned long new_ip,
+		    unsigned long new_sp,
+		    unsigned int _cs, unsigned int _ss, unsigned int _ds)
 {
 	loadsegment(fs, 0);
-	loadsegment(es, 0);
-	loadsegment(ds, 0);
+	loadsegment(es, _ds);
+	loadsegment(ds, _ds);
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
 	percpu_write(old_rsp, new_sp);
-	regs->cs		= __USER_CS;
-	regs->ss		= __USER_DS;
-	regs->flags		= 0x200;
+	regs->cs		= _cs;
+	regs->ss		= _ss;
+	regs->flags		= X86_EFLAGS_IF;
 	set_fs(USER_DS);
 	/*
 	 * Free the old FP and other extended state
 	 */
 	free_thread_xstate(current);
 }
-EXPORT_SYMBOL_GPL(start_thread);
+
+void
+start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
+{
+	start_thread_common(regs, new_ip, new_sp,
+			    __USER_CS, __USER_DS, 0);
+}
+
+#ifdef CONFIG_IA32_EMULATION
+void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
+{
+	start_thread_common(regs, new_ip, new_sp,
+			    __USER32_CS, __USER32_DS, __USER32_DS);
+}
+#endif
 
 /*
  *	switch_to(x,y) should switch tasks from x to y.
