Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbZLCSyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbZLCSyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZLCSyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:54:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55055 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518AbZLCSyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:54:50 -0500
Date: Thu, 3 Dec 2009 19:54:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core for v2.6.33
Message-ID: <20091203185445.GA1612@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

 Thanks,

	Ingo

------------------>
Alexey Dobriyan (1):
      genirq: switch /proc/irq/*/spurious to seq_file

Cyrill Gorcunov (1):
      irq: Do not attempt to create subdirectories if /proc/irq/<irq> failed

Liuweni (1):
      irq: Fix docbook comments

Michael Neuling (1):
      irq: trivial: Fix typo in comment for #endif

Thomas Gleixner (2):
      irq: Remove unused debug_poll_all_shared_irqs()
      genirq: Fix spurious irq seqfile conversion


 include/linux/interrupt.h |    6 ------
 include/linux/irqflags.h  |    2 +-
 kernel/irq/chip.c         |    6 +++---
 kernel/irq/proc.c         |   40 ++++++++++++++++++++++++----------------
 kernel/irq/spurious.c     |   14 +-------------
 5 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 7ca72b7..75f3f00 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -603,12 +603,6 @@ static inline void init_irq_proc(void)
 }
 #endif
 
-#if defined(CONFIG_GENERIC_HARDIRQS) && defined(CONFIG_DEBUG_SHIRQ)
-extern void debug_poll_all_shared_irqs(void);
-#else
-static inline void debug_poll_all_shared_irqs(void) { }
-#endif
-
 struct seq_file;
 int show_interrupts(struct seq_file *p, void *v);
 
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index b02a3f1..006bf45 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -124,6 +124,6 @@
 	typecheck(unsigned long, flags);	\
 	raw_irqs_disabled_flags(flags);		\
 })
-#endif		/* CONFIG_X86 */
+#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #endif
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c166019..ba566c2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(set_irq_data);
 
 /**
- *	set_irq_data - set irq type data for an irq
+ *	set_irq_msi - set MSI descriptor data for an irq
  *	@irq:	Interrupt number
  *	@entry:	Pointer to MSI descriptor data
  *
- *	Set the hardware irq controller data for an irq
+ *	Set the MSI descriptor entry for an irq
  */
 int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 {
@@ -590,7 +590,7 @@ out_unlock:
 }
 
 /**
- *	handle_percpu_IRQ - Per CPU local irq handler
+ *	handle_percpu_irq - Per CPU local irq handler
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
  *
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 692363d..0832145 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -136,7 +136,7 @@ out:
 
 static int default_affinity_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, default_affinity_show, NULL);
+	return single_open(file, default_affinity_show, PDE(inode)->data);
 }
 
 static const struct file_operations default_affinity_proc_fops = {
@@ -148,18 +148,28 @@ static const struct file_operations default_affinity_proc_fops = {
 };
 #endif
 
-static int irq_spurious_read(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_spurious_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_to_desc((long) data);
-	return sprintf(page, "count %u\n"
-			     "unhandled %u\n"
-			     "last_unhandled %u ms\n",
-			desc->irq_count,
-			desc->irqs_unhandled,
-			jiffies_to_msecs(desc->last_unhandled));
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+
+	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
+		   desc->irq_count, desc->irqs_unhandled,
+		   jiffies_to_msecs(desc->last_unhandled));
+	return 0;
+}
+
+static int irq_spurious_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_spurious_proc_show, NULL);
 }
 
+static const struct file_operations irq_spurious_proc_fops = {
+	.open		= irq_spurious_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
@@ -204,7 +214,6 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
-	struct proc_dir_entry *entry;
 
 	if (!root_irq_dir || (desc->chip == &no_irq_chip) || desc->dir)
 		return;
@@ -214,6 +223,8 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 
 	/* create /proc/irq/1234 */
 	desc->dir = proc_mkdir(name, root_irq_dir);
+	if (!desc->dir)
+		return;
 
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
@@ -221,11 +232,8 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 #endif
 
-	entry = create_proc_entry("spurious", 0444, desc->dir);
-	if (entry) {
-		entry->data = (void *)(long)irq;
-		entry->read_proc = irq_spurious_read;
-	}
+	proc_create_data("spurious", 0444, desc->dir,
+			 &irq_spurious_proc_fops, (void *)(long)irq);
 }
 
 #undef MAX_NAMELEN
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 114e704..8996b98 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -104,7 +104,7 @@ static int misrouted_irq(int irq)
 	return ok;
 }
 
-static void poll_all_shared_irqs(void)
+static void poll_spurious_irqs(unsigned long dummy)
 {
 	struct irq_desc *desc;
 	int i;
@@ -123,23 +123,11 @@ static void poll_all_shared_irqs(void)
 
 		try_one_irq(i, desc);
 	}
-}
-
-static void poll_spurious_irqs(unsigned long dummy)
-{
-	poll_all_shared_irqs();
 
 	mod_timer(&poll_spurious_irq_timer,
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }
 
-#ifdef CONFIG_DEBUG_SHIRQ
-void debug_poll_all_shared_irqs(void)
-{
-	poll_all_shared_irqs();
-}
-#endif
-
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
