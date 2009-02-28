Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZB1Bo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZB1Bo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZB1BmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41764 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZB1Bl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:56 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/30] KVM: ia64: Implement some pal calls needed for windows 2008
Date: Sat, 28 Feb 2009 03:41:22 +0200
Message-Id: <1235785309-12835-4-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

For windows 2008, it needs more pal calls to implement for booting.
In addition, also changes the name of set_{sal, pal}_call_result to
get_{sal,pal}_call_result for readability.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm_fw.c  |  151 ++++++++++++++++++++++++++++++++++++++++++++++-
 arch/ia64/kvm/process.c |    8 +-
 2 files changed, 152 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
index cb7600b..a8ae52e 100644
--- a/arch/ia64/kvm/kvm_fw.c
+++ b/arch/ia64/kvm/kvm_fw.c
@@ -227,6 +227,18 @@ static struct ia64_pal_retval pal_proc_get_features(struct kvm_vcpu *vcpu)
 	return result;
 }
 
+static struct ia64_pal_retval pal_register_info(struct kvm_vcpu *vcpu)
+{
+
+	struct ia64_pal_retval result = {0, 0, 0, 0};
+	long in0, in1, in2, in3;
+
+	kvm_get_pal_call_data(vcpu, &in0, &in1, &in2, &in3);
+	result.status = ia64_pal_register_info(in1, &result.v1, &result.v2);
+
+	return result;
+}
+
 static struct ia64_pal_retval pal_cache_info(struct kvm_vcpu *vcpu)
 {
 
@@ -268,8 +280,12 @@ static struct ia64_pal_retval pal_vm_summary(struct kvm_vcpu *vcpu)
 static struct ia64_pal_retval pal_vm_info(struct kvm_vcpu *vcpu)
 {
 	struct ia64_pal_retval result;
+	unsigned long in0, in1, in2, in3;
 
-	INIT_PAL_STATUS_UNIMPLEMENTED(result);
+	kvm_get_pal_call_data(vcpu, &in0, &in1, &in2, &in3);
+
+	result.status = ia64_pal_vm_info(in1, in2,
+			(pal_tc_info_u_t *)&result.v1, &result.v2);
 
 	return result;
 }
@@ -292,6 +308,108 @@ static void prepare_for_halt(struct kvm_vcpu *vcpu)
 	vcpu->arch.timer_fired = 0;
 }
 
+static struct ia64_pal_retval pal_perf_mon_info(struct kvm_vcpu *vcpu)
+{
+	long status;
+	unsigned long in0, in1, in2, in3, r9;
+	unsigned long pm_buffer[16];
+
+	kvm_get_pal_call_data(vcpu, &in0, &in1, &in2, &in3);
+	status = ia64_pal_perf_mon_info(pm_buffer,
+				(pal_perf_mon_info_u_t *) &r9);
+	if (status != 0) {
+		printk(KERN_DEBUG"PAL_PERF_MON_INFO fails ret=%ld\n", status);
+	} else {
+		if (in1)
+			memcpy((void *)in1, pm_buffer, sizeof(pm_buffer));
+		else {
+			status = PAL_STATUS_EINVAL;
+			printk(KERN_WARNING"Invalid parameters "
+						"for PAL call:0x%lx!\n", in0);
+		}
+	}
+	return (struct ia64_pal_retval){status, r9, 0, 0};
+}
+
+static struct ia64_pal_retval pal_halt_info(struct kvm_vcpu *vcpu)
+{
+	unsigned long in0, in1, in2, in3;
+	long status;
+	unsigned long res = 1000UL | (1000UL << 16) | (10UL << 32)
+					| (1UL << 61) | (1UL << 60);
+
+	kvm_get_pal_call_data(vcpu, &in0, &in1, &in2, &in3);
+	if (in1) {
+		memcpy((void *)in1, &res, sizeof(res));
+		status = 0;
+	} else{
+		status = PAL_STATUS_EINVAL;
+		printk(KERN_WARNING"Invalid parameters "
+					"for PAL call:0x%lx!\n", in0);
+	}
+
+	return (struct ia64_pal_retval){status, 0, 0, 0};
+}
+
+static struct ia64_pal_retval pal_mem_attrib(struct kvm_vcpu *vcpu)
+{
+	unsigned long r9;
+	long status;
+
+	status = ia64_pal_mem_attrib(&r9);
+
+	return (struct ia64_pal_retval){status, r9, 0, 0};
+}
+
+static void remote_pal_prefetch_visibility(void *v)
+{
+	s64 trans_type = (s64)v;
+	ia64_pal_prefetch_visibility(trans_type);
+}
+
+static struct ia64_pal_retval pal_prefetch_visibility(struct kvm_vcpu *vcpu)
+{
+	struct ia64_pal_retval result = {0, 0, 0, 0};
+	unsigned long in0, in1, in2, in3;
+	kvm_get_pal_call_data(vcpu, &in0, &in1, &in2, &in3);
+	result.status = ia64_pal_prefetch_visibility(in1);
+	if (result.status == 0) {
+		/* Must be performed on all remote processors
+		in the coherence domain. */
+		smp_call_function(remote_pal_prefetch_visibility,
+					(void *)in1, 1);
+		/* Unnecessary on remote processor for other vcpus!*/
+		result.status = 1;
+	}
+	return result;
+}
+
+static void remote_pal_mc_drain(void *v)
+{
+	ia64_pal_mc_drain();
+}
+
+static struct ia64_pal_retval pal_get_brand_info(struct kvm_vcpu *vcpu)
+{
+	struct ia64_pal_retval result = {0, 0, 0, 0};
+	unsigned long in0, in1, in2, in3;
+
+	kvm_get_pal_call_data(vcpu, &in0, &in1, &in2, &in3);
+
+	if (in1 == 0 && in2) {
+		char brand_info[128];
+		result.status = ia64_pal_get_brand_info(brand_info);
+		if (result.status == PAL_STATUS_SUCCESS)
+			memcpy((void *)in2, brand_info, 128);
+	} else {
+		result.status = PAL_STATUS_REQUIRES_MEMORY;
+		printk(KERN_WARNING"Invalid parameters for "
+					"PAL call:0x%lx!\n", in0);
+	}
+
+	return result;
+}
+
 int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 
@@ -300,14 +418,22 @@ int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	int ret = 1;
 
 	gr28 = kvm_get_pal_call_index(vcpu);
-	/*printk("pal_call index:%lx\n",gr28);*/
 	switch (gr28) {
 	case PAL_CACHE_FLUSH:
 		result = pal_cache_flush(vcpu);
 		break;
+	case PAL_MEM_ATTRIB:
+		result = pal_mem_attrib(vcpu);
+		break;
 	case PAL_CACHE_SUMMARY:
 		result = pal_cache_summary(vcpu);
 		break;
+	case PAL_PERF_MON_INFO:
+		result = pal_perf_mon_info(vcpu);
+		break;
+	case PAL_HALT_INFO:
+		result = pal_halt_info(vcpu);
+		break;
 	case PAL_HALT_LIGHT:
 	{
 		INIT_PAL_STATUS_SUCCESS(result);
@@ -317,6 +443,16 @@ int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 		break;
 
+	case PAL_PREFETCH_VISIBILITY:
+		result = pal_prefetch_visibility(vcpu);
+		break;
+	case PAL_MC_DRAIN:
+		result.status = ia64_pal_mc_drain();
+		/* FIXME: All vcpus likely call PAL_MC_DRAIN.
+		   That causes the congestion. */
+		smp_call_function(remote_pal_mc_drain, NULL, 1);
+		break;
+
 	case PAL_FREQ_RATIOS:
 		result = pal_freq_ratios(vcpu);
 		break;
@@ -346,6 +482,9 @@ int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		INIT_PAL_STATUS_SUCCESS(result);
 		result.v1 = (1L << 32) | 1L;
 		break;
+	case PAL_REGISTER_INFO:
+		result = pal_register_info(vcpu);
+		break;
 	case PAL_VM_PAGE_SIZE:
 		result.status = ia64_pal_vm_page_size(&result.v0,
 							&result.v1);
@@ -365,12 +504,18 @@ int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		result.status = ia64_pal_version(
 				(pal_version_u_t *)&result.v0,
 				(pal_version_u_t *)&result.v1);
-
 		break;
 	case PAL_FIXED_ADDR:
 		result.status = PAL_STATUS_SUCCESS;
 		result.v0 = vcpu->vcpu_id;
 		break;
+	case PAL_BRAND_INFO:
+		result = pal_get_brand_info(vcpu);
+		break;
+	case PAL_GET_PSTATE:
+	case PAL_CACHE_SHARED_INFO:
+		INIT_PAL_STATUS_UNIMPLEMENTED(result);
+		break;
 	default:
 		INIT_PAL_STATUS_UNIMPLEMENTED(result);
 		printk(KERN_WARNING"kvm: Unsupported pal call,"
diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index 0e727ce..b1dc809 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -607,7 +607,7 @@ static void set_pal_call_data(struct kvm_vcpu *vcpu)
 	p->exit_reason = EXIT_REASON_PAL_CALL;
 }
 
-static void set_pal_call_result(struct kvm_vcpu *vcpu)
+static void get_pal_call_result(struct kvm_vcpu *vcpu)
 {
 	struct exit_ctl_data *p = &vcpu->arch.exit_data;
 
@@ -635,7 +635,7 @@ static void set_sal_call_data(struct kvm_vcpu *vcpu)
 	p->exit_reason = EXIT_REASON_SAL_CALL;
 }
 
-static void set_sal_call_result(struct kvm_vcpu *vcpu)
+static void get_sal_call_result(struct kvm_vcpu *vcpu)
 {
 	struct exit_ctl_data *p = &vcpu->arch.exit_data;
 
@@ -658,13 +658,13 @@ void  kvm_ia64_handle_break(unsigned long ifa, struct kvm_pt_regs *regs,
 		if (iim == DOMN_PAL_REQUEST) {
 			set_pal_call_data(v);
 			vmm_transition(v);
-			set_pal_call_result(v);
+			get_pal_call_result(v);
 			vcpu_increment_iip(v);
 			return;
 		} else if (iim == DOMN_SAL_REQUEST) {
 			set_sal_call_data(v);
 			vmm_transition(v);
-			set_sal_call_result(v);
+			get_sal_call_result(v);
 			vcpu_increment_iip(v);
 			return;
 		}
-- 
1.6.0.6

