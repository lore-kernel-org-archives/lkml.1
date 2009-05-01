Return-Path: <linux-kernel-owner+w=401wt.eu-S1763801AbZEARJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763801AbZEARJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763643AbZEARJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:09:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:42846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763616AbZEARJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:09:30 -0400
Date: Fri, 1 May 2009 17:07:47 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F6559F.7070005@kernel.org>
References: <49F6559F.7070005@kernel.org>
Subject: [tip:irq/numa] x86/irq: change MSI irq_desc to be more numa aware
Message-ID: <tip-d047f53a2ecce37e3bdf79eac5a326fbaadb3628@git.kernel.org>
Git-Commit-ID: d047f53a2ecce37e3bdf79eac5a326fbaadb3628
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:07:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d047f53a2ecce37e3bdf79eac5a326fbaadb3628
Gitweb:     http://git.kernel.org/tip/d047f53a2ecce37e3bdf79eac5a326fbaadb3628
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 18:02:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:18 +0200

x86/irq: change MSI irq_desc to be more numa aware

Try to get irq_desc on the home node in create_irq_nr().

v2: don't check if we can move it when sparse_irq is not used
v3: use move_irq_des, if that node is not what we want

[ Impact: optimization, make MSI IRQ descriptors more NUMA aware ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49F6559F.7070005@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |   17 +++++++++++++----
 include/linux/irq.h            |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 82376e0..9cd4806 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3172,14 +3172,13 @@ static int nr_irqs_gsi = NR_IRQS_LEGACY;
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int irq_want)
+unsigned int create_irq_nr(unsigned int irq_want, int node)
 {
 	/* Allocate an unused irq */
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
-	int node = cpu_to_node(boot_cpu_id);
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3197,6 +3196,13 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 		if (cfg_new->vector != 0)
 			continue;
+
+#ifdef CONFIG_NUMA_IRQ_DESC
+		/* different node ?*/
+		if (desc_new->node != node)
+			desc = move_irq_desc(desc, node);
+#endif
+
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
@@ -3214,11 +3220,12 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 int create_irq(void)
 {
+	int node = cpu_to_node(boot_cpu_id);
 	unsigned int irq_want;
 	int irq;
 
 	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want);
+	irq = create_irq_nr(irq_want, node);
 
 	if (irq == 0)
 		irq = -1;
@@ -3476,15 +3483,17 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	unsigned int irq_want;
 	struct intel_iommu *iommu = NULL;
 	int index = 0;
+	int node;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
+	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want);
+		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index a09baf8..4b95ddb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -376,7 +376,7 @@ extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want);
+extern unsigned int create_irq_nr(unsigned int irq_want, int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
