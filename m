Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbZLFHgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbZLFHgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbZLFHgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:36:02 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35687 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbZLFHfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:35:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RCwO5F9PnkuZ2Div59KjNH14xAHDdMT8AkF8xXkvK4ZJYbhyHYCgQ1YaXKPb8Bk3lW
         NJJYfI9kCBgEPVldfPRxpZUh20ZYiENrEoZhruAULiJyNU1RIwEOX5uJ8I6vR8MFG10s
         ZeS+XIrAkuOeGrp1UJpOS6DoIdbfzomk6Hhr4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 9/9] x86: Fixup wrong irq frame link in stacktraces
Date: Sun,  6 Dec 2009 08:34:58 +0100
Message-Id: <1260084898-11686-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we enter in irq, two things can happen to preserve the link
to the previous frame pointer:

- If we were in an irq already, we don't switch to the irq stack
  as we are inside. We just need to save the previous frame
  pointer and to link the new one to the previous.

- Otherwise we need another level of indirection. We enter the irq with
  the previous stack. We save the previous bp inside and make bp
  pointing to its saved address. Then we switch to the irq stack and
  push bp another time but to the new stack. This makes two levels to
  dereference instead of one.

In the second case, the current stacktrace code omits the second level
and loses the frame pointer accuracy. The stack that follows will then
be considered as unreliable.

Handling that makes the perf callchain happier.
Before:

43.94%  [k] _raw_read_lock
            |
            --- _read_lock
               |
               |--60.53%-- send_sigio
               |          __kill_fasync
               |          kill_fasync
               |          evdev_pass_event
               |          evdev_event
               |          input_pass_event
               |          input_handle_event
               |          input_event
               |          synaptics_process_byte
               |          psmouse_handle_byte
               |          psmouse_interrupt
               |          serio_interrupt
               |          i8042_interrupt
               |          handle_IRQ_event
               |          handle_edge_irq
               |          handle_irq
               |          __irqentry_text_start
               |          ret_from_intr
               |          |
               |          |--30.43%-- __select
               |          |
               |          |--17.39%-- 0x454f15
               |          |
               |          |--13.04%-- __read
               |          |
               |          |--13.04%-- vread_hpet
               |          |
               |          |--13.04%-- _xcb_lock_io
               |          |
               |           --13.04%-- 0x7f630878ce8

After:

    50.00%  [k] _raw_read_lock
            |
            --- _read_lock
               |
               |--98.97%-- send_sigio
               |          __kill_fasync
               |          kill_fasync
               |          evdev_pass_event
               |          evdev_event
               |          input_pass_event
               |          input_handle_event
               |          input_event
               |          |
               |          |--96.88%-- synaptics_process_byte
               |          |          psmouse_handle_byte
               |          |          psmouse_interrupt
               |          |          serio_interrupt
               |          |          i8042_interrupt
               |          |          handle_IRQ_event
               |          |          handle_edge_irq
               |          |          handle_irq
               |          |          __irqentry_text_start
               |          |          ret_from_intr
               |          |          |
               |          |          |--39.78%-- __const_udelay
               |          |          |          |
               |          |          |          |--91.89%-- ath5k_hw_register_timeout
               |          |          |          |          ath5k_hw_noise_floor_calibration
               |          |          |          |          ath5k_hw_reset
               |          |          |          |          ath5k_reset
               |          |          |          |          ath5k_config
               |          |          |          |          ieee80211_hw_config
               |          |          |          |          |
               |          |          |          |          |--88.24%-- ieee80211_scan_work
               |          |          |          |          |          worker_thread
               |          |          |          |          |          kthread
               |          |          |          |          |          child_rip
               |          |          |          |          |
               |          |          |          |           --11.76%-- ieee80211_scan_completed
               |          |          |          |                     ieee80211_scan_work
               |          |          |          |                     worker_thread
               |          |          |          |                     kthread
               |          |          |          |                     child_rip
               |          |          |          |
               |          |          |           --8.11%-- ath5k_hw_noise_floor_calibration
               |          |          |                     ath5k_hw_reset
               |          |          |                     ath5k_reset
               |          |          |                     ath5k_config

Note: This does not only affect perf events but also x86-64
stacktraces. They were considered as unreliable once we quit
the irq stack frame.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/dumpstack_64.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a071e6b..004b8aa 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -101,6 +101,35 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 	return NULL;
 }
 
+static inline int
+in_irq_stack(unsigned long *stack, unsigned long *irq_stack,
+	     unsigned long *irq_stack_end)
+{
+	return (stack >= irq_stack && stack < irq_stack_end);
+}
+
+/*
+ * We are returning from the irq stack and go to the previous one.
+ * If the previous stack is also in the irq stack, then bp in the first
+ * frame of the irq stack points to the previous, interrupted one.
+ * Otherwise we have another level of indirection: We first save
+ * the bp of the previous stack, then we switch the stack to the irq one
+ * and save a new bp that links to the previous one.
+ * (See save_args())
+ */
+static inline unsigned long
+fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
+		  unsigned long *irq_stack, unsigned long *irq_stack_end)
+{
+#ifdef CONFIG_FRAME_POINTER
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	if (!in_irq_stack(stack, irq_stack, irq_stack_end))
+		return (unsigned long)frame->next_frame;
+#endif
+	return bp;
+}
+
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -173,7 +202,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			irq_stack = irq_stack_end -
 				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
 
-			if (stack >= irq_stack && stack < irq_stack_end) {
+			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
 				bp = print_context_stack(tinfo, stack, bp,
@@ -184,6 +213,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				 * pointer (index -1 to end) in the IRQ stack:
 				 */
 				stack = (unsigned long *) (irq_stack_end[-1]);
+				bp = fixup_bp_irq_link(bp, stack, irq_stack,
+						       irq_stack_end);
 				irq_stack_end = NULL;
 				ops->stack(data, "EOI");
 				continue;
-- 
1.6.2.3

