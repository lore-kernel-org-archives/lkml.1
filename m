Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZJIBLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZJIBLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbZJIBLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:11:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760127AbZJIBLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:11:07 -0400
Message-ID: <4ACE8D51.1080606@zytor.com>
Date: Thu, 08 Oct 2009 18:09:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC] x86-64: make compat_start_thread() match start_thread()
Content-Type: multipart/mixed;
 boundary="------------070708070503040007070003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070708070503040007070003
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[This is an RFC post; I intend to commit this tomorrow but I would
appreciate anyone looking over it.]

--------------070708070503040007070003
Content-Type: text/x-patch;
 name="0001-x86-64-make-compat_start_thread-match-start_threa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-64-make-compat_start_thread-match-start_threa.patch"

>From c843d5b6bd5923b91359e4806f5fca905774b41f Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Thu, 8 Oct 2009 18:02:54 -0700
Subject: [PATCH] x86-64: make compat_start_thread() match start_thread()

For no real good reason, compat_start_thread() was embedded inline in
<asm/elf.h> whereas the native start_thread() lives in process_*.c.
Move compat_start_thread() to process_64.c, remove gratuitious
differences, and fix a few items which mostly look like bit rot.

In particular, compat_start_thread() didn't do free_thread_xstate(),
which means it was hanging on to the xstate store area even when it
was not needed.  It was also not setting old_rsp, but it looks like
that generally shouldn't matter for a 32-bit process.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/elf.h   |   19 +------------------
 arch/x86/kernel/process_64.c |   23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 456a304..5a5d541 100644
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
@@ -191,11 +178,7 @@ do {							\
 #define	COMPAT_ELF_PLAT_INIT(regs, load_addr)		\
 	elf_common_init(&current->thread, regs, __USER_DS)
 
-#define	compat_start_thread(regs, ip, sp)		\
-do {							\
-	start_ia32_thread(regs, ip, sp);		\
-	set_fs(USER_DS);				\
-} while (0)
+void compat_start_thread(struct pt_regs *regs, u32 new_ip, u32 new_sp);
 
 #define COMPAT_SET_PERSONALITY(ex)			\
 do {							\
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..ec223a8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -356,7 +356,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	percpu_write(old_rsp, new_sp);
 	regs->cs		= __USER_CS;
 	regs->ss		= __USER_DS;
-	regs->flags		= 0x200;
+	regs->flags		= X86_EFLAGS_IF;
 	set_fs(USER_DS);
 	/*
 	 * Free the old FP and other extended state
@@ -365,6 +365,27 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
+#ifdef CONFIG_IA32_EMULATION
+void compat_start_thread(struct pt_regs *regs, u32 new_ip, u32 new_sp)
+{
+	loadsegment(fs, 0);
+	loadsegment(ds, __USER32_DS);
+	loadsegment(es, __USER32_DS);
+	load_gs_index(0);
+	regs->ip		= new_ip;
+	regs->sp		= new_sp;
+	percpu_write(old_rsp, new_sp);
+	regs->cs		= __USER32_CS;
+	regs->ss		= __USER32_DS;
+	regs->flags		= X86_EFLAGS_IF;
+	set_fs(USER_DS);
+	/*
+	 * Free the old FP and other extended state
+	 */
+	free_thread_xstate(current);
+}
+#endif
+
 /*
  *	switch_to(x,y) should switch tasks from x to y.
  *
-- 
1.6.2.5


--------------070708070503040007070003--
