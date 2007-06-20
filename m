Return-Path: <linux-kernel-owner+w=401wt.eu-S1763901AbXFTSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763901AbXFTSrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762761AbXFTSmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:42:06 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:43709 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762307AbXFTSmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:42:03 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 20:41:13 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
Message-ID: <20070620184113.GC5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:13.0346 (UTC)
 FILETIME=[93F37620:01C7B36A]
X-WSS-ID: 6A67AB7A23K948178-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-002.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Debug messages added for better debugging.

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/perfmon/perfmon_file.c
===================================================================
--- linux-2.6.22-rc3.orig/perfmon/perfmon_file.c
+++ linux-2.6.22-rc3/perfmon/perfmon_file.c
@@ -192,6 +192,8 @@ static int pfm_mmap(struct file *file, s
 	unsigned long flags;
 	int ret;
 
+	PFM_DBG("pfm_file_ops");
+
 	ctx  = file->private_data;
 	size = (vma->vm_end - vma->vm_start);
 
@@ -332,6 +334,8 @@ static ssize_t pfm_read(struct file *fil
 	union pfarg_msg msg_buf;
 	int non_block, ret;
 
+	PFM_DBG("pfm_file_ops");
+
 	ctx = filp->private_data;
 	if (ctx == NULL) {
 		PFM_ERR("no ctx for pfm_read");
@@ -375,6 +379,8 @@ static unsigned int pfm_poll(struct file
 	unsigned long flags;
 	unsigned int mask = 0;
 
+	PFM_DBG("pfm_file_ops");
+
 	if (filp->f_op != &pfm_file_ops) {
 		PFM_ERR("pfm_poll bad magic");
 		return 0;
@@ -449,6 +455,8 @@ static int pfm_fasync(int fd, struct fil
 	struct pfm_context *ctx;
 	int ret;
 
+	PFM_DBG("pfm_file_ops");
+
 	ctx = filp->private_data;
 	if (ctx == NULL) {
 		PFM_ERR("pfm_fasync no ctx");
@@ -611,6 +619,8 @@ static int pfm_close(struct inode *inode
 {
 	struct pfm_context *ctx;
 
+	PFM_DBG("pfm_file_ops");
+
 	ctx = filp->private_data;
 	if (ctx == NULL) {
 		PFM_ERR("no ctx");
@@ -621,6 +631,8 @@ static int pfm_close(struct inode *inode
 
 static int pfm_no_open(struct inode *irrelevant, struct file *dontcare)
 {
+	PFM_DBG("pfm_file_ops");
+
 	return -ENXIO;
 }
 
@@ -637,6 +649,8 @@ static int pfm_flush(struct file *filp, 
 {
 	struct pfm_context *ctx;
 
+	PFM_DBG("pfm_file_ops");
+
 	ctx = filp->private_data;
 	if (ctx == NULL) {
 		PFM_ERR("pfm_flush no ctx");
Index: linux-2.6.22-rc3/perfmon/perfmon_syscalls.c
===================================================================
--- linux-2.6.22-rc3.orig/perfmon/perfmon_syscalls.c
+++ linux-2.6.22-rc3/perfmon/perfmon_syscalls.c
@@ -403,6 +403,8 @@ asmlinkage long sys_pfm_create_context(s
 	void *fmt_arg = NULL;
 	int ret;
 
+	PFM_DBG("syscall");
+
 	if (atomic_read(&perfmon_disabled))
 		return -ENOSYS;
 
@@ -433,8 +435,12 @@ asmlinkage long sys_pfm_write_pmcs(int f
 	size_t sz;
 	int ret, fput_needed;
 
-	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
+	PFM_DBG("syscall");
+
+	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq)) {
+                PFM_DBG("invalid arg count %d", count);
 		return -EINVAL;
+	}
 
 	sz = count*sizeof(*ureq);
 
@@ -475,6 +481,8 @@ asmlinkage long sys_pfm_write_pmcs(int f
 		kfree(fptr);
 error:
 	fput_light(filp, fput_needed);
+	if (ret)
+		PFM_DBG("failed: errno=%d", -ret);
 
 	return ret;
 }
@@ -490,6 +498,8 @@ asmlinkage long sys_pfm_write_pmds(int f
 	size_t sz;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
 		return -EINVAL;
 
@@ -543,6 +553,8 @@ asmlinkage long sys_pfm_read_pmds(int fd
 	size_t sz;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
 		return -EINVAL;
 
@@ -591,6 +603,8 @@ asmlinkage long sys_pfm_restart(int fd)
 	unsigned long flags;
 	int ret, fput_needed, complete_needed;
 
+	PFM_DBG("syscall");
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(filp == NULL)) {
 		PFM_DBG("invalid fd %d", fd);
@@ -647,6 +661,8 @@ asmlinkage long sys_pfm_stop(int fd)
 	unsigned long flags;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(filp == NULL)) {
 		PFM_DBG("invalid fd %d", fd);
@@ -682,6 +698,8 @@ asmlinkage long sys_pfm_start(int fd, st
 	unsigned long flags;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(filp == NULL)) {
 		PFM_DBG("invalid fd %d", fd);
@@ -724,6 +742,8 @@ asmlinkage long sys_pfm_load_context(int
 	struct pfarg_load req;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	if (copy_from_user(&req, ureq, sizeof(req)))
 		return -EFAULT;
 
@@ -792,6 +812,8 @@ asmlinkage long sys_pfm_unload_context(i
 	int is_system, can_release = 0;
 	u32 cpu;
 
+	PFM_DBG("syscall");
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(filp == NULL)) {
 		PFM_DBG("invalid fd %d", fd);
@@ -834,6 +856,8 @@ asmlinkage long sys_pfm_create_evtsets(i
 	size_t sz;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
 		return -EINVAL;
 
@@ -890,6 +914,8 @@ asmlinkage long  sys_pfm_getinfo_evtsets
 	size_t sz;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
 		return -EINVAL;
 
@@ -932,6 +958,8 @@ asmlinkage long  sys_pfm_getinfo_evtsets
 	kfree(fptr);
 error:
 	fput_light(filp, fput_needed);
+	if (ret)
+		PFM_DBG("failed: errno=%d", -ret);
 	return ret;
 }
 
@@ -945,6 +973,8 @@ asmlinkage long sys_pfm_delete_evtsets(i
 	size_t sz;
 	int ret, fput_needed;
 
+	PFM_DBG("syscall");
+
 	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
 		return -EINVAL;
 
Index: linux-2.6.22-rc3/perfmon/perfmon_rw.c
===================================================================
--- linux-2.6.22-rc3.orig/perfmon/perfmon_rw.c
+++ linux-2.6.22-rc3/perfmon/perfmon_rw.c
@@ -474,7 +474,7 @@ int __pfm_write_pmcs(struct pfm_context 
 	return 0;
 error:
 	pfm_retflag_set(req->reg_flags, error_code);
-	PFM_DBG("set%u pmc%u error=%d", set_id, cnum, error_code);
+	PFM_DBG("set%u pmc%u error=0x%08x", set_id, cnum, error_code);
 	return ret;
 }
 
Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
+++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
@@ -140,6 +140,10 @@ static inline void pfm_arch_write_pmc(st
 	if (ctx && ctx->flags.started == 0)
 		return;
 
+	PFM_DBG_ovfl("pfm_arch_write_pmc(0x%016Lx, 0x%016Lx)",
+		     (unsigned long long) pfm_pmu_conf->pmc_desc[cnum].hw_addr,
+		     (unsigned long long) value);
+	BUG_ON(pfm_pmu_conf->pmc_desc[cnum].type & PFM_REG_V);
 	if (arch_info->pmu_style == PFM_X86_PMU_P4)
 		__pfm_write_reg_p4(&arch_info->pmc_addrs[cnum], value);
 	else
@@ -155,6 +159,10 @@ static inline void pfm_arch_write_pmd(st
 	if (pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_C64)
 		value |= ~pfm_pmu_conf->ovfl_mask;
 
+	PFM_DBG_ovfl("pfm_arch_write_pmd(0x%016Lx, 0x%016Lx)",
+		     (unsigned long long) pfm_pmu_conf->pmd_desc[cnum].hw_addr,
+		     (unsigned long long) value);
+	BUG_ON(pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_V);
 	if (arch_info->pmu_style == PFM_X86_PMU_P4)
 		__pfm_write_reg_p4(&arch_info->pmd_addrs[cnum], value);
 	else
@@ -165,10 +173,14 @@ static inline u64 pfm_arch_read_pmd(stru
 {
 	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
 	u64 tmp;
+	BUG_ON(pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_V);
 	if (arch_info->pmu_style == PFM_X86_PMU_P4)
 		__pfm_read_reg_p4(&arch_info->pmd_addrs[cnum], &tmp);
 	else
 		rdmsrl(pfm_pmu_conf->pmd_desc[cnum].hw_addr, tmp);
+	PFM_DBG_ovfl("pfm_arch_read_pmd(0x%016Lx) = 0x%016Lx",
+		     (unsigned long long) pfm_pmu_conf->pmd_desc[cnum].hw_addr,
+		     (unsigned long long) tmp);
 	return tmp;
 }
 
@@ -176,10 +188,14 @@ static inline u64 pfm_arch_read_pmc(stru
 {
 	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
 	u64 tmp;
+	BUG_ON(pfm_pmu_conf->pmc_desc[cnum].type & PFM_REG_V);
 	if (arch_info->pmu_style == PFM_X86_PMU_P4)
 		__pfm_read_reg_p4(&arch_info->pmc_addrs[cnum], &tmp);
 	else
 		rdmsrl(pfm_pmu_conf->pmc_desc[cnum].hw_addr, tmp);
+        PFM_DBG_ovfl("pfm_arch_read_pmc(0x%016Lx) = 0x%016Lx",
+		     (unsigned long long) pfm_pmu_conf->pmc_desc[cnum].hw_addr,
+		     (unsigned long long) tmp);
 	return tmp;
 }
 
Index: linux-2.6.22-rc3/perfmon/perfmon.c
===================================================================
--- linux-2.6.22-rc3.orig/perfmon/perfmon.c
+++ linux-2.6.22-rc3/perfmon/perfmon.c
@@ -865,7 +865,8 @@ int __init pfm_init(void)
 {
 	int ret;
 
-	PFM_LOG("version %u.%u", PFM_VERSION_MAJ, PFM_VERSION_MIN);
+	PFM_LOG("version %u.%u, compiled: " __DATE__ ", " __TIME__,
+		PFM_VERSION_MAJ, PFM_VERSION_MIN);
 
 	pfm_ctx_cachep = kmem_cache_create("pfm_context",
 				   sizeof(struct pfm_context)+PFM_ARCH_CTX_SIZE,
Index: linux-2.6.22-rc3/perfmon/perfmon_intr.c
===================================================================
--- linux-2.6.22-rc3.orig/perfmon/perfmon_intr.c
+++ linux-2.6.22-rc3/perfmon/perfmon_intr.c
@@ -170,6 +170,7 @@ static void pfm_overflow_handler(struct 
 		 * check for overflow condition
 		 */
 		if (likely(old_val > new_val)) {
+			PFM_DBG_ovfl("64 bit overflow of PMD%d", i);
 			has_64b_ovfl = 1;
 			if (has_ovfl_sw && ovfl_thres > 0) {
 				if (ovfl_thres == 1)
@@ -188,11 +189,13 @@ static void pfm_overflow_handler(struct 
 				  max_pmd);
 
 		} else {
+			PFM_DBG_ovfl("Hardware counter overflow of PMD%d=0x%04llx",
+				i, new_val);
 			/* only keep track of 64-bit overflows */
 			__clear_bit(i, ulp(pend_ovfls));
 			/*
-		 	 * on some PMU, it may be necessary to re-arm the PMD
-		 	 */
+			 * on some PMU, it may be necessary to re-arm the PMD
+			 */
 			pfm_arch_ovfl_reset_pmd(ctx, i);
 		}
 

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



