Return-Path: <linux-kernel-owner+w=401wt.eu-S933690AbZINUJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbZINUJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbZINUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54172 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933650AbZINUJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:01 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 58/72] Blackfin: use raw_smp_processor_id() in exception code
Date: Mon, 14 Sep 2009 16:08:02 -0400
Message-Id: <1252958896-25150-59-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

When preempt debugging is enabled, smp_processor_id() may utilize the
"current" structure.  This may not be safe to access under all exceptions
due to it being in dynamically allocated memory.  So in exception code,
make sure we use raw_smp_processor_id() instead to get at the real value
directly.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c   |    2 +-
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c |    2 +-
 arch/blackfin/kernel/traps.c              |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index 651b127..8e1e9e9 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -280,7 +280,7 @@ static noinline int dcplb_protection_fault(unsigned int cpu)
 int cplb_hdr(int seqstat, struct pt_regs *regs)
 {
 	int cause = seqstat & 0x3f;
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu = raw_smp_processor_id();
 	switch (cause) {
 	case 0x23:
 		return dcplb_protection_fault(cpu);
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbmgr.c b/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
index aabbb42..d9ea46c 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
@@ -202,7 +202,7 @@ MGR_ATTR static int dcplb_miss(int cpu)
 MGR_ATTR int cplb_hdr(int seqstat, struct pt_regs *regs)
 {
 	int cause = seqstat & 0x3f;
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu = raw_smp_processor_id();
 	switch (cause) {
 	case VEC_CPLB_I_M:
 		return icplb_miss(cpu);
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 7b3ba06..56464cb 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -227,7 +227,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 	printk(KERN_EMERG "Double Fault\n");
 #ifdef CONFIG_DEBUG_DOUBLEFAULT_PRINT
 	if (((long)fp->seqstat &  SEQSTAT_EXCAUSE) == VEC_UNCOV) {
-		unsigned int cpu = smp_processor_id();
+		unsigned int cpu = raw_smp_processor_id();
 		char buf[150];
 		decode_address(buf, cpu_pda[cpu].retx_doublefault);
 		printk(KERN_EMERG "While handling exception (EXCAUSE = 0x%x) at %s:\n",
@@ -263,7 +263,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)
 	int j;
 #endif
 #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu = raw_smp_processor_id();
 #endif
 	const char *strerror = NULL;
 	int sig = 0;
@@ -1098,7 +1098,7 @@ void show_regs(struct pt_regs *fp)
 	struct irqaction *action;
 	unsigned int i;
 	unsigned long flags = 0;
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu = raw_smp_processor_id();
 	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 
 	verbose_printk(KERN_NOTICE "\n");
@@ -1126,13 +1126,13 @@ void show_regs(struct pt_regs *fp)
 
 	verbose_printk(KERN_NOTICE "\nSEQUENCER STATUS:\t\t%s\n", print_tainted());
 	verbose_printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  IMASK: %04lx  SYSCFG: %04lx\n",
-		(long)fp->seqstat, fp->ipend, cpu_pda[smp_processor_id()].ex_imask, fp->syscfg);
+		(long)fp->seqstat, fp->ipend, cpu_pda[raw_smp_processor_id()].ex_imask, fp->syscfg);
 	if (fp->ipend & EVT_IRPTEN)
 		verbose_printk(KERN_NOTICE "  Global Interrupts Disabled (IPEND[4])\n");
-	if (!(cpu_pda[smp_processor_id()].ex_imask & (EVT_IVG13 | EVT_IVG12 | EVT_IVG11 |
+	if (!(cpu_pda[raw_smp_processor_id()].ex_imask & (EVT_IVG13 | EVT_IVG12 | EVT_IVG11 |
 			EVT_IVG10 | EVT_IVG9 | EVT_IVG8 | EVT_IVG7 | EVT_IVTMR)))
 		verbose_printk(KERN_NOTICE "  Peripheral interrupts masked off\n");
-	if (!(cpu_pda[smp_processor_id()].ex_imask & (EVT_IVG15 | EVT_IVG14)))
+	if (!(cpu_pda[raw_smp_processor_id()].ex_imask & (EVT_IVG15 | EVT_IVG14)))
 		verbose_printk(KERN_NOTICE "  Kernel interrupts masked off\n");
 	if ((fp->seqstat & SEQSTAT_EXCAUSE) == VEC_HWERR) {
 		verbose_printk(KERN_NOTICE "  HWERRCAUSE: 0x%lx\n",
-- 
1.6.4.2

