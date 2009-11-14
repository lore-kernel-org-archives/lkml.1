Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZKNGgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZKNGgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZKNGgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:36:37 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:33554 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbZKNGge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jb67QucxBDw3++BbxXETiSpMUuv5ZCaZgCaVQzjA4wXaj+twKf0avq4fmCg1kmztli
         IwHHXTZlzssGz7g9ZaS6Zt66n94ezHG29DXgRIF6r+4D+9o0XGQuKdVcP7zDUWnoXIuY
         Q1hwFGIG05dF/+E9wNBF75Wblq1ZNJf6EAcWc=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 16/16] tracing: make function graph tracer work with -mmcount-ra-address
Date: Sat, 14 Nov 2009 14:33:31 +0800
Message-Id: <a9e699c72798cfbf213caee9a6d702a1a3204c7a.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <5fac5676cfadccf569cab72094f365b130b181ed.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
 <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
 <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
 <f3a54cef2de00885ee75a930b243083a716370bd.1258177321.git.wuzhangjin@gmail.com>
 <b98ca1b2048aeab8aac82ec8723ac729c2cd4b54.1258177321.git.wuzhangjin@gmail.com>
 <8a7987bba58526a0e156f531dba31d9a65d3d744.1258177321.git.wuzhangjin@gmail.com>
 <af765bca2a5f969f13de1b9f61744e6523d1afe8.1258177321.git.wuzhangjin@gmail.com>
 <24733f375d853dd6dc44138c53f2f57493915d8f.1258177321.git.wuzhangjin@gmail.com>
 <5fac5676cfadccf569cab72094f365b130b181ed.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
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
enabled, otherwise, no side effect.

and then, we need to support this new option of gcc 4.5 and also support
the old gcc versions.

with _mcount in the old gcc versions, it's not easy to get the location
of return address(tracing: add function graph tracer support for MIPS),
   so, we do it in a C function: ftrace_get_parent_addr(ftrace.c), but
   with -mmcount-ra-address, only several instructions need to get what
   we want, so, I put into asm(mcount.S). and also, as the $12(t0) is
   used by -mmcount-ra-address for transferring the localtion of return
   address to _mcount, we need to save it into the stack and restore it
   when enabled dynamic function tracer, 'Cause we have called
   "ftrace_call" before "ftrace_graph_caller", which may destroy
   $12(t0).

(Thanks to David for providing that -mcount-ra-address and giving the
 idea of KBUILD_MCOUNT_RA_ADDRESS, both of them have made the whole
 thing more beautiful!)

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Makefile        |    7 +++++++
 arch/mips/kernel/ftrace.c |   24 +++++++++++++++++-------
 arch/mips/kernel/mcount.S |   14 ++++++++++++++
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 0a2073e..50039e8 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -51,6 +51,13 @@ endif
 ifndef CONFIG_FUNCTION_TRACER
 cflags-y := -ffunction-sections
 endif
+ifdef CONFIG_FUNCTION_GRAPH_TRACER
+  ifndef KBUILD_MCOUNT_RA_ADDRESS
+    ifeq ($(call cc-option-yn,-mmcount-ra-address), y)
+      cflags-y += -mmcount-ra-address -DKBUILD_MCOUNT_RA_ADDRESS
+    endif
+  endif
+endif
 cflags-y += $(call cc-option, -mno-check-zero-division)
 
 ifdef CONFIG_32BIT
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index e363fc6..68b0670 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -148,6 +148,7 @@ int ftrace_disable_ftrace_graph_caller(void)
 
 #endif				/* !CONFIG_DYNAMIC_FTRACE */
 
+#ifndef KBUILD_MCOUNT_RA_ADDRESS
 #define S_RA_SP	(0xafbf << 16)	/* s{d,w} ra, offset(sp) */
 #define S_R_SP	(0xafb0 << 16)  /* s{d,w} R, offset(sp) */
 #define OFFSET_MASK	0xffff	/* stack offset range: 0 ~ PT_SIZE */
@@ -201,6 +202,8 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 	return 0;
 }
 
+#endif
+
 /*
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
@@ -218,19 +221,26 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
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
+#ifndef KBUILD_MCOUNT_RA_ADDRESS
 	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
 							 (unsigned long)parent,
 							 fp);
@@ -238,7 +248,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	 * ra, stop function graph tracer and return */
 	if (parent == 0)
 		goto out;
-
+#endif
 	/* *parent = return_hooker; */
 	safe_store_stack(return_hooker, parent, faulted);
 	if (unlikely(faulted))
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 522e91c..0a9cfdb 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -70,6 +70,9 @@ _mcount:
 	 nop
 
 	MCOUNT_SAVE_REGS
+#ifdef KBUILD_MCOUNT_RA_ADDRESS
+	PTR_S	t0, PT_R12(sp)	/* t0 saved the location of the return address(at) by -mmcount-ra-address */
+#endif
 
 	move	a0, ra		/* arg1: next ip, selfaddr */
 	.globl ftrace_call
@@ -133,11 +136,22 @@ ftrace_stub:
 NESTED(ftrace_graph_caller, PT_SIZE, ra)
 #ifdef CONFIG_DYNAMIC_FTRACE
 	PTR_L	a1, PT_R31(sp)	/* load the original ra from the stack */
+#ifdef KBUILD_MCOUNT_RA_ADDRESS
+	PTR_L	t0, PT_R12(sp)	/* load the original t0 from the stack */
+#endif
 #else
 	MCOUNT_SAVE_REGS
 	move	a1, ra		/* arg2: next ip, selfaddr */
 #endif
+
+#ifdef KBUILD_MCOUNT_RA_ADDRESS
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

