Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYHJHk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYHJHk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYHJHhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:37:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbYHJHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A0SPdcl90roFBVRjcz0i7IZI6Rs/r2OL3OIJrOeY5LTCDCKKMyRzIJftVcJPFMtnw8
         avAa8XJ+ubl//NyrfrVsSXlpFGvxVJ2taKnq0OeU2xUMkOuGBJVYq7zjV+pV+Zvestse
         uzKGDCP4e2SKqdQmuHiK3HCSRgcA9i1PKB6EA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 09/43] introduce nr_irqs
Date: Sun, 10 Aug 2008 00:35:58 -0700
Message-Id: <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and at this point it is equal NR_IRQS

v2: according to Eric, we need to take care of arch without generic_hardirqs

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/m68k/kernel/ints.c   |    2 ++
 arch/s390/kernel/irq.c    |    2 ++
 arch/sparc/kernel/irq.c   |    3 +++
 include/linux/interrupt.h |    2 ++
 kernel/irq/autoprobe.c    |   10 +++++-----
 kernel/irq/chip.c         |   20 ++++++++++----------
 kernel/irq/handle.c       |    3 ++-
 kernel/irq/manage.c       |   16 ++++++++--------
 kernel/irq/proc.c         |    2 +-
 kernel/irq/resend.c       |    4 ++--
 kernel/irq/spurious.c     |    4 ++--
 11 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index ded7dd2..d8aebfc 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -46,6 +46,8 @@
 #include <asm/q40ints.h>
 #endif
 
+int nr_irqs = NR_IRQS;
+
 extern u32 auto_irqhandler_fixup[];
 extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index e7c5bfb..14eb549 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -17,6 +17,8 @@
 #include <linux/proc_fs.h>
 #include <linux/profile.h>
 
+int nr_irqs = NR_IRQS;
+
 /*
  * show_interrupts is needed by /proc/interrupts.
  */
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 93e1d1c..059598b 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -55,6 +55,9 @@
 #define SMP_NOP2
 #define SMP_NOP3
 #endif /* SMP */
+
+int nr_irqs = NR_IRQS;
+
 unsigned long __raw_local_irq_save(void)
 {
 	unsigned long retval;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 49aa4c8..21022ce 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -15,6 +15,8 @@
 #include <asm/ptrace.h>
 #include <asm/system.h>
 
+extern int nr_irqs;
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 533068c..c689e98 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -38,7 +38,7 @@ unsigned long probe_irq_on(void)
 	 * something may have generated an irq long ago and we want to
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
-	for (i = NR_IRQS-1; i > 0; i--) {
+	for (i = nr_irqs-1; i > 0; i--) {
 		desc = irq_desc + i;
 
 		spin_lock_irq(&desc->lock);
@@ -68,7 +68,7 @@ unsigned long probe_irq_on(void)
 	 * (we must startup again here because if a longstanding irq
 	 * happened in the previous stage, it may have masked itself)
 	 */
-	for (i = NR_IRQS-1; i > 0; i--) {
+	for (i = nr_irqs-1; i > 0; i--) {
 		desc = irq_desc + i;
 
 		spin_lock_irq(&desc->lock);
@@ -89,7 +89,7 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	mask = 0;
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		unsigned int status;
 
 		desc = irq_desc + i;
@@ -130,7 +130,7 @@ unsigned int probe_irq_mask(unsigned long val)
 	int i;
 
 	mask = 0;
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
@@ -173,7 +173,7 @@ int probe_irq_off(unsigned long val)
 {
 	int i, irq_found = 0, nr_irqs = 0;
 
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3cd441e..20a9307 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -27,7 +27,7 @@ void dynamic_irq_init(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
@@ -60,7 +60,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
@@ -92,7 +92,7 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
@@ -121,7 +121,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
 	}
@@ -148,7 +148,7 @@ int set_irq_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
 		return -EINVAL;
@@ -174,7 +174,7 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
@@ -200,7 +200,7 @@ int set_irq_chip_data(unsigned int irq, void *data)
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !desc->chip) {
+	if (irq >= nr_irqs || !desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
 	}
@@ -544,7 +544,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
 		return;
@@ -609,7 +609,7 @@ void __init set_irq_noprobe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
 		return;
@@ -627,7 +627,7 @@ void __init set_irq_probe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
 		return;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index f4c8a03..e9d022c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -47,6 +47,7 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
  *
  * Controller mappings for all interrupt sources:
  */
+int nr_irqs = NR_IRQS;
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
@@ -265,7 +266,7 @@ void early_init_irq_lock_class(void)
 {
 	int i;
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		lockdep_set_class(&irq_desc[i].lock, &irq_desc_lock_class);
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 22d10d3..3bd67c8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -34,7 +34,7 @@ void synchronize_irq(unsigned int irq)
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned int status;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	do {
@@ -143,7 +143,7 @@ void disable_irq_nosync(unsigned int irq)
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -171,7 +171,7 @@ void disable_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	disable_irq_nosync(irq);
@@ -214,7 +214,7 @@ void enable_irq(unsigned int irq)
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -290,7 +290,7 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
 	struct irqaction *action;
 
-	if (irq >= NR_IRQS || irq_desc[irq].status & IRQ_NOREQUEST)
+	if (irq >= nr_irqs || irq_desc[irq].status & IRQ_NOREQUEST)
 		return 0;
 
 	action = irq_desc[irq].action;
@@ -349,7 +349,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	int shared = 0;
 	int ret;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return -EINVAL;
 
 	if (desc->chip == &no_irq_chip)
@@ -503,7 +503,7 @@ void free_irq(unsigned int irq, void *dev_id)
 	unsigned long flags;
 
 	WARN_ON(in_interrupt());
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	desc = irq_desc + irq;
@@ -617,7 +617,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	 */
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return -EINVAL;
 	if (irq_desc[irq].status & IRQ_NOREQUEST)
 		return -EINVAL;
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 6c6d35d..74d7922 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -234,7 +234,7 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		register_irq_proc(i);
 }
 
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index a804679..cba8aa5 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -33,8 +33,8 @@ static void resend_irqs(unsigned long arg)
 	struct irq_desc *desc;
 	int irq;
 
-	while (!bitmap_empty(irqs_resend, NR_IRQS)) {
-		irq = find_first_bit(irqs_resend, NR_IRQS);
+	while (!bitmap_empty(irqs_resend, nr_irqs)) {
+		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
 		desc = irq_desc + irq;
 		local_irq_disable();
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 19fe9d6..e26ca1e 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -91,7 +91,7 @@ static int misrouted_irq(int irq)
 	int i;
 	int ok = 0;
 
-	for (i = 1; i < NR_IRQS; i++) {
+	for (i = 1; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 
 		if (i == irq)	/* Already tried */
@@ -107,7 +107,7 @@ static int misrouted_irq(int irq)
 static void poll_spurious_irqs(unsigned long dummy)
 {
 	int i;
-	for (i = 1; i < NR_IRQS; i++) {
+	for (i = 1; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
-- 
1.5.4.5

