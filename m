Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0BJR37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:29:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/40] KVM: Extended shared_msr_global to per CPU
Date: Wed, 10 Feb 2010 19:22:40 +0200
Message-Id: <1265822589-11155-12-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

shared_msr_global saved host value of relevant MSRs, but it have an
assumption that all MSRs it tracked shared the value across the different
CPUs. It's not true with some MSRs, e.g. MSR_TSC_AUX.

Extend it to per CPU to provide the support of MSR_TSC_AUX, and more
alike MSRs.

Notice now the shared_msr_global still have one assumption: it can only deal
with the MSRs that won't change in host after KVM module loaded.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   55 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd67f88..a2c8cf2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -93,16 +93,16 @@ module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
 struct kvm_shared_msrs_global {
 	int nr;
-	struct kvm_shared_msr {
-		u32 msr;
-		u64 value;
-	} msrs[KVM_NR_SHARED_MSRS];
+	u32 msrs[KVM_NR_SHARED_MSRS];
 };
 
 struct kvm_shared_msrs {
 	struct user_return_notifier urn;
 	bool registered;
-	u64 current_value[KVM_NR_SHARED_MSRS];
+	struct kvm_shared_msr_values {
+		u64 host;
+		u64 curr;
+	} values[KVM_NR_SHARED_MSRS];
 };
 
 static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
@@ -147,53 +147,64 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 static void kvm_on_user_return(struct user_return_notifier *urn)
 {
 	unsigned slot;
-	struct kvm_shared_msr *global;
 	struct kvm_shared_msrs *locals
 		= container_of(urn, struct kvm_shared_msrs, urn);
+	struct kvm_shared_msr_values *values;
 
 	for (slot = 0; slot < shared_msrs_global.nr; ++slot) {
-		global = &shared_msrs_global.msrs[slot];
-		if (global->value != locals->current_value[slot]) {
-			wrmsrl(global->msr, global->value);
-			locals->current_value[slot] = global->value;
+		values = &locals->values[slot];
+		if (values->host != values->curr) {
+			wrmsrl(shared_msrs_global.msrs[slot], values->host);
+			values->curr = values->host;
 		}
 	}
 	locals->registered = false;
 	user_return_notifier_unregister(urn);
 }
 
-void kvm_define_shared_msr(unsigned slot, u32 msr)
+static void shared_msr_update(unsigned slot, u32 msr)
 {
-	int cpu;
+	struct kvm_shared_msrs *smsr;
 	u64 value;
 
+	smsr = &__get_cpu_var(shared_msrs);
+	/* only read, and nobody should modify it at this time,
+	 * so don't need lock */
+	if (slot >= shared_msrs_global.nr) {
+		printk(KERN_ERR "kvm: invalid MSR slot!");
+		return;
+	}
+	rdmsrl_safe(msr, &value);
+	smsr->values[slot].host = value;
+	smsr->values[slot].curr = value;
+}
+
+void kvm_define_shared_msr(unsigned slot, u32 msr)
+{
 	if (slot >= shared_msrs_global.nr)
 		shared_msrs_global.nr = slot + 1;
-	shared_msrs_global.msrs[slot].msr = msr;
-	rdmsrl_safe(msr, &value);
-	shared_msrs_global.msrs[slot].value = value;
-	for_each_online_cpu(cpu)
-		per_cpu(shared_msrs, cpu).current_value[slot] = value;
+	shared_msrs_global.msrs[slot] = msr;
+	/* we need ensured the shared_msr_global have been updated */
+	smp_wmb();
 }
 EXPORT_SYMBOL_GPL(kvm_define_shared_msr);
 
 static void kvm_shared_msr_cpu_online(void)
 {
 	unsigned i;
-	struct kvm_shared_msrs *locals = &__get_cpu_var(shared_msrs);
 
 	for (i = 0; i < shared_msrs_global.nr; ++i)
-		locals->current_value[i] = shared_msrs_global.msrs[i].value;
+		shared_msr_update(i, shared_msrs_global.msrs[i]);
 }
 
 void kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_shared_msrs *smsr = &__get_cpu_var(shared_msrs);
 
-	if (((value ^ smsr->current_value[slot]) & mask) == 0)
+	if (((value ^ smsr->values[slot].curr) & mask) == 0)
 		return;
-	smsr->current_value[slot] = value;
-	wrmsrl(shared_msrs_global.msrs[slot].msr, value);
+	smsr->values[slot].curr = value;
+	wrmsrl(shared_msrs_global.msrs[slot], value);
 	if (!smsr->registered) {
 		smsr->urn.on_user_return = kvm_on_user_return;
 		user_return_notifier_register(&smsr->urn);
-- 
1.6.5.3

