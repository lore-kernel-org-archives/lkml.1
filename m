Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742Ab0A2XNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0A2XNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804Ab0A2XNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:13:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:53901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0A2XNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:13:16 -0500
Date: Fri, 29 Jan 2010 23:12:50 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lizf@cn.fujitsu.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, lizf@cn.fujitsu.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <20100129194330.283696385@sbs-t61.sc.intel.com>
References: <20100129194330.283696385@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Move __setup_vector_irq() before the first irq enable in cpu online path
Message-ID: <tip-9d133e5db993d577bd868b54083869fe5479fcff@git.kernel.org>
Git-Commit-ID: 9d133e5db993d577bd868b54083869fe5479fcff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 23:12:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d133e5db993d577bd868b54083869fe5479fcff
Gitweb:     http://git.kernel.org/tip/9d133e5db993d577bd868b54083869fe5479fcff
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 29 Jan 2010 11:42:21 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 29 Jan 2010 14:47:22 -0800

x86, irq: Move __setup_vector_irq() before the first irq enable in cpu online path

Lowest priority delivery of logical flat mode is broken on some systems,
such that even when IO-APIC RTE says deliver the interrupt to a particular CPU,
interrupt subsystem delivers the interrupt to totally different CPU.

For example, this behavior was observed on a P4 based system with SiS chipset
which was reported by Li Zefan. We have been handling this kind of behavior by
making sure that in logical flat mode, we assign the same vector to irq
mappings on all the 8 possible logical cpu's.

But we have been doing this initial assignment (__setup_vector_irq()) a little
late (before which interrupts were already enabled for a short duration).

Move the __setup_vector_irq() before the first irq enable point in the
cpu online path to avoid the issue of not handling some interrupts that
wrongly hit the cpu which is still coming online.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100129194330.283696385@sbs-t61.sc.intel.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |    8 +++++++-
 arch/x86/kernel/smpboot.c      |    6 +++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2430b31..937150e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1256,11 +1256,16 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
-	/* This function must be called with vector_lock held */
 	int irq, vector;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 
+	/*
+	 * vector_lock will make sure that we don't run into irq vector
+	 * assignments that might be happening on another cpu in parallel,
+	 * while we setup our initial vector to irq mappings.
+	 */
+	spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
@@ -1279,6 +1284,7 @@ void __setup_vector_irq(int cpu)
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
+	spin_unlock(&vector_lock);
 }
 
 static struct irq_chip ioapic_chip;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..b2ebcba 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -241,6 +241,11 @@ static void __cpuinit smp_callin(void)
 	map_cpu_to_logical_apicid();
 
 	notify_cpu_starting(cpuid);
+
+	/*
+	 * Need to setup vector mappings before we enable interrupts.
+	 */
+	__setup_vector_irq(smp_processor_id());
 	/*
 	 * Get our bogomips.
 	 *
@@ -315,7 +320,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 */
 	ipi_call_lock();
 	lock_vector_lock();
-	__setup_vector_irq(smp_processor_id());
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
 	ipi_call_unlock();
