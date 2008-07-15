Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYGOMTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYGOMTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYGOMNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:13:07 -0400
Received: from il.qumranet.com ([212.179.150.194]:30356 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbYGOMMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 07/19] KVM: s390: rename private structures
Date: Tue, 15 Jul 2008 15:12:26 +0300
Message-Id: <1216123958-10717-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

While doing some tests with our lcrash implementation I have seen a
naming conflict with prefix_info in kvm_host.h vs. addrconf.h

To avoid future conflicts lets rename private definitions in
asm/kvm_host.h by adding the kvm_s390 prefix.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/interrupt.c   |   32 ++++++++++++++++----------------
 arch/s390/kvm/kvm-s390.c    |    3 ++-
 arch/s390/kvm/priv.c        |    2 +-
 arch/s390/kvm/sigp.c        |   20 ++++++++++----------
 include/asm-s390/kvm_host.h |   36 ++++++++++++++++++------------------
 5 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 84a7fed..11230b0 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -31,7 +31,7 @@ static int psw_interrupts_disabled(struct kvm_vcpu *vcpu)
 }
 
 static int __interrupt_is_deliverable(struct kvm_vcpu *vcpu,
-				      struct interrupt_info *inti)
+				      struct kvm_s390_interrupt_info *inti)
 {
 	switch (inti->type) {
 	case KVM_S390_INT_EMERGENCY:
@@ -91,7 +91,7 @@ static void __set_cpuflag(struct kvm_vcpu *vcpu, u32 flag)
 }
 
 static void __set_intercept_indicator(struct kvm_vcpu *vcpu,
-				      struct interrupt_info *inti)
+				      struct kvm_s390_interrupt_info *inti)
 {
 	switch (inti->type) {
 	case KVM_S390_INT_EMERGENCY:
@@ -111,7 +111,7 @@ static void __set_intercept_indicator(struct kvm_vcpu *vcpu,
 }
 
 static void __do_deliver_interrupt(struct kvm_vcpu *vcpu,
-				   struct interrupt_info *inti)
+				   struct kvm_s390_interrupt_info *inti)
 {
 	const unsigned short table[] = { 2, 4, 4, 6 };
 	int rc, exception = 0;
@@ -290,9 +290,9 @@ static int __try_deliver_ckc_interrupt(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 {
-	struct local_interrupt *li = &vcpu->arch.local_int;
-	struct float_interrupt *fi = vcpu->arch.local_int.float_int;
-	struct interrupt_info  *inti;
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+	struct kvm_s390_float_interrupt *fi = vcpu->arch.local_int.float_int;
+	struct kvm_s390_interrupt_info  *inti;
 	int rc = 0;
 
 	if (atomic_read(&li->active)) {
@@ -408,9 +408,9 @@ void kvm_s390_idle_wakeup(unsigned long data)
 
 void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 {
-	struct local_interrupt *li = &vcpu->arch.local_int;
-	struct float_interrupt *fi = vcpu->arch.local_int.float_int;
-	struct interrupt_info  *n, *inti = NULL;
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+	struct kvm_s390_float_interrupt *fi = vcpu->arch.local_int.float_int;
+	struct kvm_s390_interrupt_info  *n, *inti = NULL;
 	int deliver;
 
 	__reset_intercept_indicators(vcpu);
@@ -465,8 +465,8 @@ void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 
 int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code)
 {
-	struct local_interrupt *li = &vcpu->arch.local_int;
-	struct interrupt_info *inti;
+	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+	struct kvm_s390_interrupt_info *inti;
 
 	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
 	if (!inti)
@@ -487,9 +487,9 @@ int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code)
 int kvm_s390_inject_vm(struct kvm *kvm,
 		       struct kvm_s390_interrupt *s390int)
 {
-	struct local_interrupt *li;
-	struct float_interrupt *fi;
-	struct interrupt_info *inti;
+	struct kvm_s390_local_interrupt *li;
+	struct kvm_s390_float_interrupt *fi;
+	struct kvm_s390_interrupt_info *inti;
 	int sigcpu;
 
 	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
@@ -544,8 +544,8 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 			 struct kvm_s390_interrupt *s390int)
 {
-	struct local_interrupt *li;
-	struct interrupt_info *inti;
+	struct kvm_s390_local_interrupt *li;
+	struct kvm_s390_interrupt_info *inti;
 
 	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
 	if (!inti)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cdab57c..399acf3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -275,7 +275,8 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (!vcpu)
 		goto out_nomem;
 
-	vcpu->arch.sie_block = (struct sie_block *) get_zeroed_page(GFP_KERNEL);
+	vcpu->arch.sie_block = (struct kvm_s390_sie_block *)
+					get_zeroed_page(GFP_KERNEL);
 
 	if (!vcpu->arch.sie_block)
 		goto out_free_cpu;
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index c02286c..2e2d2ff 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -199,7 +199,7 @@ out:
 
 static void handle_stsi_3_2_2(struct kvm_vcpu *vcpu, struct sysinfo_3_2_2 *mem)
 {
-	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
 	int cpus = 0;
 	int n;
 
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 0a236ac..5a55611 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -45,7 +45,7 @@
 
 static int __sigp_sense(struct kvm_vcpu *vcpu, u16 cpu_addr, u64 *reg)
 {
-	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
 	int rc;
 
 	if (cpu_addr >= KVM_MAX_VCPUS)
@@ -71,9 +71,9 @@ static int __sigp_sense(struct kvm_vcpu *vcpu, u16 cpu_addr, u64 *reg)
 
 static int __sigp_emergency(struct kvm_vcpu *vcpu, u16 cpu_addr)
 {
-	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
-	struct local_interrupt *li;
-	struct interrupt_info *inti;
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_local_interrupt *li;
+	struct kvm_s390_interrupt_info *inti;
 	int rc;
 
 	if (cpu_addr >= KVM_MAX_VCPUS)
@@ -108,9 +108,9 @@ unlock:
 
 static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int store)
 {
-	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
-	struct local_interrupt *li;
-	struct interrupt_info *inti;
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_local_interrupt *li;
+	struct kvm_s390_interrupt_info *inti;
 	int rc;
 
 	if (cpu_addr >= KVM_MAX_VCPUS)
@@ -169,9 +169,9 @@ static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter)
 static int __sigp_set_prefix(struct kvm_vcpu *vcpu, u16 cpu_addr, u32 address,
 			     u64 *reg)
 {
-	struct float_interrupt *fi = &vcpu->kvm->arch.float_int;
-	struct local_interrupt *li;
-	struct interrupt_info *inti;
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+	struct kvm_s390_local_interrupt *li;
+	struct kvm_s390_interrupt_info *inti;
 	int rc;
 	u8 tmp;
 
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
index 18cbd8a..3234dd5 100644
--- a/include/asm-s390/kvm_host.h
+++ b/include/asm-s390/kvm_host.h
@@ -62,7 +62,7 @@ struct sca_block {
 #define CPUSTAT_J          0x00000002
 #define CPUSTAT_P          0x00000001
 
-struct sie_block {
+struct kvm_s390_sie_block {
 	atomic_t cpuflags;		/* 0x0000 */
 	__u32	prefix;			/* 0x0004 */
 	__u8	reserved8[32];		/* 0x0008 */
@@ -140,14 +140,14 @@ struct kvm_vcpu_stat {
 	u32 diagnose_44;
 };
 
-struct io_info {
+struct kvm_s390_io_info {
 	__u16        subchannel_id;            /* 0x0b8 */
 	__u16        subchannel_nr;            /* 0x0ba */
 	__u32        io_int_parm;              /* 0x0bc */
 	__u32        io_int_word;              /* 0x0c0 */
 };
 
-struct ext_info {
+struct kvm_s390_ext_info {
 	__u32 ext_params;
 	__u64 ext_params2;
 };
@@ -160,22 +160,22 @@ struct ext_info {
 #define PGM_SPECIFICATION        0x06
 #define PGM_DATA                 0x07
 
-struct pgm_info {
+struct kvm_s390_pgm_info {
 	__u16 code;
 };
 
-struct prefix_info {
+struct kvm_s390_prefix_info {
 	__u32 address;
 };
 
-struct interrupt_info {
+struct kvm_s390_interrupt_info {
 	struct list_head list;
 	u64	type;
 	union {
-		struct io_info io;
-		struct ext_info ext;
-		struct pgm_info pgm;
-		struct prefix_info prefix;
+		struct kvm_s390_io_info io;
+		struct kvm_s390_ext_info ext;
+		struct kvm_s390_pgm_info pgm;
+		struct kvm_s390_prefix_info prefix;
 	};
 };
 
@@ -183,35 +183,35 @@ struct interrupt_info {
 #define ACTION_STORE_ON_STOP 1
 #define ACTION_STOP_ON_STOP  2
 
-struct local_interrupt {
+struct kvm_s390_local_interrupt {
 	spinlock_t lock;
 	struct list_head list;
 	atomic_t active;
-	struct float_interrupt *float_int;
+	struct kvm_s390_float_interrupt *float_int;
 	int timer_due; /* event indicator for waitqueue below */
 	wait_queue_head_t wq;
 	atomic_t *cpuflags;
 	unsigned int action_bits;
 };
 
-struct float_interrupt {
+struct kvm_s390_float_interrupt {
 	spinlock_t lock;
 	struct list_head list;
 	atomic_t active;
 	int next_rr_cpu;
 	unsigned long idle_mask [(64 + sizeof(long) - 1) / sizeof(long)];
-	struct local_interrupt *local_int[64];
+	struct kvm_s390_local_interrupt *local_int[64];
 };
 
 
 struct kvm_vcpu_arch {
-	struct sie_block *sie_block;
+	struct kvm_s390_sie_block *sie_block;
 	unsigned long	  guest_gprs[16];
 	s390_fp_regs      host_fpregs;
 	unsigned int      host_acrs[NUM_ACRS];
 	s390_fp_regs      guest_fpregs;
 	unsigned int      guest_acrs[NUM_ACRS];
-	struct local_interrupt local_int;
+	struct kvm_s390_local_interrupt local_int;
 	struct timer_list ckc_timer;
 	union  {
 		cpuid_t	  cpu_id;
@@ -228,8 +228,8 @@ struct kvm_arch{
 	unsigned long guest_memsize;
 	struct sca_block *sca;
 	debug_info_t *dbf;
-	struct float_interrupt float_int;
+	struct kvm_s390_float_interrupt float_int;
 };
 
-extern int sie64a(struct sie_block *, __u64 *);
+extern int sie64a(struct kvm_s390_sie_block *, __u64 *);
 #endif
-- 
1.5.6.1

