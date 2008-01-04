Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYADRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYADRwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYADRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:52:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:51639 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYADRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=fAsrr4vgHJTegPdfQVIpcrEQfzI4OfgLHVCNSrwIw5TKOVKRPknKlcOR83QWbVHiIrCIeLo5xQ56AsFuIjpDpuRI8vHg5ccfdjhH3FA5YQC6s3KQBiwRCMajW/mIXTfxPx3/94lM7LgsAMg+iHZH9DigE/UPLXlqckY+MAm0TgI=
Date: Fri, 4 Jan 2008 18:52:09 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
       mingo@elte.hu
Subject: [PATCH] profile: further Codying Style fixes, take 2
Message-ID: <20080104185209.111adeed@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further fixes to profile.c, checkpatch.pl now reports:

	total: 0 errors, 2 warnings, 601 lines checked

  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
  #410: FILE: profile.c:410:
  +EXPORT_SYMBOL_GPL(profile_hits);
I cannot fix this without changing the funtionality in case of non-SMP build.


  WARNING: externs should be avoided in .c files
  #509: FILE: profile.c:509:
  +       extern int setup_profiling_timer(unsigned int multiplier);
I don't know what to do with this warning.

Compile tested, no change in the size of the .o file after
applying the patch.

paolo@paolo-desktop:/tmp$ size profile.o.*
   text    data     bss     dec     hex filename
   3718     144      12    3874     f22 profile.o.after
   3718     144      12    3874     f22 profile.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 kernel/profile.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index c99153b..e64c2da 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -125,7 +125,7 @@ void profile_task_exit(struct task_struct *task)
 	blocking_notifier_call_chain(&task_exit_notifier, 0, task);
 }
 
-int profile_handoff_task(struct task_struct * task)
+int profile_handoff_task(struct task_struct *task)
 {
 	int ret;
 	ret = atomic_notifier_call_chain(&task_free_notifier, 0, task);
@@ -141,11 +141,13 @@ int task_handoff_register(struct notifier_block *n)
 {
 	return atomic_notifier_chain_register(&task_free_notifier, n);
 }
+EXPORT_SYMBOL_GPL(task_handoff_register);
 
 int task_handoff_unregister(struct notifier_block *n)
 {
 	return atomic_notifier_chain_unregister(&task_free_notifier, n);
 }
+EXPORT_SYMBOL_GPL(task_handoff_unregister);
 
 int profile_event_register(enum profile_type type, struct notifier_block *n)
 {
@@ -164,7 +166,7 @@ int profile_event_register(enum profile_type type, struct notifier_block *n)
 
 	return err;
 }
-
+EXPORT_SYMBOL_GPL(profile_event_register);
 
 int profile_event_unregister(enum profile_type type, struct notifier_block *n)
 {
@@ -183,6 +185,7 @@ int profile_event_unregister(enum profile_type type, struct notifier_block *n)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(profile_event_unregister);
 
 int register_timer_hook(int (*hook)(struct pt_regs *))
 {
@@ -191,6 +194,7 @@ int register_timer_hook(int (*hook)(struct pt_regs *))
 	timer_hook = hook;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(register_timer_hook);
 
 void unregister_timer_hook(int (*hook)(struct pt_regs *))
 {
@@ -199,13 +203,7 @@ void unregister_timer_hook(int (*hook)(struct pt_regs *))
 	/* make sure all CPUs see the NULL hook */
 	synchronize_sched();  /* Allow ongoing interrupts to complete. */
 }
-
-EXPORT_SYMBOL_GPL(register_timer_hook);
 EXPORT_SYMBOL_GPL(unregister_timer_hook);
-EXPORT_SYMBOL_GPL(task_handoff_register);
-EXPORT_SYMBOL_GPL(task_handoff_unregister);
-EXPORT_SYMBOL_GPL(profile_event_register);
-EXPORT_SYMBOL_GPL(profile_event_unregister);
 
 #endif /* CONFIG_PROFILING */
 
@@ -366,7 +364,7 @@ static int __devinit profile_cpu_callback(struct notifier_block *info,
 			per_cpu(cpu_profile_hits, cpu)[0] = page_address(page);
 		}
 		break;
-	out_free:
+out_free:
 		page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[1]);
 		per_cpu(cpu_profile_hits, cpu)[1] = NULL;
 		__free_page(page);
@@ -409,7 +407,6 @@ void profile_hits(int type, void *__pc, unsigned int nr_hits)
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
 }
 #endif /* !CONFIG_SMP */
-
 EXPORT_SYMBOL_GPL(profile_hits);
 
 void profile_tick(int type)
@@ -427,7 +424,7 @@ void profile_tick(int type)
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 
-static int prof_cpu_mask_read_proc (char *page, char **start, off_t off,
+static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
 	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
@@ -437,8 +434,8 @@ static int prof_cpu_mask_read_proc (char *page, char **start, off_t off,
 	return len;
 }
 
-static int prof_cpu_mask_write_proc (struct file *file, const char __user *buffer,
-					unsigned long count, void *data)
+static int prof_cpu_mask_write_proc(struct file *file,
+	const char __user *buffer,  unsigned long count, void *data)
 {
 	cpumask_t *mask = (cpumask_t *)data;
 	unsigned long full_count = count, err;
@@ -457,7 +454,8 @@ void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
 	struct proc_dir_entry *entry;
 
 	/* create /proc/irq/prof_cpu_mask */
-	if (!(entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)))
+	entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir);
+	if (!entry)
 		return;
 	entry->data = (void *)&prof_cpu_mask;
 	entry->read_proc = prof_cpu_mask_read_proc;
@@ -508,7 +506,7 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 #ifdef CONFIG_SMP
-	extern int setup_profiling_timer (unsigned int multiplier);
+	extern int setup_profiling_timer(unsigned int multiplier);
 
 	if (count == sizeof(int)) {
 		unsigned int multiplier;
@@ -591,7 +589,8 @@ static int __init create_proc_profile(void)
 		return 0;
 	if (create_hash_tables())
 		return -1;
-	if (!(entry = create_proc_entry("profile", S_IWUSR | S_IRUGO, NULL)))
+	entry = create_proc_entry("profile", S_IWUSR | S_IRUGO, NULL);
+	if (!entry)
 		return 0;
 	entry->proc_fops = &proc_profile_operations;
 	entry->size = (1+prof_len) * sizeof(atomic_t);
-- 
1.5.4.rc2.17.g257f

