Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZDFVmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZDFVmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbZDFVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:42:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45789 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbZDFVmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:42:07 -0400
Message-ID: <49DA7744.8060007@redhat.com>
Date: Mon, 06 Apr 2009 17:42:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>
Subject: [RFC][PROTO][PATCH -tip 4/7] kprobes: add get_optinsn_slot()/free_optinsn_slot()
 for optimized kprobes
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add get_optinsn_slot() and free_optinsn_slot() for optimized_probes.
optinsn_slot will be bigger than normal insn_slot because optinsn_slot may
include interrupt emulation code and several instructions which will be
replaced by a jump instruction.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 include/linux/kprobes.h |    2 ++
 kernel/kprobes.c        |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)


diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 065bb24..c7674bf 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -270,6 +270,8 @@ extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
 extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
 extern int arch_detour_optimized_kprobe(struct optimized_kprobe *op,
 					struct pt_regs *regs);
+extern kprobe_opcode_t *get_optinsn_slot(void);
+extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
 #endif

 /* Get the kprobe at this addr (if any) - called with preemption disabled */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ba731ff..ddc1d38 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -296,6 +296,31 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
 	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
 	mutex_unlock(&kprobe_insn_mutex);
 }
+#ifdef CONFIG_OPTPROBES
+/* For optimized_kprobe buffer */
+static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
+static struct kprobe_insn_cache kprobe_optinsn_slots = {
+	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
+	/* .insn_size is initialized later */
+	.nr_garbage = 0,
+};
+/* Get a slot for optimized_kprobe buffer */
+kprobe_opcode_t __kprobes *get_optinsn_slot(void)
+{
+	kprobe_opcode_t *ret = NULL;
+	mutex_lock(&kprobe_optinsn_mutex);
+	ret = __get_insn_slot(&kprobe_optinsn_slots);
+	mutex_unlock(&kprobe_optinsn_mutex);
+	return ret;
+}
+
+void __kprobes free_optinsn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	mutex_lock(&kprobe_optinsn_mutex);
+	__free_insn_slot(&kprobe_optinsn_slots, slot, dirty);
+	mutex_unlock(&kprobe_optinsn_mutex);
+}
+#endif
 #endif

 /* We have preemption disabled.. so it is safe to use __ versions */
@@ -1388,6 +1413,11 @@ static int __init init_kprobes(void)
 		}
 	}

+#if defined(CONFIG_OPTPROBES) && defined(__ARCH_WANT_KPROBES_INSN_SLOT)
+	/* Init kprobe_optinsn_slots */
+	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
+#endif
+
 	/* By default, kprobes are armed */
 	kprobes_all_disarmed = false;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

