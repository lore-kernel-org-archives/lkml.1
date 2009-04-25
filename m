Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbZDYAQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbZDYAQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZDYAQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:16:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbZDYAQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:16:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 15/17] arm: user_regset: thread pointer in core dumps
Message-Id: <20090425001424.40568FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:14:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wires up a proper user_regset for the $tp special register.
It will appear in ELF core dumps in its own tiny note of the new
type NT_ARM_TP.  The note will be omitted if $tp was 0.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/elf.h      |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 6ce3deb..1a07257 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -623,6 +623,37 @@ static int user_fp_set(struct task_struct *target,
 				  &thread->fpstate, 0, sizeof(struct user_fp));
 }
 
+/*
+ * Fetch the thread pointer as a regset of its own.
+ * It's considered "active" (i.e. worth dumping) if it's nonzero.
+ */
+
+static int tp_get(struct task_struct *target,
+		  const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  void *kbuf, void __user *ubuf)
+{
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &task_thread_info(target)->tp_value,
+				   0, sizeof(unsigned long));
+}
+
+static int tp_set(struct task_struct *target,
+		  const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  const void *kbuf, const void __user *ubuf)
+{
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  &task_thread_info(target)->tp_value,
+				  0, sizeof(unsigned long));
+}
+
+static int tp_active(struct task_struct *target,
+		     const struct user_regset *regset)
+{
+	return task_thread_info(target)->tp_value == 0 ? 0 : 1;
+}
+
 #ifdef CONFIG_IWMMXT
 
 /*
@@ -806,6 +837,7 @@ static int vfp_set(struct task_struct *target,
 enum {
 	REGSET_GPR,
 	REGSET_FP,
+	REGSET_TP,
 #ifdef CONFIG_VFP
 	REGSET_VFP,
 #endif
@@ -829,6 +861,11 @@ static const struct user_regset arm_regsets[] = {
 		.size = sizeof(long), .align = sizeof(long),
 		.active = user_fp_active, .get = user_fp_get, .set = user_fp_set
 	},
+	[REGSET_TP] = {
+		.core_note_type = NT_ARM_TP,
+		.size = sizeof(long), .align = sizeof(long), .n = 1,
+		.active = tp_active, .get = tp_get, .set = tp_set
+	},
 #ifdef CONFIG_VFP
 	[REGSET_VFP] = {
 		.core_note_type = NT_PRXFPREG,
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 30a7b92..32662e3 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -363,6 +363,7 @@ typedef struct elf64_shdr {
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
 #define NT_ARM_WMMX	0x300		/* ARM iWMMXt registers */
 #define NT_ARM_CRUNCH	0x301		/* ARM Crunch registers */
+#define NT_ARM_TP	0x302		/* ARM thread pointer */
 
 
 /* Note header in a PT_NOTE section */
