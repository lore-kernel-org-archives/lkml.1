Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXFOJnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXFOJnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXFOJnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:43:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:52510 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFOJnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:43:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fix for 2.6.22
Date: Fri, 15 Jun 2007 12:43:33 +0300
Message-Id: <11819006133865-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the repository and branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

to get a fix for a fairly critical bug which allows, under certain conditions,
guest fpu state to find its way into the host fpu.

Avi Kivity (1):
      KVM: Prevent guest fpu state from leaking into the host

 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   22 ++++++++++++++++++++++
 drivers/kvm/vmx.c      |   12 +++---------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1c040d8..152312c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -304,6 +304,7 @@ struct kvm_vcpu {
 	char *host_fx_image;
 	char *guest_fx_image;
 	int fpu_active;
+	int guest_fpu_loaded;
 
 	int mmio_needed;
 	int mmio_read_completed;
@@ -508,6 +509,8 @@ void fx_init(struct kvm_vcpu *vcpu);
 void load_msrs(struct vmx_msr_entry *e, int n);
 void save_msrs(struct vmx_msr_entry *e, int n);
 void kvm_resched(struct kvm_vcpu *vcpu);
+void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 
 int kvm_read_guest(struct kvm_vcpu *vcpu,
 	       gva_t addr,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index da985b3..8f1f07a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -253,6 +253,28 @@ int kvm_write_guest(struct kvm_vcpu *vcpu, gva_t addr, unsigned long size,
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
+void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->fpu_active || vcpu->guest_fpu_loaded)
+		return;
+
+	vcpu->guest_fpu_loaded = 1;
+	fx_save(vcpu->host_fx_image);
+	fx_restore(vcpu->guest_fx_image);
+}
+EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
+
+void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->guest_fpu_loaded)
+		return;
+
+	vcpu->guest_fpu_loaded = 0;
+	fx_save(vcpu->guest_fx_image);
+	fx_restore(vcpu->host_fx_image);
+}
+EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 184238e..c1ac106 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -280,6 +280,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_put_guest_fpu(vcpu);
 	put_cpu();
 }
 
@@ -1847,10 +1848,8 @@ again:
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
 
-	if (vcpu->fpu_active) {
-		fx_save(vcpu->host_fx_image);
-		fx_restore(vcpu->guest_fx_image);
-	}
+	kvm_load_guest_fpu(vcpu);
+
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
@@ -2012,11 +2011,6 @@ again:
 	}
 #endif
 
-	if (vcpu->fpu_active) {
-		fx_save(vcpu->guest_fx_image);
-		fx_restore(vcpu->host_fx_image);
-	}
-
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
