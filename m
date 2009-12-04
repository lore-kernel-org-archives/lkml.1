Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbZLDWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbZLDWaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZLDWao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:30:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405AbZLDWan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:30:43 -0500
Message-ID: <4B198DF3.40808@gmail.com>
Date: Fri, 04 Dec 2009 23:32:19 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: linux@arm.linux.org.uk, vapier@gentoo.org, ralf@linux-mips.org,
       lethal@linux-sh.org, davem@davemloft.net, tglx@linutronix.de,
       jason.wessel@windriver.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/31] Constify struct kgdb_arch for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct kgdb_arch with some exceptions.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/arm/kernel/kgdb.c      |    2 +-
 arch/blackfin/kernel/kgdb.c |    2 +-
 arch/mips/kernel/kgdb.c     |    1 +
 arch/powerpc/kernel/kgdb.c  |    4 ++--
 arch/sh/kernel/kgdb.c       |    2 +-
 arch/sparc/kernel/kgdb_32.c |    2 +-
 arch/sparc/kernel/kgdb_64.c |    2 +-
 arch/x86/kernel/kgdb.c      |    2 +-
 include/linux/kgdb.h        |    2 +-
 9 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index ba8ccfe..2dc34dc 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -190,7 +190,7 @@ void kgdb_arch_exit(void)
  * and we handle the normal undef case within the do_undefinstr
  * handler.
  */
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 #ifndef __ARMEB__
 	.gdb_bpt_instr		= {0xfe, 0xde, 0xff, 0xe7}
 #else /* ! __ARMEB__ */
diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index cce79d0..c406c85 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -428,7 +428,7 @@ int kgdb_arch_handle_exception(int vector, int signo,
 	return -1;		/* this means that we do not want to exit from the handler */
 }
 
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	.gdb_bpt_instr = {0xa1},
 #ifdef CONFIG_SMP
 	.flags = KGDB_HW_BREAKPOINT|KGDB_THR_PROC_SWAP,
diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 50c9bb8..efdd5f8 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -245,6 +245,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 	return -1;
 }
 
+/* cannot be const */
 struct kgdb_arch arch_kgdb_ops;
 
 /*
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 641c74b..8339ad7 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -126,7 +126,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
 		return 0;
 
-	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
+	if (*(u32 *) (regs->nip) == *(const u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
 		regs->nip += 4;
 
 	return 1;
@@ -353,7 +353,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 /*
  * Global data
  */
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	.gdb_bpt_instr = {0x7d, 0x82, 0x10, 0x08},
 };
 
diff --git a/arch/sh/kernel/kgdb.c b/arch/sh/kernel/kgdb.c
index 3e532d0..9faa306 100644
--- a/arch/sh/kernel/kgdb.c
+++ b/arch/sh/kernel/kgdb.c
@@ -271,7 +271,7 @@ void kgdb_arch_exit(void)
 {
 }
 
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: trapa #0x3c */
 #ifdef CONFIG_CPU_LITTLE_ENDIAN
 	.gdb_bpt_instr		= { 0x3c, 0xc3 },
diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
index 04df4ed..55c4b6e 100644
--- a/arch/sparc/kernel/kgdb_32.c
+++ b/arch/sparc/kernel/kgdb_32.c
@@ -158,7 +158,7 @@ void kgdb_arch_exit(void)
 {
 }
 
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x7d */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x7d },
 };
diff --git a/arch/sparc/kernel/kgdb_64.c b/arch/sparc/kernel/kgdb_64.c
index f5a0fd4..d886f71 100644
--- a/arch/sparc/kernel/kgdb_64.c
+++ b/arch/sparc/kernel/kgdb_64.c
@@ -180,7 +180,7 @@ void kgdb_arch_exit(void)
 {
 }
 
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x72 */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x72 },
 };
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8d82a77..92e532c 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -573,7 +573,7 @@ unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
 	return instruction_pointer(regs);
 }
 
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },
 	.flags			= KGDB_HW_BREAKPOINT,
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..360613c 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -259,7 +259,7 @@ struct kgdb_io {
 	void			(*post_exception) (void);
 };
 
-extern struct kgdb_arch		arch_kgdb_ops;
+extern const struct kgdb_arch arch_kgdb_ops;
 
 extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
 

