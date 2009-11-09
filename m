Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZKIPdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZKIPdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbZKIPdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:33:52 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39623 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbZKIPdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:33:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v3O0xgbtsXMhGTnlC+DwqGPghSu7ORQ2607Kwj49sMFcviVyEsP9YbkKgzv9di8DVO
         EJEna4qSupsjMOBDh9QnM3x7eFE5JOvqMXFzmiLwuFyzVbuLH73I/z/+g3Z0Fj8G9mcA
         sbPqHaUWjjNpqJqxbNxhGlDopc6Lnqx31tdy0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: zhangfx@lemote.com, zhouqg@gmail.com, Wu Zhangjin <wuzhangjin@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH v7 17/17] tracing: make function graph tracer work with -mmcount-ra-address
Date: Mon,  9 Nov 2009 23:31:34 +0800
Message-Id: <2113f5f0165feac8cf58c156946adff776f9056d.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <ceef672f082971118c472d1c079d49762ae43b38.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
 <6199d7b3956b544fc65896af1062787a2e1283ce.1257779502.git.wuzhangjin@gmail.com>
 <58a7558730fbea6cd0417100c8fcd6f45668d1e3.1257779502.git.wuzhangjin@gmail.com>
 <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com>
 <0cef783a71333ff96a78aaea8961e3b6b5392665.1257779502.git.wuzhangjin@gmail.com>
 <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com>
 <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com>
 <d4aa4cdb9b4c25e7a683c923bdeabed847bd8010.1257779502.git.wuzhangjin@gmail.com>
 <451c55dead5d6afd871de6afd14dbbcf70a0f834.1257779502.git.wuzhangjin@gmail.com>
 <0c463e2af521e613fd15751a9f610c74cf887292.1257779502.git.wuzhangjin@gmail.com>
 <695747bff7cddb97d6f43c05c4cf05eb269e402d.1257779502.git.wuzhangjin@gmail.com>
 <406a8e5e3117737e401bb2bba84ad9b17f99857d.1257779502.git.wuzhangjin@gmail.com>
 <ceef672f082971118c472d1c079d49762ae43b38.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1257779502.git.wuzhangjin@gmail.com>
References: <cover.1257779502.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

That thread "MIPS: Add option to pass return address location to
_mcount" from "David Daney <ddaney@caviumnetworks.com>" have added a new
option -mmcount-ra-address to gcc(4.5) for MIPS to transfer the location
of the return address to _mcount.

Benefit from this new feature, function graph tracer on MIPS will be
easier and safer to hijack the return address of the kernel function,
which will save some overhead and make the whole thing more reliable.

In this patch, at first, try to enable the option -mmcount-ra-address in
arch/mips/Makefile with cc-option, if gcc support it, it will be
enabled, otherwise, not side effect.

and then, we need to support this new option of gcc 4.5 and also support
the old gcc versions.

with _mcount in the old gcc versions, it's not easy to get the location
of return address(refer to 1f5db2a6932fcc7d2f6600903724e33b7bd269f3:
"tracing: add function graph tracer support for MIPS"), so, we do it in
a C function: ftrace_get_parent_addr(ftrace.c), but with
-mmcount-ra-address, only several instructions need to get what we want,
so, I put into asm(mcount.S). and also, as the $12(t0) is used by
-mmcount-ra-address for transferring the localtion of return address to
_mcount, we need to save it into the stack and restore it when enabled
dynamic function tracer, 'Cause we have called "ftrace_call" before
"ftrace_graph_caller", which may destroy $12(t0).

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Makefile        |    3 +++
 arch/mips/kernel/ftrace.c |   24 +++++++++++++++++-------
 arch/mips/kernel/mcount.S |   16 ++++++++++++++++
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 041deca..c710324 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -52,6 +52,9 @@ ifndef CONFIG_FUNCTION_TRACER
 cflags-y := -ffunction-sections
 else
 cflags-y := -mlong-calls
+ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	cflags-y += $(call cc-option, -mmcount-ra-address)
+endif
 endif
 cflags-y += $(call cc-option, -mno-check-zero-division)
 
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index a4e25b8..1dcbf0f 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -119,6 +119,7 @@ int ftrace_disable_ftrace_graph_caller(void)
 
 #endif				/* !CONFIG_DYNAMIC_FTRACE */
 
+#if (__GNUC__ <= 4 && __GNUC_MINOR__ < 5)
 #define S_RA_SP	(0xafbf << 16)	/* s{d,w} ra, offset(sp) */
 #define S_R_SP	(0xafb0 << 16)  /* s{d,w} R, offset(sp) */
 #define OFFSET_MASK	0xffff	/* stack offset range: 0 ~ PT_SIZE */
@@ -166,6 +167,8 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 	return 0;
 }
 
+#endif
+
 /*
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
@@ -183,19 +186,26 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		return;
 
 	/* "parent" is the stack address saved the return address of the caller
-	 * of _mcount, for a leaf function not save the return address in the
-	 * stack address, so, we "emulate" one in _mcount's stack space, and
-	 * hijack it directly, but for a non-leaf function, it will save the
-	 * return address to the its stack space, so, we can not hijack the
-	 * "parent" directly, but need to find the real stack address,
+	 * of _mcount.
+	 *
+	 * if the gcc < 4.5, a leaf function does not save the return address
+	 * in the stack address, so, we "emulate" one in _mcount's stack space,
+	 * and hijack it directly, but for a non-leaf function, it save the
+	 * return address to the its own stack space, we can not hijack it
+	 * directly, but need to find the real stack address,
 	 * ftrace_get_parent_addr() does it!
+	 *
+	 * if gcc>= 4.5, with the new -mmcount-ra-address option, for a
+	 * non-leaf function, the location of the return address will be saved
+	 * to $12 for us, and for a leaf function, only put a zero into $12. we
+	 * do it in ftrace_graph_caller of mcount.S.
 	 */
 
 	/* old = *parent; */
 	safe_load_stack(old, parent, faulted);
 	if (unlikely(faulted))
 		goto out;
-
+#if (__GNUC__ <= 4 && __GNUC_MINOR__ < 5)
 	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
 							 (unsigned long)parent,
 							 fp);
@@ -203,7 +213,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	 * ra, stop function graph tracer and return */
 	if (parent == 0)
 		goto out;
-
+#endif
 	/* *parent = return_hooker; */
 	safe_store_stack(return_hooker, parent, faulted);
 	if (unlikely(faulted))
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 522e91c..addd68f 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -70,6 +70,11 @@ _mcount:
 	 nop
 
 	MCOUNT_SAVE_REGS
+#if (__GNUC__ >= 4 && __GNUC_MINOR__ >= 5)
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	PTR_S	t0, PT_R12(sp)	/* t0 saved the location of the return address(at) by -mmcount-ra-address */
+#endif
+#endif
 
 	move	a0, ra		/* arg1: next ip, selfaddr */
 	.globl ftrace_call
@@ -133,11 +138,22 @@ ftrace_stub:
 NESTED(ftrace_graph_caller, PT_SIZE, ra)
 #ifdef CONFIG_DYNAMIC_FTRACE
 	PTR_L	a1, PT_R31(sp)	/* load the original ra from the stack */
+#if (__GNUC__ >= 4 && __GNUC_MINOR__ >= 5)
+	PTR_L	t0, PT_R12(sp)	/* load the original t0 from the stack */
+#endif
 #else
 	MCOUNT_SAVE_REGS
 	move	a1, ra		/* arg2: next ip, selfaddr */
 #endif
+
+#if (__GNUC__ >= 4 && __GNUC_MINOR__ >= 5)
+	bnez	t0, 1f		/* non-leaf func: t0 saved the location of the return address */
+	 nop
+	PTR_LA	t0, PT_R1(sp)	/* leaf func: get the location of at(old ra) from our own stack */
+1:	move	a0, t0		/* arg1: the location of the return address */
+#else
 	PTR_LA	a0, PT_R1(sp)	/* arg1: &AT -> a0 */
+#endif
 	jal	prepare_ftrace_return
 #ifdef CONFIG_FRAME_POINTER
 	 move	a2, fp		/* arg3: frame pointer */
-- 
1.6.2.1

