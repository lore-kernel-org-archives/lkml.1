Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYIWTer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYIWTer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIWTei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:34:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49265 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYIWTei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:34:38 -0400
Date: Tue, 23 Sep 2008 21:34:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080923193424.GA25728@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andrea Righi (1):
      x86, oprofile: BUG scheduling while atomic

Joerg Roedel (2):
      AMD IOMMU: set iommu sunc flag after command queuing
      AMD IOMMU: protect completion wait loop with iommu lock

Ravikiran G Thirumalai (1):
      x86: fix 27-rc crash on vsmp due to paravirt during module load


 arch/x86/kernel/amd_iommu.c |   22 ++++++++++++++++------
 arch/x86/kernel/vsmp_64.c   |    2 +-
 arch/x86/oprofile/nmi_int.c |    4 +++-
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 69b4d06..042fdc2 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -101,10 +101,10 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret, ready = 0;
+	int ret = 0, ready = 0;
 	unsigned status = 0;
 	struct iommu_cmd cmd;
-	unsigned long i = 0;
+	unsigned long flags, i = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
@@ -112,10 +112,12 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	iommu->need_sync = 0;
 
-	ret = iommu_queue_command(iommu, &cmd);
+	spin_lock_irqsave(&iommu->lock, flags);
+
+	ret = __iommu_queue_command(iommu, &cmd);
 
 	if (ret)
-		return ret;
+		goto out;
 
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
@@ -130,6 +132,8 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
 		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return 0;
 }
@@ -140,6 +144,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 {
 	struct iommu_cmd cmd;
+	int ret;
 
 	BUG_ON(iommu == NULL);
 
@@ -147,9 +152,11 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
 	cmd.data[0] = devid;
 
+	ret = iommu_queue_command(iommu, &cmd);
+
 	iommu->need_sync = 1;
 
-	return iommu_queue_command(iommu, &cmd);
+	return ret;
 }
 
 /*
@@ -159,6 +166,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 		u64 address, u16 domid, int pde, int s)
 {
 	struct iommu_cmd cmd;
+	int ret;
 
 	memset(&cmd, 0, sizeof(cmd));
 	address &= PAGE_MASK;
@@ -171,9 +179,11 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
 
+	ret = iommu_queue_command(iommu, &cmd);
+
 	iommu->need_sync = 1;
 
-	return iommu_queue_command(iommu, &cmd);
+	return ret;
 }
 
 /*
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 0c029e8..7766d36 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -61,7 +61,7 @@ static void vsmp_irq_enable(void)
 	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
-static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
 {
 	switch (type) {
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 0227694..8a5f161 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -295,10 +295,12 @@ static void nmi_cpu_shutdown(void *dummy)
 
 static void nmi_shutdown(void)
 {
-	struct op_msrs *msrs = &get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs;
+
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
 	put_cpu_var(cpu_msrs);
