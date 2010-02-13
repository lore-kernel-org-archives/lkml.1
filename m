Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0BMTtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:49:10 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:44947 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab0BMTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZkLIG7ekB44uL5ke1gzLtQYHxqhZ3OH0l9xHn47FImgsBSMqHzkW7MhcPVROVgHhIG
         DS+mIY/bDmlK6Dr0Ov89KJ6OQL/r0IKVmV6kXfqpt4/psud251e91DEeXs1/X7RTIxFN
         ad6HNFwI9HGOflhd3rEmaoUmcQ4ZHs+wEHS/o=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 09/10] ARM: ftrace: add Thumb-2 support to dynamic ftrace
Date: Sun, 14 Feb 2010 01:18:37 +0530
Message-Id: <1266090518-31120-10-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle the different nop and call instructions for Thumb-2.  Also, we
need to adjust the recorded mcount_loc addresses because they have the
lsb set.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/include/asm/ftrace.h |    4 ++++
 arch/arm/kernel/ftrace.c      |   33 +++++++++++++++++++++++++++++++++
 scripts/recordmcount.pl       |    2 +-
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 4a56a2e..0845f2d 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -18,7 +18,11 @@ struct dyn_arch_ftrace {
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
+#ifdef CONFIG_THUMB2_KERNEL
+	return addr & ~1;
+#else
 	return addr;
+#endif
 }
 
 extern void ftrace_caller_old(void);
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index f09014c..971ac8c 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -18,7 +18,11 @@
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
 
+#ifdef CONFIG_THUMB2_KERNEL
+#define	NOP		0xeb04f85d	/* pop.w {lr} */
+#else
 #define	NOP		0xe8bd4000	/* pop {lr} */
+#endif
 
 #ifdef CONFIG_OLD_MCOUNT
 #define OLD_MCOUNT_ADDR	((unsigned long) mcount)
@@ -56,6 +60,34 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
 #endif
 
 /* construct a branch (BL) instruction to addr */
+#ifdef CONFIG_THUMB2_KERNEL
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+{
+	unsigned long s, j1, j2, i1, i2, imm10, imm11;
+	unsigned long first, second;
+	long offset;
+
+	offset = (long)addr - (long)(pc + 4);
+	if (offset < -16777216 || offset > 16777214) {
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	s	= (offset >> 24) & 0x1;
+	i1	= (offset >> 23) & 0x1;
+	i2	= (offset >> 22) & 0x1;
+	imm10	= (offset >> 12) & 0x3ff;
+	imm11	= (offset >>  1) & 0x7ff;
+
+	j1 = (!i1) ^ s;
+	j2 = (!i2) ^ s;
+
+	first = 0xf000 | (s << 10) | imm10;
+	second = 0xd000 | (j1 << 13) | (j2 << 11) | imm11;
+
+	return (second << 16) | first;
+}
+#else
 static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
 	long offset;
@@ -73,6 +105,7 @@ static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 
 	return 0xeb000000 | offset;
 }
+#endif
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
 			      unsigned long new)
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 66c1c4b..88b083b 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -267,7 +267,7 @@ if ($arch eq "x86_64") {
 } elsif ($arch eq "arm") {
     $alignment = 2;
     $section_type = '%progbits';
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24)" .
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24|THM_CALL)" .
 			"\\s+(__gnu_mcount_nc|mcount)\$";
 
 } elsif ($arch eq "ia64") {
-- 
1.6.6

