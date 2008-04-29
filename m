Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYD2Bnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYD2Bnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYD2Bnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:43:31 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:53447 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYD2Bna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:43:30 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48167D3E.4050104@avtrex.com>
Date: Mon, 28 Apr 2008 18:43:26 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] Ptrace support for HARDWARE_WATCHPOINTS.
References: <48167832.3090103@avtrex.com>
In-Reply-To: <48167832.3090103@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 01:43:27.0664 (UTC) FILETIME=[6BAD5B00:01C8A99A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ptrace support for HARDWARE_WATCHPOINTS

This is the final part of the watch register patch.  Here we hook up
ptrace so that the user space debugger (gdb), can set and read the
registers.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/ptrace.c |   93 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-mips/ptrace.h |   31 +++++++++++++++
 2 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 35234b9..8e86134 100644
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
@@ -167,6 +172,84 @@ int ptrace_setfpregs(struct task_struct *child, __u32 __user *data)
 	return 0;
 }
 
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+static int ptrace_get_watch_regs(struct task_struct *child,
+				 struct pt_watch_regs __user *addr)
+{
+	enum pt_watch_style style;
+	int i;
+
+	if (!cpu_has_watch)
+		return -EIO;
+	if (!access_ok(VERIFY_WRITE, addr, sizeof(struct pt_watch_regs)))
+		return -EIO;
+
+#ifdef CONFIG_32BIT
+	style = pt_watch_style_mips32;
+#define WATCH_STYLE mips32
+#else
+	style = pt_watch_style_mips64;
+#define WATCH_STYLE mips64
+#endif
+
+	__put_user(style, &addr->style);
+	__put_user(current_cpu_data.watch_reg_count,
+		   &addr->WATCH_STYLE.num_valid);
+	__put_user(current_cpu_data.watch_reg_mask,
+		   &addr->WATCH_STYLE.reg_mask);
+	__put_user(current_cpu_data.watch_reg_irw,
+		   &addr->WATCH_STYLE.irw_mask);
+	for (i = 0; i < current_cpu_data.watch_reg_count; i++) {
+		__put_user(child->thread.watch.mips3264.watchlo[i],
+			   &addr->WATCH_STYLE.watchlo[i]);
+		__put_user(child->thread.watch.mips3264.watchhi[i] & 0xfff,
+			   &addr->WATCH_STYLE.watchhi[i]);
+	}
+
+	return 0;
+}
+
+static int ptrace_set_watch_regs(struct task_struct *child,
+				 struct pt_watch_regs __user *addr)
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
+		__get_user(lt[i], &addr->WATCH_STYLE.watchlo[i]);
+		if (lt[i] & __UA_LIMIT)
+			return -EINVAL;
+
+		__get_user(ht[i], &addr->WATCH_STYLE.watchhi[i]);
+		if (ht[i] & ~0xff8)
+			return -EINVAL;
+	}
+	/* Install them. */
+	for (i = 0; i < NUM_WATCH_REGS; i++) {
+		if (lt[i] & 7)
+			watch_active = 1;
+		child->thread.watch.mips3264.watchlo[i] = lt[i];
+		/* Set the G bit. */
+		child->thread.watch.mips3264.watchhi[i] = ht[i] | 0x40000000;
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
+#endif /* CONFIG_HARDWARE_WATCHPOINTS */
+
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
@@ -439,7 +522,17 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
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
index 786f7e3..d8d821d 100644
--- a/include/asm-mips/ptrace.h
+++ b/include/asm-mips/ptrace.h
@@ -71,6 +71,37 @@ struct pt_regs {
 #define PTRACE_POKEDATA_3264	0xc3
 #define PTRACE_GET_THREAD_AREA_3264	0xc4
 
+/* Read and write watchpoint registers.  */
+enum pt_watch_style {
+	pt_watch_style_mips32,
+	pt_watch_style_mips64
+};
+struct mips32_watch_regs {
+	uint32_t watchlo[8];
+	uint32_t watchhi[8];
+	uint32_t num_valid;
+	uint32_t reg_mask;
+	uint32_t irw_mask;
+};
+struct mips64_watch_regs {
+	uint64_t watchlo[8];
+	uint32_t watchhi[8];
+	uint32_t num_valid;
+	uint32_t reg_mask;
+	uint32_t irw_mask;
+};
+
+struct pt_watch_regs {
+	enum pt_watch_style style;
+	union {
+		struct mips32_watch_regs mips32;
+		struct mips32_watch_regs mips64;
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

