Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZKSHTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZKSHTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZKSHTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:19:16 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62338 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZKSHTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:19:15 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH] perf bench: Add new functions for utilizing rep of Nehalem
Date: Thu, 19 Nov 2009 16:18:59 +0900
Message-Id: <1258615139-23060-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two functions to bench/mem-memcpy.c,
memcpy_nehalem_rep() and memcpy_orig_of_nehalem_rep().

These functions are based on the post by Ling Ma,
http://marc.info/?l=linux-kernel&m=125800144419838&w=2
And the purpose of this post is improving performance
of memcpy() for x86_64.

On my Core i7 box, I can find improvement of performance,

|% perf bench mem memcpy -c -l 1GB -r nehalem-rep
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7ff9fc95a010 to 0x7ffa3c95b010 ...
|
|        3.099325 Clock/Byte
| % perf bench mem memcpy -c -l 1GB -r orig-of-nehalem-rep
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7f314d1d7010 to 0x7f318d1d8010 ...
|
|        4.353351 Clock/Byte

(of course I tested some times, and results are like the above)

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
---
 tools/perf/bench/mem-memcpy.c |  167 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 167 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index d4f4f98..349aeaf 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -37,6 +37,165 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+#ifdef __x86_64__
+
+/*
+ * This memcpy_nehalem_rep() is based on Ling Ma <ling.ma@intel.com>'s
+ * memcpy_new() optimized for Nehalem architecture.
+ *
+ * http://marc.info/?l=linux-kernel&m=125800144419838&w=2
+ */
+static void *memcpy_nehalem_rep(void *dst, const void *src __used,
+			     size_t len __used)
+{
+	__asm__(
+		"movq %rdi, %rax\n\t"
+		"movl %edx, %ecx\n\t"
+		"shrl $6, %ecx\n\t"
+		"jz nehalem_rep_2\n\t"
+
+		"cmp $0x400, %edx\n\t"
+		"jae nehalem_rep_7\n\t"
+
+		"nehalem_rep_1:\n\t"
+		"decl %ecx\n\t"
+		"movq 0*8(%rsi), %r11\n\t"
+		"movq 1*8(%rdi), %r8\n\t"
+		"movq %r11, 0*8(%rdi)\n\t"
+		"movq %r8, 1*8(%rdi)\n\t"
+		"movq 2*8(%rsi), %r9\n\t"
+		"movq 3*8(%rdi), %r10\n\t"
+		"movq %r9, 2*8(%rdi)\n\t"
+		"movq %r10, 3*8(%rdi)\n\t"
+		"movq 4*8(%rsi), %r11\n\t"
+		"movq 5*8(%rdi), %r8\n\t"
+		"movq %r11, 4*8(%rdi)\n\t"
+		"movq %r8, 5*8(%rdi)\n\t"
+		"movq 6*8(%rsi), %r9\n\t"
+		"movq 7*8(%rdi), %r10\n\t"
+		"movq %r9, 6*8(%rdi)\n\t"
+		"movq %r10, 7*8(%rdi)\n\t"
+		"leaq 64(%rsi), %rsi\n\t"
+		"leaq 64(%rdi), %rdi\n\t"
+		"jnz nehalem_rep_1\n\t"
+
+		"nehalem_rep_2:\n\t"
+		"movl %edx, %ecx\n\t"
+		"andl $63, %ecx\n\t"
+		"shrl $3, %ecx\n\t"
+		"jz nehalem_rep_4\n\t"
+
+		"nehalem_rep_3:\n\t"
+		"decl %ecx\n\t"
+		"movq (%rsi), %r8\n\t"
+		"movq %r8, (%rdi)\n\t"
+		"leaq 8(%rdi), %rdi\n\t"
+		"leaq 8(%rsi), %rsi\n\t"
+		"jnz nehalem_rep_3\n\t"
+
+		"nehalem_rep_4:\n\t"
+		"movl %edx, %ecx\n\t"
+		"andl $7, %ecx\n\t"
+		"jz nehalem_rep_6\n\t"
+
+		"nehalem_rep_5:\n\t"
+		"movb (%rsi), %r8b\n\t"
+		"movb %r8b, (%rdi)\n\t"
+		"incq %rdi\n\t"
+		"incq %rsi\n\t"
+		"decl %ecx\n\t"
+		"jnz nehalem_rep_5\n\t"
+		"nehalem_rep_6:\n\t"
+
+		"retq\n\t"
+		"nehalem_rep_7:\n\t"
+
+		"movl %edx, %ecx\n\t"
+		"shr $3, %ecx\n\t"
+		"andl $7, %edx\n\t"
+		"rep movsq \n\t"
+		"jz nehalem_rep_8\n\t"
+
+		"movl %edx, %ecx\n\t"
+		"rep movsb\n\t"
+		"nehalem_rep_8:\n\t"
+		);
+
+	return dst;
+}
+
+/*
+ * Original memcpy() from arch/x86/lib/memcpy_64.S
+ * Main purpose of this function is comparison with
+ * for-nehalem-rep()
+ */
+
+static void *memcpy_orig_of_nehalem_rep(void *dst, const void *src __used,
+			     size_t len __used)
+{
+	__asm__(
+		"movq %rdi, %rax\n\t"
+		"movl %edx, %ecx\n\t"
+		"shrl $6, %ecx\n\t"
+		"jz orig_of_nehalem_rep2\n\t"
+
+		"mov $0x80, %r8d\n\t"
+		"orig_of_nehalem_rep1:\n\t"
+		"decl %ecx\n\t"
+		"movq 0*8(%rsi), %r11\n\t"
+		"movq 1*8(%rdi), %r8\n\t"
+		"movq %r11, 0*8(%rdi)\n\t"
+		"movq %r8, 1*8(%rdi)\n\t"
+		"movq 2*8(%rsi), %r9\n\t"
+		"movq 3*8(%rdi), %r10\n\t"
+		"movq %r9, 2*8(%rdi)\n\t"
+		"movq %r10, 3*8(%rdi)\n\t"
+		"movq 4*8(%rsi), %r11\n\t"
+		"movq 5*8(%rdi), %r8\n\t"
+		"movq %r11, 4*8(%rdi)\n\t"
+		"movq %r8, 5*8(%rdi)\n\t"
+		"movq 6*8(%rsi), %r9\n\t"
+		"movq 7*8(%rdi), %r10\n\t"
+		"movq %r9, 6*8(%rdi)\n\t"
+		"movq %r10, 7*8(%rdi)\n\t"
+		"leaq 64(%rsi), %rsi\n\t"
+		"leaq 64(%rdi), %rdi\n\t"
+		"jnz orig_of_nehalem_rep1\n\t"
+
+		"orig_of_nehalem_rep2:\n\t"
+		"movl %edx, %ecx\n\t"
+		"andl $63, %ecx\n\t"
+		"shrl $3, %ecx\n\t"
+		"jz orig_of_nehalem_rep4\n\t"
+
+		"orig_of_nehalem_rep3:\n\t"
+		"decl %ecx\n\t"
+		"movq (%rsi), %r8\n\t"
+		"movq %r8, (%rdi)\n\t"
+		"leaq 8(%rdi), %rdi\n\t"
+		"leaq 8(%rsi), %rsi\n\t"
+		"jnz orig_of_nehalem_rep3\n\t"
+
+		"orig_of_nehalem_rep4:\n\t"
+		"movl %edx, %ecx\n\t"
+		"andl $7, %ecx\n\t"
+		"jz orig_of_nehalem_rep6\n\t"
+
+		"orig_of_nehalem_rep5:\n\t"
+		"movb (%rsi), %r8b\n\t"
+		"movb %r8b, (%rdi)\n\t"
+		"incq %rdi\n\t"
+		"incq %rsi\n\t"
+		"decl %ecx\n\t"
+		"jnz orig_of_nehalem_rep5\n\t"
+
+		"orig_of_nehalem_rep6:\n\t"
+		);
+	return dst;
+}
+
+ #endif	/* __x86_64__ */
+
 struct routine {
 	const char *name;
 	const char *desc;
@@ -47,6 +206,14 @@ struct routine routines[] = {
 	{ "default",
 	  "Default memcpy() provided by glibc",
 	  memcpy },
+#ifdef __x86_64__
+	{ "nehalem-rep",
+	  "Optimized memcpy() for Nehalem architecture",
+	  memcpy_nehalem_rep     },
+	{ "orig-of-nehalem-rep",
+	  "Original memcpy() from arch/x86/lib/memcpy_64.S",
+	  memcpy_orig_of_nehalem_rep },
+#endif	/* __x86_64__ */
 	{ NULL,
 	  NULL,
 	  NULL   }
-- 
1.6.5.2

