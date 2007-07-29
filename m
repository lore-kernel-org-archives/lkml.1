Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbXG2K3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbXG2K3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 06:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbXG2K3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 06:29:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:58735 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759710AbXG2K3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 06:29:16 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] sysrq: add a show-stacktrace-on-all-cpus command
Date: Sun, 29 Jul 2007 13:29:26 +0300
Message-Id: <11857049662730-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a cpu is spinning in the kernel but still responding to interrupts,
pressing sysrq-y will show you where it's spinning.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 39cc318..1dda709 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -45,6 +45,8 @@ int __read_mostly __sysrq_enabled = 1;
 
 static int __read_mostly sysrq_always_enabled;
 
+static spinlock_t show_stack_lock = SPIN_LOCK_UNLOCKED;
+
 int sysrq_on(void)
 {
 	return __sysrq_enabled || sysrq_always_enabled;
@@ -309,6 +311,26 @@ static struct sysrq_key_op sysrq_unrt_op = {
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
 
+static void show_cpu_stack(void *garbage)
+{
+	spin_lock(&show_stack_lock);
+	printk("CPU%d stacktrace:\n", raw_smp_processor_id());
+	dump_stack();
+	sysrq_handle_showregs(0, NULL);
+	spin_unlock(&show_stack_lock);
+}
+
+static void sysrq_show_stacks(int key, struct tty_struct *tty)
+{
+	on_each_cpu(show_cpu_stack, NULL, 0, 1);
+}
+
+static struct sysrq_key_op sysrq_show_stacks_op = {
+	.handler	= sysrq_show_stacks,
+	.help_msg	= "stacktraces-on-all-cpus(Y)",
+	.action_msg	= "Stack traces on all cpus",
+};
+
 /* Key Operations table and lock */
 static DEFINE_SPINLOCK(sysrq_key_table_lock);
 
@@ -356,7 +378,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_showstate_blocked_op,	/* w */
 	/* x: May be registered on ppc/powerpc for xmon */
 	NULL,				/* x */
-	NULL,				/* y */
+	&sysrq_show_stacks_op,		/* y */
 	NULL				/* z */
 };
 
