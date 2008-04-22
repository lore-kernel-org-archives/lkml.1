Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbYDVAka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbYDVAka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYDVAkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:40:17 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:34840 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971AbYDVAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:40:16 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D33EB.30808@avtrex.com>
Date: Mon, 21 Apr 2008 17:40:11 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 6/6] Ptrace support for HARDWARE_WATCHPOINTS.
References: <480D2151.2020701@avtrex.com>
In-Reply-To: <480D2151.2020701@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 00:40:12.0792 (UTC) FILETIME=[6CDD9780:01C8A411]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final part of the patch.  Here we add ptrace support so that
gdb can read and set the watch register values.

We add two new ptrace requests PTRACE_GET_WATCH_REGS, and
PTRACE_SET_WATCH_REGS to access the watch registers.  Since MIPS has more
than one format for watch registers, the data structure is a union, the
first structure member is an enum that tells us which layout is in use.
For this first cut at the patch, I only support mips32 style registers.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/ptrace.c |   81 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-mips/ptrace.h |   23 +++++++++++++
 2 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 35234b9..d6dece8 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -46,7 +46,12 @@
  */
 void ptrace_disable(struct task_struct *child)
 {
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+	/* Don't load the watchpoint registers for the ex-child. */
+	clear_tsk_thread_flag(child, TIF_LOAD_WATCH);
+#else
 	/* Nothing to do.. */
+#endif
 }
 
 /*
@@ -167,6 +172,72 @@ int ptrace_setfpregs(struct task_struct *child, __u32 __user *data)
 	return 0;
 }
 
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+int ptrace_get_watch_regs(struct task_struct *child,
+			  struct pt_watch_regs __user *addr)
+{
+	int i;
+
+	if (!cpu_has_watch)
+		return -EIO;
+	if (!access_ok(VERIFY_WRITE, addr, sizeof(struct pt_watch_regs)))
+		return -EIO;
+
+	__put_user (pt_watch_style_mips32, &addr->style);
+	__put_user (current_cpu_data.watch_reg_count, &addr->mips32.num_valid);
+	__put_user (current_cpu_data.watch_reg_mask, &addr->mips32.reg_mask);
+	__put_user (current_cpu_data.watch_reg_irw, &addr->mips32.irw_mask);
+	for (i = 0; i < current_cpu_data.watch_reg_count; i++) {
+		__put_user (child->thread.watch.mips32.watchlo[i],
+			    &addr->mips32.watchlo[i]);
+		__put_user (child->thread.watch.mips32.watchhi[i] & 0xfff,
+			    &addr->mips32.watchhi[i]);
+	}
+
+	return 0;
+}
+
+int ptrace_set_watch_regs(struct task_struct *child,
+			  struct pt_watch_regs __user *addr)
+{
+	int i;
+	int watch_active = 0;
+	unsigned long lt[NUM_WATCH_REGS];
+	unsigned int ht[NUM_WATCH_REGS];
+
+	if (!cpu_has_watch)
+		return -EIO;
+	if (!access_ok(VERIFY_READ, addr, sizeof(struct pt_watch_regs)))
+		return -EIO;
+	/* Check the values. */
+	for (i = 0; i < NUM_WATCH_REGS; i++) {
+		__get_user(lt[i], &addr->mips32.watchlo[i]);
+		if (lt[i] & __UA_LIMIT)
+			return -EINVAL;
+
+		__get_user(ht[i], &addr->mips32.watchhi[i]);
+		if (ht[i] & ~0xff8)
+			return -EINVAL;
+	}
+	/* Install them. */
+	for (i = 0; i < NUM_WATCH_REGS; i++) {
+		if (lt[i] & 7)
+			watch_active = 1;
+		child->thread.watch.mips32.watchlo[i] = lt[i];
+		/* Set the G bit. */
+		child->thread.watch.mips32.watchhi[i] = ht[i] | 0x40000000;
+	}
+
+	if (watch_active)
+		set_tsk_thread_flag(child, TIF_LOAD_WATCH);
+	else
+		clear_tsk_thread_flag(child, TIF_LOAD_WATCH);
+
+	return 0;
+}
+
+#endif
+
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
@@ -439,7 +510,17 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = put_user(task_thread_info(child)->tp_value,
 				(unsigned long __user *) data);
 		break;
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+	case PTRACE_GET_WATCH_REGS:
+		ret = ptrace_get_watch_regs(child,
+					(struct pt_watch_regs __user *) addr);
+		break;
 
+	case PTRACE_SET_WATCH_REGS:
+		ret = ptrace_set_watch_regs(child,
+					(struct pt_watch_regs __user *) addr);
+		break;
+#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/include/asm-mips/ptrace.h b/include/asm-mips/ptrace.h
index 786f7e3..8fb1bcc 100644
--- a/include/asm-mips/ptrace.h
+++ b/include/asm-mips/ptrace.h
@@ -71,6 +71,29 @@ struct pt_regs {
 #define PTRACE_POKEDATA_3264	0xc3
 #define PTRACE_GET_THREAD_AREA_3264	0xc4
 
+/* Read and write watchpoint registers.  */
+enum pt_watch_style {
+	pt_watch_style_mips32,
+	pt_watch_style_mips64
+};
+struct mips32_watch_regs {
+	unsigned int num_valid;
+	unsigned int reg_mask;
+	unsigned int irw_mask;
+	unsigned long watchlo[8];
+	unsigned int watchhi[8];
+};
+
+struct pt_watch_regs {
+	enum pt_watch_style style;
+	union {
+		struct mips32_watch_regs mips32;
+	};
+};
+
+#define PTRACE_GET_WATCH_REGS	0xd0
+#define PTRACE_SET_WATCH_REGS	0xd1
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
-- 
1.5.5

