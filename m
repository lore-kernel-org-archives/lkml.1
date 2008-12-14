Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYLNISl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYLNISl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYLNIIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59943 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYLNIHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:19 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 24/36] KVM: ppc: mostly cosmetic updates to the exit timing accounting code
Date: Sun, 14 Dec 2008 10:06:57 +0200
Message-Id: <1229242029-13410-25-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

The only significant changes were to kvmppc_exit_timing_write() and
kvmppc_exit_timing_show(), both of which were dramatically simplified.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |    8 +--
 arch/powerpc/kvm/44x_emulate.c      |    4 +-
 arch/powerpc/kvm/booke.c            |   30 +++++-----
 arch/powerpc/kvm/timing.c           |  109 ++++++++++++++---------------------
 arch/powerpc/kvm/timing.h           |    6 +-
 5 files changed, 66 insertions(+), 91 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 2f5b49f..c1e436f 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -102,9 +102,8 @@ enum kvm_exit_types {
 	__NUMBER_OF_KVM_EXIT_TYPES
 };
 
-#ifdef CONFIG_KVM_EXIT_TIMING
 /* allow access to big endian 32bit upper/lower parts and 64bit var */
-struct exit_timing {
+struct kvmppc_exit_timing {
 	union {
 		u64 tv64;
 		struct {
@@ -112,7 +111,6 @@ struct exit_timing {
 		} tv32;
 	};
 };
-#endif
 
 struct kvm_arch {
 };
@@ -174,8 +172,8 @@ struct kvm_vcpu_arch {
 	u32 dbcr1;
 
 #ifdef CONFIG_KVM_EXIT_TIMING
-	struct exit_timing timing_exit;
-	struct exit_timing timing_last_enter;
+	struct kvmppc_exit_timing timing_exit;
+	struct kvmppc_exit_timing timing_last_enter;
 	u32 last_exit_type;
 	u32 timing_count_type[__NUMBER_OF_KVM_EXIT_TYPES];
 	u64 timing_sum_duration[__NUMBER_OF_KVM_EXIT_TYPES];
diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index 69f88d5..82489a7 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -132,7 +132,7 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 				run->dcr.is_write = 0;
 				vcpu->arch.io_gpr = rt;
 				vcpu->arch.dcr_needed = 1;
-				account_exit(vcpu, DCR_EXITS);
+				kvmppc_account_exit(vcpu, DCR_EXITS);
 				emulated = EMULATE_DO_DCR;
 			}
 
@@ -152,7 +152,7 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 				run->dcr.data = vcpu->arch.gpr[rs];
 				run->dcr.is_write = 1;
 				vcpu->arch.dcr_needed = 1;
-				account_exit(vcpu, DCR_EXITS);
+				kvmppc_account_exit(vcpu, DCR_EXITS);
 				emulated = EMULATE_DO_DCR;
 			}
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 0f17124..35485dd 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -202,7 +202,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 
 	case BOOKE_INTERRUPT_EXTERNAL:
-		account_exit(vcpu, EXT_INTR_EXITS);
+		kvmppc_account_exit(vcpu, EXT_INTR_EXITS);
 		if (need_resched())
 			cond_resched();
 		r = RESUME_GUEST;
@@ -212,7 +212,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		/* Since we switched IVPR back to the host's value, the host
 		 * handled this interrupt the moment we enabled interrupts.
 		 * Now we just offer it a chance to reschedule the guest. */
-		account_exit(vcpu, DEC_EXITS);
+		kvmppc_account_exit(vcpu, DEC_EXITS);
 		if (need_resched())
 			cond_resched();
 		r = RESUME_GUEST;
@@ -225,7 +225,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			vcpu->arch.esr = vcpu->arch.fault_esr;
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_PROGRAM);
 			r = RESUME_GUEST;
-			account_exit(vcpu, USR_PR_INST);
+			kvmppc_account_exit(vcpu, USR_PR_INST);
 			break;
 		}
 
@@ -233,7 +233,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		switch (er) {
 		case EMULATE_DONE:
 			/* don't overwrite subtypes, just account kvm_stats */
-			account_exit_stat(vcpu, EMULATED_INST_EXITS);
+			kvmppc_account_exit_stat(vcpu, EMULATED_INST_EXITS);
 			/* Future optimization: only reload non-volatiles if
 			 * they were actually modified by emulation. */
 			r = RESUME_GUEST_NV;
@@ -259,7 +259,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	case BOOKE_INTERRUPT_FP_UNAVAIL:
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_FP_UNAVAIL);
-		account_exit(vcpu, FP_UNAVAIL);
+		kvmppc_account_exit(vcpu, FP_UNAVAIL);
 		r = RESUME_GUEST;
 		break;
 
@@ -267,20 +267,20 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		vcpu->arch.dear = vcpu->arch.fault_dear;
 		vcpu->arch.esr = vcpu->arch.fault_esr;
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DATA_STORAGE);
-		account_exit(vcpu, DSI_EXITS);
+		kvmppc_account_exit(vcpu, DSI_EXITS);
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_INST_STORAGE:
 		vcpu->arch.esr = vcpu->arch.fault_esr;
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_INST_STORAGE);
-		account_exit(vcpu, ISI_EXITS);
+		kvmppc_account_exit(vcpu, ISI_EXITS);
 		r = RESUME_GUEST;
 		break;
 
 	case BOOKE_INTERRUPT_SYSCALL:
 		kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_SYSCALL);
-		account_exit(vcpu, SYSCALL_EXITS);
+		kvmppc_account_exit(vcpu, SYSCALL_EXITS);
 		r = RESUME_GUEST;
 		break;
 
@@ -299,7 +299,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DTLB_MISS);
 			vcpu->arch.dear = vcpu->arch.fault_dear;
 			vcpu->arch.esr = vcpu->arch.fault_esr;
-			account_exit(vcpu, DTLB_REAL_MISS_EXITS);
+			kvmppc_account_exit(vcpu, DTLB_REAL_MISS_EXITS);
 			r = RESUME_GUEST;
 			break;
 		}
@@ -317,13 +317,13 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * invoking the guest. */
 			kvmppc_mmu_map(vcpu, eaddr, vcpu->arch.paddr_accessed, gtlbe->tid,
 			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
-			account_exit(vcpu, DTLB_VIRT_MISS_EXITS);
+			kvmppc_account_exit(vcpu, DTLB_VIRT_MISS_EXITS);
 			r = RESUME_GUEST;
 		} else {
 			/* Guest has mapped and accessed a page which is not
 			 * actually RAM. */
 			r = kvmppc_emulate_mmio(run, vcpu);
-			account_exit(vcpu, MMIO_EXITS);
+			kvmppc_account_exit(vcpu, MMIO_EXITS);
 		}
 
 		break;
@@ -345,11 +345,11 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_ITLB_MISS);
-			account_exit(vcpu, ITLB_REAL_MISS_EXITS);
+			kvmppc_account_exit(vcpu, ITLB_REAL_MISS_EXITS);
 			break;
 		}
 
-		account_exit(vcpu, ITLB_VIRT_MISS_EXITS);
+		kvmppc_account_exit(vcpu, ITLB_VIRT_MISS_EXITS);
 
 		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
 		gpaddr = tlb_xlate(gtlbe, eaddr);
@@ -383,7 +383,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		mtspr(SPRN_DBSR, dbsr);
 
 		run->exit_reason = KVM_EXIT_DEBUG;
-		account_exit(vcpu, DEBUG_EXITS);
+		kvmppc_account_exit(vcpu, DEBUG_EXITS);
 		r = RESUME_HOST;
 		break;
 	}
@@ -404,7 +404,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		if (signal_pending(current)) {
 			run->exit_reason = KVM_EXIT_INTR;
 			r = (-EINTR << 2) | RESUME_HOST | (r & RESUME_FLAG_NV);
-			account_exit(vcpu, SIGNAL_EXITS);
+			kvmppc_account_exit(vcpu, SIGNAL_EXITS);
 		}
 	}
 
diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
index f42d272..47ee603 100644
--- a/arch/powerpc/kvm/timing.c
+++ b/arch/powerpc/kvm/timing.c
@@ -12,7 +12,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  *
- * Copyright IBM Corp. 2007
+ * Copyright IBM Corp. 2008
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
  *          Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
@@ -24,10 +24,11 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 
-#include "timing.h"
 #include <asm/time.h>
 #include <asm-generic/div64.h>
 
+#include "timing.h"
+
 void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -52,8 +53,7 @@ void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static void add_exit_timing(struct kvm_vcpu *vcpu,
-					u64 duration, int type)
+static void add_exit_timing(struct kvm_vcpu *vcpu, u64 duration, int type)
 {
 	u64 old;
 
@@ -115,54 +115,46 @@ void kvmppc_update_timing_stats(struct kvm_vcpu *vcpu)
 }
 
 static const char *kvm_exit_names[__NUMBER_OF_KVM_EXIT_TYPES] = {
-	[MMIO_EXITS] = 			"MMIO",
-	[DCR_EXITS] =			"DCR",
-	[SIGNAL_EXITS] =		"SIGNAL",
-	[ITLB_REAL_MISS_EXITS] =	"ITLBREAL",
-	[ITLB_VIRT_MISS_EXITS] =	"ITLBVIRT",
-	[DTLB_REAL_MISS_EXITS] =	"DTLBREAL",
-	[DTLB_VIRT_MISS_EXITS] =	"DTLBVIRT",
-	[SYSCALL_EXITS] =		"SYSCALL",
-	[ISI_EXITS] =			"ISI",
-	[DSI_EXITS] =			"DSI",
-	[EMULATED_INST_EXITS] =		"EMULINST",
-	[EMULATED_MTMSRWE_EXITS] =	"EMUL_WAIT",
-	[EMULATED_WRTEE_EXITS] =	"EMUL_WRTEE",
-	[EMULATED_MTSPR_EXITS] =	"EMUL_MTSPR",
-	[EMULATED_MFSPR_EXITS] =	"EMUL_MFSPR",
-	[EMULATED_MTMSR_EXITS] =	"EMUL_MTMSR",
-	[EMULATED_MFMSR_EXITS] =	"EMUL_MFMSR",
-	[EMULATED_TLBSX_EXITS] =	"EMUL_TLBSX",
-	[EMULATED_TLBWE_EXITS] =	"EMUL_TLBWE",
-	[EMULATED_RFI_EXITS] =		"EMUL_RFI",
-	[DEC_EXITS] =			"DEC",
-	[EXT_INTR_EXITS] =		"EXTINT",
-	[HALT_WAKEUP] =			"HALT",
-	[USR_PR_INST] =			"USR_PR_INST",
-	[FP_UNAVAIL] =			"FP_UNAVAIL",
-	[DEBUG_EXITS] =			"DEBUG",
-	[TIMEINGUEST] =			"TIMEINGUEST"
+	[MMIO_EXITS] =              "MMIO",
+	[DCR_EXITS] =               "DCR",
+	[SIGNAL_EXITS] =            "SIGNAL",
+	[ITLB_REAL_MISS_EXITS] =    "ITLBREAL",
+	[ITLB_VIRT_MISS_EXITS] =    "ITLBVIRT",
+	[DTLB_REAL_MISS_EXITS] =    "DTLBREAL",
+	[DTLB_VIRT_MISS_EXITS] =    "DTLBVIRT",
+	[SYSCALL_EXITS] =           "SYSCALL",
+	[ISI_EXITS] =               "ISI",
+	[DSI_EXITS] =               "DSI",
+	[EMULATED_INST_EXITS] =     "EMULINST",
+	[EMULATED_MTMSRWE_EXITS] =  "EMUL_WAIT",
+	[EMULATED_WRTEE_EXITS] =    "EMUL_WRTEE",
+	[EMULATED_MTSPR_EXITS] =    "EMUL_MTSPR",
+	[EMULATED_MFSPR_EXITS] =    "EMUL_MFSPR",
+	[EMULATED_MTMSR_EXITS] =    "EMUL_MTMSR",
+	[EMULATED_MFMSR_EXITS] =    "EMUL_MFMSR",
+	[EMULATED_TLBSX_EXITS] =    "EMUL_TLBSX",
+	[EMULATED_TLBWE_EXITS] =    "EMUL_TLBWE",
+	[EMULATED_RFI_EXITS] =      "EMUL_RFI",
+	[DEC_EXITS] =               "DEC",
+	[EXT_INTR_EXITS] =          "EXTINT",
+	[HALT_WAKEUP] =             "HALT",
+	[USR_PR_INST] =             "USR_PR_INST",
+	[FP_UNAVAIL] =              "FP_UNAVAIL",
+	[DEBUG_EXITS] =             "DEBUG",
+	[TIMEINGUEST] =             "TIMEINGUEST"
 };
 
 static int kvmppc_exit_timing_show(struct seq_file *m, void *private)
 {
 	struct kvm_vcpu *vcpu = m->private;
 	int i;
-	u64 min, max;
+
+	seq_printf(m, "%s", "type	count	min	max	sum	sum_squared\n");
 
 	for (i = 0; i < __NUMBER_OF_KVM_EXIT_TYPES; i++) {
-		if (vcpu->arch.timing_min_duration[i] == 0xFFFFFFFF)
-			min = 0;
-		else
-			min = vcpu->arch.timing_min_duration[i];
-		if (vcpu->arch.timing_max_duration[i] == 0)
-			max = 0;
-		else
-			max = vcpu->arch.timing_max_duration[i];
-
-		seq_printf(m, "%12s: count %10d min %10lld "
-			"max %10lld sum %20lld sum_quad %20lld\n",
-			kvm_exit_names[i], vcpu->arch.timing_count_type[i],
+		seq_printf(m, "%12s	%10d	%10lld	%10lld	%20lld	%20lld\n",
+			kvm_exit_names[i],
+			vcpu->arch.timing_count_type[i],
 			vcpu->arch.timing_min_duration[i],
 			vcpu->arch.timing_max_duration[i],
 			vcpu->arch.timing_sum_duration[i],
@@ -171,31 +163,19 @@ static int kvmppc_exit_timing_show(struct seq_file *m, void *private)
 	return 0;
 }
 
+/* Write 'c' to clear the timing statistics. */
 static ssize_t kvmppc_exit_timing_write(struct file *file,
 				       const char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
-	size_t len;
-	int err;
-	const char __user *p;
+	int err = -EINVAL;
 	char c;
 
-	len = 0;
-	p = user_buf;
-	while (len < count) {
-		if (get_user(c, p++))
-			err = -EFAULT;
-		if (c == 0 || c == '\n')
-			break;
-		len++;
-	}
-
-	if (len > 1) {
-		err = -EINVAL;
+	if (count > 1) {
 		goto done;
 	}
 
-	if (copy_from_user(&c, user_buf, sizeof(c))) {
+	if (get_user(c, user_buf)) {
 		err = -EFAULT;
 		goto done;
 	}
@@ -203,16 +183,13 @@ static ssize_t kvmppc_exit_timing_write(struct file *file,
 	if (c == 'c') {
 		struct seq_file *seqf = (struct seq_file *)file->private_data;
 		struct kvm_vcpu *vcpu = seqf->private;
-		/* write does not affect out buffers previsously generated with
-		 * show. Seq file is locked here to prevent races of init with
+		/* Write does not affect our buffers previously generated with
+		 * show. seq_file is locked here to prevent races of init with
 		 * a show call */
 		mutex_lock(&seqf->lock);
 		kvmppc_init_timing_stats(vcpu);
 		mutex_unlock(&seqf->lock);
 		err = count;
-	} else {
-		err = -EINVAL;
-		goto done;
 	}
 
 done:
@@ -238,7 +215,7 @@ void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
 	static char dbg_fname[50];
 	struct dentry *debugfs_file;
 
-	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%03u_timing",
+	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
 		 current->pid, id);
 	debugfs_file = debugfs_create_file(dbg_fname, 0666,
 					kvm_debugfs_dir, vcpu,
diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index 1af7181..bb13b1f 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -45,7 +45,7 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
 #endif /* CONFIG_KVM_EXIT_TIMING */
 
 /* account the exit in kvm_stats */
-static inline void account_exit_stat(struct kvm_vcpu *vcpu, int type)
+static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 {
 	/* type has to be known at build time for optimization */
 	BUILD_BUG_ON(__builtin_constant_p(type));
@@ -93,10 +93,10 @@ static inline void account_exit_stat(struct kvm_vcpu *vcpu, int type)
 }
 
 /* wrapper to set exit time and account for it in kvm_stats */
-static inline void account_exit(struct kvm_vcpu *vcpu, int type)
+static inline void kvmppc_account_exit(struct kvm_vcpu *vcpu, int type)
 {
 	kvmppc_set_exit_type(vcpu, type);
-	account_exit_stat(vcpu, type);
+	kvmppc_account_exit_stat(vcpu, type);
 }
 
 #endif /* __POWERPC_KVM_EXITTIMING_H__ */
-- 
1.6.0.3

