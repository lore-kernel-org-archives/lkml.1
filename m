Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYCQXu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYCQXu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYCQXuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:50:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYCQXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:50:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:content-type:organization:date:
	message-id:mime-version:x-mailer:content-transfer-encoding;
	b=A8A40VA2Wc30oKo1tdoB3urph+PgVFz325A/rJTDETaKWI0IWiOxMPSTgn1QhH0uY
	wYDj/SVaxO+Ke0tZOxnFw==
Subject: [PATCH 2.6.25-rc6 resubmit] Add a "show workqueues" SYSRQ knob.
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 17 Mar 2008 16:50:07 -0700
Message-Id: <1205797807.15714.45.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Randy, I've added an update to Documentation/sysrq.txt and am
resubmitting the patch in the proper style.

This patch adds a convenient function to show all workqueues using the
magic SYSRQ handling.  It uses the 'z' key to invoke the function as the
'w' key was already gone.

I've found this very useful in debugging; hopefully others will find it
as useful.

diffstat wq.patch 
 drivers/char/sysrq.c      |   14 +++++++++++++-
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   26 ++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

Signed-off-by:  Frank Mayhar <fmayhar@google.com>


diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 10c8f69..bc5d6cc 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -110,6 +110,8 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
 
 'x'	- Used by xmon interface on ppc/powerpc platforms.
 
+'z'	- Will dump the contents of the workqueues by workqueue and CPU.
+
 '0'-'9' - Sets the console log level, controlling which kernel messages
           will be printed to your console. ('0', for example would make
           it so that only emergency messages like PANICs or OOPSes would
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index de60e1e..733d625 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -243,6 +243,18 @@ static struct sysrq_key_op sysrq_showmem_op = {
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
+static void sysrq_handle_showwq(int key, struct pt_regs *pt_regs,
+				   struct tty_struct *tty)
+{
+	show_workqueues();
+}
+static struct sysrq_key_op sysrq_showwq_op = {
+	.handler	= sysrq_handle_showwq,
+	.help_msg	= "showworkqueueZ",
+	.action_msg	= "Show Workqueues",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+
 /*
  * Signal sysrq helper function.  Sends a signal to all user processes.
  */
@@ -358,7 +370,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	/* x: May be registered on ppc/powerpc for xmon */
 	NULL,				/* x */
 	NULL,				/* y */
-	NULL				/* z */
+	&sysrq_showwq_op		/* z */
 };
 
 /* key2index calculation, -1 on invalid index */
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 542526c..6ae9ebb 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -195,6 +195,7 @@ extern int schedule_on_each_cpu(work_func_t func);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
 
+extern void show_workqueues(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ff06611..c97d35d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,6 +33,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/kallsyms.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -867,6 +868,31 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+void show_workqueues(void)
+{
+	struct workqueue_struct *wq;
+	int cpu;
+
+	spin_lock(&workqueue_lock);
+	list_for_each_entry(wq, &workqueues, list) {
+		printk("\n");
+		printk("Workqueue %s:\n", wq->name);
+		for_each_online_cpu(cpu) {
+			struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+			struct work_struct *work;
+
+			printk("\tCPU %d ", cpu);
+			list_for_each_entry(work, &(cwq->worklist), entry) {
+				print_symbol("function %s", (unsigned long)work->func);
+			}
+			printk("\n");
+		}
+	}
+	spin_unlock(&workqueue_lock);
+	
+}
+EXPORT_SYMBOL(show_workqueues);
+
 void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

