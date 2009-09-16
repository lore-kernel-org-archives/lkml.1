Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZIPWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZIPWk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760345AbZIPWkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:51 -0400
Received: from kroah.org ([198.145.64.141]:55380 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbZIPWkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:18 2009
Message-Id: <20090916223718.283870494@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 34/45] KVM: VMX: Check cpl before emulating debug register access
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-check-cpl-before-emulating-debug-register-access.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

commit 0a79b009525b160081d75cef5dbf45817956acf2 upstream.

Debug registers may only be accessed from cpl 0.  Unfortunately, vmx will
code to emulate the instruction even though it was issued from guest
userspace, possibly leading to an unexpected trap later.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |    2 ++
 arch/x86/kvm/x86.c              |   13 +++++++++++++
 3 files changed, 16 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -618,6 +618,7 @@ void kvm_queue_exception(struct kvm_vcpu
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
+bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2841,6 +2841,8 @@ static int handle_dr(struct kvm_vcpu *vc
 	unsigned long val;
 	int dr, reg;
 
+	if (!kvm_require_cpl(vcpu, 0))
+		return 1;
 	dr = vmcs_readl(GUEST_DR7);
 	if (dr & DR7_GD) {
 		/*
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -215,6 +215,19 @@ static void __queue_exception(struct kvm
 }
 
 /*
+ * Checks if cpl <= required_cpl; if true, return true.  Otherwise queue
+ * a #GP and return false.
+ */
+bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
+{
+	if (kvm_x86_ops->get_cpl(vcpu) <= required_cpl)
+		return true;
+	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+	return false;
+}
+EXPORT_SYMBOL_GPL(kvm_require_cpl);
+
+/*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)


