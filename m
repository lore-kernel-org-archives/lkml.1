Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYCJCra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYCJCra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 22:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYCJCrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 22:47:22 -0400
Received: from 74-92-59-67-NewEngland.hfc.comcastbusiness.net ([74.92.59.67]:50380
	"EHLO shelob.surriel.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbYCJCrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 22:47:22 -0400
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Mar 2008 22:47:22 EDT
Date: Sun, 9 Mar 2008 22:14:58 -0400
From: Rik van Riel <riel@surriel.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: [PATCH -mm] extend sysrq-p functionality to cover all CPUs
Message-ID: <20080309221458.20642e48@bree.surriel.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SysRP-P is not all that useful on SMP systems, since the sysrq
irq rarely ends up on the CPU that we actually want to investigate.

This patch extends sysrq-p to print a backtrace for every CPU,
not just the lucky one that gets the sysrq irq.  With this patch,
"echo p > /proc/sysrq-trigger" does something useful.

Signed-off-by: Rik van Riel <riel@redhat.com>

diff -up linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu linux-2.6.25-rc3-mm1/drivers/char/sysrq.c
--- linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu	2008-03-09 20:22:17.000000000 -0400
+++ linux-2.6.25-rc3-mm1/drivers/char/sysrq.c	2008-03-09 21:54:02.000000000 -0400
@@ -196,11 +196,29 @@ static struct sysrq_key_op sysrq_showloc
 #define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
 #endif
 
+static DEFINE_SPINLOCK(show_lock);
+static void showacpu(void *dummy)
+{
+	struct pt_regs *regs = get_irq_regs();
+
+	spin_lock(&show_lock);
+	printk("CPU%d:\n", smp_processor_id());
+	show_stack(NULL, NULL);
+	spin_unlock(&show_lock);
+}
+static void sysrq_showregs_othercpus(struct work_struct *dummy)
+{
+	smp_call_function(showacpu, NULL, 0, 0);
+}
+static DECLARE_WORK(sysrq_showregs, sysrq_showregs_othercpus);
 static void sysrq_handle_showregs(int key, struct tty_struct *tty)
 {
 	struct pt_regs *regs = get_irq_regs();
-	if (regs)
+	if (regs) {
+		printk("CPU%d:\n", smp_processor_id());
 		show_regs(regs);
+	}
+	schedule_work(&sysrq_showregs);
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,

