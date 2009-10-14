Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZJNISm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZJNISm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZJNISl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:18:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:41868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbZJNISh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:18:37 -0400
Date: Wed, 14 Oct 2009 08:17:35 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091013201022.926793122@openvz.org>
References: <20091013201022.926793122@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Limit apic dumping, introduce new show_lapic= setup option
Message-ID: <tip-2626eb2b2fd958dc0f683126aa84e93b939699a1@git.kernel.org>
Git-Commit-ID: 2626eb2b2fd958dc0f683126aa84e93b939699a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 08:17:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2626eb2b2fd958dc0f683126aa84e93b939699a1
Gitweb:     http://git.kernel.org/tip/2626eb2b2fd958dc0f683126aa84e93b939699a1
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 14 Oct 2009 00:07:05 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 09:17:01 +0200

x86, apic: Limit apic dumping, introduce new show_lapic= setup option

In case if a system has a large number of cpus printing apics
contents may consume a long time period.

We limit such an output by 1 apic by default. But to have an
ability to see all apics or some part of them we introduce
"show_lapic" setup option which allow us to limit/unlimit the
number of APICs being dumped.

Example: apic=debug show_lapic=5, or apic=debug show_lapic=all

Also move apic_verbosity checking upper that way so helper routines
do not need to inspect it at all.

Suggested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: yinghai@kernel.org
Cc: macro@linux-mips.org
LKML-Reference: <20091013201022.926793122@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   47 +++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dc69f28..8c718c9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1599,9 +1599,6 @@ __apicdebuginit(void) print_IO_APIC(void)
 	struct irq_desc *desc;
 	unsigned int irq;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
@@ -1708,9 +1705,6 @@ __apicdebuginit(void) print_APIC_field(int base)
 {
 	int i;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG);
 
 	for (i = 0; i < 8; i++)
@@ -1724,9 +1718,6 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
-	if (apic_verbosity == APIC_QUIET)
-		return;
-
 	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
@@ -1824,13 +1815,19 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk("\n");
 }
 
-__apicdebuginit(void) print_all_local_APICs(void)
+__apicdebuginit(void) print_local_APICs(int maxcpu)
 {
 	int cpu;
 
+	if (!maxcpu)
+		return;
+
 	preempt_disable();
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
+		if (cpu >= maxcpu)
+			break;
 		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
+	}
 	preempt_enable();
 }
 
@@ -1839,7 +1836,7 @@ __apicdebuginit(void) print_PIC(void)
 	unsigned int v;
 	unsigned long flags;
 
-	if (apic_verbosity == APIC_QUIET || !nr_legacy_irqs)
+	if (!nr_legacy_irqs)
 		return;
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
@@ -1866,21 +1863,41 @@ __apicdebuginit(void) print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-__apicdebuginit(int) print_all_ICs(void)
+static int __initdata show_lapic = 1;
+static __init int setup_show_lapic(char *arg)
+{
+	int num = -1;
+
+	if (strcmp(arg, "all") == 0) {
+		show_lapic = CONFIG_NR_CPUS;
+	} else {
+		get_option(&arg, &num);
+		if (num >= 0)
+			show_lapic = num;
+	}
+
+	return 1;
+}
+__setup("show_lapic=", setup_show_lapic);
+
+__apicdebuginit(int) print_ICs(void)
 {
+	if (apic_verbosity == APIC_QUIET)
+		return 0;
+
 	print_PIC();
 
 	/* don't print out if apic is not there */
 	if (!cpu_has_apic && !apic_from_smp_config())
 		return 0;
 
-	print_all_local_APICs();
+	print_local_APICs(show_lapic);
 	print_IO_APIC();
 
 	return 0;
 }
 
-fs_initcall(print_all_ICs);
+fs_initcall(print_ICs);
 
 
 /* Where if anywhere is the i8259 connect in external int mode */
