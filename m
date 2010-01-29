Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221Ab0A2XNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0A2XNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881Ab0A2XNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:13:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab0A2XNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:13:18 -0500
Date: Fri, 29 Jan 2010 23:12:34 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lizf@cn.fujitsu.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, lizf@cn.fujitsu.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <20100129194330.207790269@sbs-t61.sc.intel.com>
References: <20100129194330.207790269@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Update the vector domain for legacy irqs handled by io-apic
Message-ID: <tip-69c89efb51510b3dc0fa336f7fa257c6e1799ee4@git.kernel.org>
Git-Commit-ID: 69c89efb51510b3dc0fa336f7fa257c6e1799ee4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 23:12:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69c89efb51510b3dc0fa336f7fa257c6e1799ee4
Gitweb:     http://git.kernel.org/tip/69c89efb51510b3dc0fa336f7fa257c6e1799ee4
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 29 Jan 2010 11:42:20 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 29 Jan 2010 14:47:17 -0800

x86, irq: Update the vector domain for legacy irqs handled by io-apic

In the recent change of not reserving IRQ0_VECTOR..IRQ15_VECTOR's on all
cpu's, we start with irq 0..15 getting directed to (and handled on) cpu-0.

In the logical flat mode, once the AP's are online (and before irqbalance
comes into picture), kernel intends to handle these IRQ's on any cpu (as the
logical flat mode allows to specify multiple cpu's for the irq destination and
the chipset based routing can deliver to the interrupt to any one of
the specified cpu's). This was broken with our recent change, which was ending
up using only cpu 0 as the destination, even when the kernel was specifying to
use all online cpu's for the logical flat mode case.

Fix this by updating vector allocation domain (cfg->domain) for legacy irqs,
when the IO-APIC handles them.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100129194330.207790269@sbs-t61.sc.intel.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1a30587..2430b31 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1428,6 +1428,14 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	cfg = desc->chip_data;
 
+	/*
+	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
+	 * controllers like 8259. Now that IO-APIC can handle this irq, update
+	 * the cfg->domain.
+	 */
+	if (irq < nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
+		apic->vector_allocation_domain(0, cfg->domain);
+
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
