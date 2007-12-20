Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbXLTMLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbXLTMLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761066AbXLTMBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760335AbXLTMAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 35/43] x86 user_regset general regs
Message-Id: <20071220120000.8449126F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:00:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds accessor functions in the user_regset style for
the general registers (struct user_regs_struct).

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/ptrace.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 18972a3..c520ad7 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
+#include <linux/regset.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/audit.h>
@@ -368,6 +369,59 @@ static unsigned long getreg(struct task_struct *task, unsigned long offset)
 	return *pt_regs_access(task_pt_regs(task), offset);
 }
 
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
+{
+	if (kbuf) {
+		unsigned long *k = kbuf;
+		while (count > 0) {
+			*k++ = getreg(target, pos);
+			count -= sizeof(*k);
+			pos += sizeof(*k);
+		}
+	} else {
+		unsigned long __user *u = ubuf;
+		while (count > 0) {
+			if (__put_user(getreg(target, pos), u++))
+				return -EFAULT;
+			count -= sizeof(*u);
+			pos += sizeof(*u);
+		}
+	}
+
+	return 0;
+}
+
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	int ret = 0;
+	if (kbuf) {
+		const unsigned long *k = kbuf;
+		while (count > 0 && !ret) {
+			ret = putreg(target, pos, *k++);
+			count -= sizeof(*k);
+			pos += sizeof(*k);
+		}
+	} else {
+		const unsigned long  __user *u = ubuf;
+		while (count > 0 && !ret) {
+			unsigned long word;
+			ret = __get_user(word, u++);
+			if (ret)
+				break;
+			ret = putreg(target, pos, word);
+			count -= sizeof(*u);
+			pos += sizeof(*u);
+		}
+	}
+	return ret;
+}
+
 /*
  * This function is trivial and will be inlined by the compiler.
  * Having it separates the implementation details of debug
@@ -1009,6 +1063,61 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 #undef R32
 #undef SEG32
 
+static int genregs32_get(struct task_struct *target,
+			 const struct user_regset *regset,
+			 unsigned int pos, unsigned int count,
+			 void *kbuf, void __user *ubuf)
+{
+	if (kbuf) {
+		compat_ulong_t *k = kbuf;
+		while (count > 0) {
+			getreg32(target, pos, k++);
+			count -= sizeof(*k);
+			pos += sizeof(*k);
+		}
+	} else {
+		compat_ulong_t __user *u = ubuf;
+		while (count > 0) {
+			compat_ulong_t word;
+			getreg32(target, pos, &word);
+			if (__put_user(word, u++))
+				return -EFAULT;
+			count -= sizeof(*u);
+			pos += sizeof(*u);
+		}
+	}
+
+	return 0;
+}
+
+static int genregs32_set(struct task_struct *target,
+			 const struct user_regset *regset,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	int ret = 0;
+	if (kbuf) {
+		const compat_ulong_t *k = kbuf;
+		while (count > 0 && !ret) {
+			ret = putreg(target, pos, *k++);
+			count -= sizeof(*k);
+			pos += sizeof(*k);
+		}
+	} else {
+		const compat_ulong_t __user *u = ubuf;
+		while (count > 0 && !ret) {
+			compat_ulong_t word;
+			ret = __get_user(word, u++);
+			if (ret)
+				break;
+			ret = putreg(target, pos, word);
+			count -= sizeof(*u);
+			pos += sizeof(*u);
+		}
+	}
+	return ret;
+}
+
 static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
 {
 	siginfo_t __user *si = compat_alloc_user_space(sizeof(siginfo_t));
-- 
1.5.3.6

