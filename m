Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZCVLox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZCVLox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 07:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZCVLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 07:44:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:56157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbZCVLo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 07:44:28 -0400
Subject: [PATCH -tip 2/2] x86: irq.c keep CONFIG_X86_LOCAL_APIC interrupts
 together
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 17:13:55 +0530
Message-Id: <1237722235.2671.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the incremental patch of :
[PATCH -tip] x86: irq.c use same path for show_interrupts

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sun, 22 Mar 2009 16:10:09 +0530
Subject: [PATCH] x86: irq.c keep CONFIG_X86_LOCAL_APIC interrupts together

Impact: cleanup

keep CONFIG_X86_LOCAL_APIC interrupts together to avoid extra ifdef

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irq.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 5e7c3e6..3aaf7b9 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -58,6 +58,11 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
+
+	seq_printf(p, "%*s: ", prec, "SPU");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
+	seq_printf(p, "  Spurious interrupts\n");
 #endif
 	if (generic_interrupt_extension) {
 		seq_printf(p, "PLT: ");
@@ -91,12 +96,6 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Threshold APIC interrupts\n");
 # endif
 #endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	seq_printf(p, "%*s: ", prec, "SPU");
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
-	seq_printf(p, "  Spurious interrupts\n");
-#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
@@ -166,6 +165,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
+	sum += irq_stats(cpu)->irq_spurious_count;
 #endif
 	if (generic_interrupt_extension)
 		sum += irq_stats(cpu)->generic_irqs;
@@ -180,9 +180,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_threshold_count;
 #endif
 #endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	sum += irq_stats(cpu)->irq_spurious_count;
-#endif
 	return sum;
 }
 
-- 
1.6.0.6



