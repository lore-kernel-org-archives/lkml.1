Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbZKFWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbZKFWlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932392AbZKFWlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:25 -0500
Received: from www.tglx.de ([62.245.132.106]:53918 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbZKFWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:23 -0500
Message-Id: <20091106223806.438133612@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       patches@arm.linux.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 01/16] arm: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=arm-remove-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Initialize the per cpu ipi locks via
spin_lock_init.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: patches@arm.linux.org.uk
Cc: Russell King <rmk+kernel@arm.linux.org.uk>

---
 arch/arm/kernel/smp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/smp.c
+++ linux-2.6/arch/arm/kernel/smp.c
@@ -55,9 +55,7 @@ struct ipi_data {
 	unsigned long bits;
 };
 
-static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
-	.lock	= SPIN_LOCK_UNLOCKED,
-};
+static DEFINE_PER_CPU(struct ipi_data, ipi_data);
 
 enum ipi_msg_type {
 	IPI_TIMER,
@@ -329,6 +327,9 @@ void __init smp_prepare_boot_cpu(void)
 	unsigned int cpu = smp_processor_id();
 
 	per_cpu(cpu_data, cpu).idle = current;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(ipi_data, cpu).lock);
 }
 
 static void send_ipi_message(const struct cpumask *mask, enum ipi_msg_type msg)


