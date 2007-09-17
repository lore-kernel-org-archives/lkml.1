Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbXIQIkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbXIQIkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXIQIcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:45250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 038/104] KVM: Use alignment properties of vcpu to simplify FPU ops
Date: Mon, 17 Sep 2007 10:31:20 +0200
Message-Id: <11900179471354-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Now we use a kmem cache for allocating vcpus, we can get the 16-byte
alignment required by fxsave & fxrstor instructions, and avoid
manually aligning the buffer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   13 ++++---------
 drivers/kvm/kvm_main.c |   45 +++++++++++++++++----------------------------
 drivers/kvm/svm.c      |    8 ++++----
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index b362e8f..7a34706 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -45,10 +45,6 @@
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 40
 
-#define FX_IMAGE_SIZE 512
-#define FX_IMAGE_ALIGN 16
-#define FX_BUF_SIZE (2 * FX_IMAGE_SIZE + FX_IMAGE_ALIGN)
-
 #define DE_VECTOR 0
 #define NM_VECTOR 7
 #define DF_VECTOR 8
@@ -342,9 +338,8 @@ struct kvm_vcpu {
 
 	struct kvm_guest_debug guest_debug;
 
-	char fx_buf[FX_BUF_SIZE];
-	char *host_fx_image;
-	char *guest_fx_image;
+	struct i387_fxsave_struct host_fx_image;
+	struct i387_fxsave_struct guest_fx_image;
 	int fpu_active;
 	int guest_fpu_loaded;
 
@@ -704,12 +699,12 @@ static inline unsigned long read_msr(unsigned long msr)
 }
 #endif
 
-static inline void fx_save(void *image)
+static inline void fx_save(struct i387_fxsave_struct *image)
 {
 	asm ("fxsave (%0)":: "r" (image));
 }
 
-static inline void fx_restore(void *image)
+static inline void fx_restore(struct i387_fxsave_struct *image)
 {
 	asm ("fxrstor (%0)":: "r" (image));
 }
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4166a08..bfb1b6d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -154,8 +154,8 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 1;
-	fx_save(vcpu->host_fx_image);
-	fx_restore(vcpu->guest_fx_image);
+	fx_save(&vcpu->host_fx_image);
+	fx_restore(&vcpu->guest_fx_image);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
 
@@ -165,8 +165,8 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	fx_save(vcpu->guest_fx_image);
-	fx_restore(vcpu->host_fx_image);
+	fx_save(&vcpu->guest_fx_image);
+	fx_restore(&vcpu->host_fx_image);
 }
 EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
 
@@ -262,10 +262,6 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	}
 	vcpu->pio_data = page_address(page);
 
-	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
-					   FX_IMAGE_ALIGN);
-	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
-
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
 		goto fail_free_pio_data;
@@ -615,30 +611,20 @@ EXPORT_SYMBOL_GPL(set_cr8);
 
 void fx_init(struct kvm_vcpu *vcpu)
 {
-	struct __attribute__ ((__packed__)) fx_image_s {
-		u16 control; //fcw
-		u16 status; //fsw
-		u16 tag; // ftw
-		u16 opcode; //fop
-		u64 ip; // fpu ip
-		u64 operand;// fpu dp
-		u32 mxcsr;
-		u32 mxcsr_mask;
-
-	} *fx_image;
+	unsigned after_mxcsr_mask;
 
 	/* Initialize guest FPU by resetting ours and saving into guest's */
 	preempt_disable();
-	fx_save(vcpu->host_fx_image);
+	fx_save(&vcpu->host_fx_image);
 	fpu_init();
-	fx_save(vcpu->guest_fx_image);
-	fx_restore(vcpu->host_fx_image);
+	fx_save(&vcpu->guest_fx_image);
+	fx_restore(&vcpu->host_fx_image);
 	preempt_enable();
 
-	fx_image = (struct fx_image_s *)vcpu->guest_fx_image;
-	fx_image->mxcsr = 0x1f80;
-	memset(vcpu->guest_fx_image + sizeof(struct fx_image_s),
-	       0, FX_IMAGE_SIZE - sizeof(struct fx_image_s));
+	after_mxcsr_mask = offsetof(struct i387_fxsave_struct, st_space);
+	vcpu->guest_fx_image.mxcsr = 0x1f80;
+	memset((void *)&vcpu->guest_fx_image + after_mxcsr_mask,
+	       0, sizeof(struct i387_fxsave_struct) - after_mxcsr_mask);
 }
 EXPORT_SYMBOL_GPL(fx_init);
 
@@ -2356,6 +2342,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
+	/* We do fxsave: this must be aligned. */
+	BUG_ON((unsigned long)&vcpu->host_fx_image & 0xF);
+
 	vcpu_load(vcpu);
 	r = kvm_mmu_setup(vcpu);
 	vcpu_put(vcpu);
@@ -2468,7 +2457,7 @@ struct fxsave {
 
 static int kvm_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)vcpu->guest_fx_image;
+	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
 
 	vcpu_load(vcpu);
 
@@ -2488,7 +2477,7 @@ static int kvm_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 static int kvm_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)vcpu->guest_fx_image;
+	struct fxsave *fxsave = (struct fxsave *)&vcpu->guest_fx_image;
 
 	vcpu_load(vcpu);
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 8193651..5277084 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1557,8 +1557,8 @@ again:
 	}
 
 	if (vcpu->fpu_active) {
-		fx_save(vcpu->host_fx_image);
-		fx_restore(vcpu->guest_fx_image);
+		fx_save(&vcpu->host_fx_image);
+		fx_restore(&vcpu->guest_fx_image);
 	}
 
 	asm volatile (
@@ -1670,8 +1670,8 @@ again:
 	vcpu->guest_mode = 0;
 
 	if (vcpu->fpu_active) {
-		fx_save(vcpu->guest_fx_image);
-		fx_restore(vcpu->host_fx_image);
+		fx_save(&vcpu->guest_fx_image);
+		fx_restore(&vcpu->host_fx_image);
 	}
 
 	if ((svm->vmcb->save.dr7 & 0xff))
-- 
1.5.3

