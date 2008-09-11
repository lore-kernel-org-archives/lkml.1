Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYIKGFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYIKGFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 02:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYIKGE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 02:04:56 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:57158 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYIKGEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 02:04:55 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48C8B504.5080409@avtrex.com>
Date: Wed, 10 Sep 2008 23:04:52 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 6/6] MIPS: Ptrace support for HARDWARE_WATCHPOINTS
References: <48C8ADEF.9020305@avtrex.com>
In-Reply-To: <48C8ADEF.9020305@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2008 06:04:53.0618 (UTC) FILETIME=[4F003D20:01C913D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ptrace support for HARDWARE_WATCHPOINTS

This is the final part of the watch register patch.  Here we hook up
ptrace so that the user space debugger (gdb), can set and read the
registers.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/ptrace.c   |  100 ++++++++++++++++++++++++++++++++++++++++++-
 arch/mips/kernel/ptrace32.c |   15 ++++++
 include/asm-mips/ptrace.h   |   38 ++++++++++++++++
 3 files changed, 152 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 35234b9..ee41f8a 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -46,7 +46,8 @@
  */
 void ptrace_disable(struct task_struct *child)
 {
-	/* Nothing to do.. */
+	/* Don't load the watchpoint registers for the ex-child. */
+	clear_tsk_thread_flag(child, TIF_LOAD_WATCH);
 }
 
 /*
@@ -167,6 +168,93 @@ int ptrace_setfpregs(struct task_struct *child, __u32 __user *data)
 	return 0;
 }
 
+int ptrace_get_watch_regs(struct task_struct *child,
+			  struct pt_watch_regs __user *addr)
+{
+	enum pt_watch_style style;
+	int i;
+
+	if (!cpu_has_watch || current_cpu_data.watch_reg_use_cnt == 0)
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
+	__put_user(current_cpu_data.watch_reg_use_cnt,
+		   &addr->WATCH_STYLE.num_valid);
+	for (i = 0; i < current_cpu_data.watch_reg_use_cnt; i++) {
+		__put_user(child->thread.watch.mips3264.watchlo[i],
+			   &addr->WATCH_STYLE.watchlo[i]);
+		__put_user(child->thread.watch.mips3264.watchhi[i] & 0xfff,
+			   &addr->WATCH_STYLE.watchhi[i]);
+		__put_user(current_cpu_data.watch_reg_masks[i],
+			   &addr->WATCH_STYLE.watch_masks[i]);
+	}
+	for (; i < 8; i++) {
+		__put_user(0, &addr->WATCH_STYLE.watchlo[i]);
+		__put_user(0, &addr->WATCH_STYLE.watchhi[i]);
+		__put_user(0, &addr->WATCH_STYLE.watch_masks[i]);
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
+	u16 ht[NUM_WATCH_REGS];
+
+	if (!cpu_has_watch || current_cpu_data.watch_reg_use_cnt == 0)
+		return -EIO;
+	if (!access_ok(VERIFY_READ, addr, sizeof(struct pt_watch_regs)))
+		return -EIO;
+	/* Check the values. */
+	for (i = 0; i < current_cpu_data.watch_reg_use_cnt; i++) {
+		__get_user(lt[i], &addr->WATCH_STYLE.watchlo[i]);
+#ifdef CONFIG_32BIT
+		if (lt[i] & __UA_LIMIT)
+			return -EINVAL;
+#else
+		if (test_tsk_thread_flag(child, TIF_32BIT_ADDR)) {
+			if (lt[i] & 0xffffffff80000000UL)
+				return -EINVAL;
+		} else {
+			if (lt[i] & __UA_LIMIT)
+				return -EINVAL;
+		}
+#endif
+		__get_user(ht[i], &addr->WATCH_STYLE.watchhi[i]);
+		if (ht[i] & ~0xff8)
+			return -EINVAL;
+	}
+	/* Install them. */
+	for (i = 0; i < current_cpu_data.watch_reg_use_cnt; i++) {
+		if (lt[i] & 7)
+			watch_active = 1;
+		child->thread.watch.mips3264.watchlo[i] = lt[i];
+		/* Set the G bit. */
+		child->thread.watch.mips3264.watchhi[i] = ht[i];
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
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
@@ -440,6 +528,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				(unsigned long __user *) data);
 		break;
 
+	case PTRACE_GET_WATCH_REGS:
+		ret = ptrace_get_watch_regs(child,
+					(struct pt_watch_regs __user *) addr);
+		break;
+
+	case PTRACE_SET_WATCH_REGS:
+		ret = ptrace_set_watch_regs(child,
+					(struct pt_watch_regs __user *) addr);
+		break;
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/arch/mips/kernel/ptrace32.c b/arch/mips/kernel/ptrace32.c
index 76818be..3e219de 100644
--- a/arch/mips/kernel/ptrace32.c
+++ b/arch/mips/kernel/ptrace32.c
@@ -42,6 +42,11 @@ int ptrace_setregs(struct task_struct *child, __s64 __user *data);
 int ptrace_getfpregs(struct task_struct *child, __u32 __user *data);
 int ptrace_setfpregs(struct task_struct *child, __u32 __user *data);
 
+int ptrace_get_watch_regs(struct task_struct *child,
+			  struct pt_watch_regs __user *addr);
+int ptrace_set_watch_regs(struct task_struct *child,
+			  struct pt_watch_regs __user *addr);
+
 /*
  * Tracing a 32-bit process with a 64-bit strace and vice versa will not
  * work.  I don't know how to fix this.
@@ -410,6 +415,16 @@ asmlinkage int sys32_ptrace(int request, int pid, int addr, int data)
 				(unsigned long __user *) (unsigned long) data);
 		break;
 
+	case PTRACE_GET_WATCH_REGS:
+		ret = ptrace_get_watch_regs(child,
+			(struct pt_watch_regs __user *) (unsigned long) addr);
+		break;
+
+	case PTRACE_SET_WATCH_REGS:
+		ret = ptrace_set_watch_regs(child,
+			(struct pt_watch_regs __user *) (unsigned long) addr);
+		break;
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/include/asm-mips/ptrace.h b/include/asm-mips/ptrace.h
index 786f7e3..a9f2201 100644
--- a/include/asm-mips/ptrace.h
+++ b/include/asm-mips/ptrace.h
@@ -71,6 +71,44 @@ struct pt_regs {
 #define PTRACE_POKEDATA_3264	0xc3
 #define PTRACE_GET_THREAD_AREA_3264	0xc4
 
+/* Read and write watchpoint registers.  */
+enum pt_watch_style {
+	pt_watch_style_mips32,
+	pt_watch_style_mips64
+};
+struct mips32_watch_regs {
+	uint32_t watchlo[8];
+	/* Lower 16 bits of watchhi. */
+	uint16_t watchhi[8];
+	/* Valid mask and I R W bits.
+	 * bit 0 -- 1 if W bit is usable.
+	 * bit 1 -- 1 if R bit is usable.
+	 * bit 2 -- 1 if I bit is usable.
+	 * bits 3 - 11 -- Valid watchhi mask bits.
+	 */
+	uint16_t watch_masks[8];
+	/* The number of valid watch register pairs.  */
+	uint32_t num_valid;
+} __attribute__ ((aligned (8)));
+
+struct mips64_watch_regs {
+	uint64_t watchlo[8];
+	uint16_t watchhi[8];
+	uint16_t watch_masks[8];
+	uint32_t num_valid;
+} __attribute__ ((aligned (8)));
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
1.5.5.1

