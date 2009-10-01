Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZJAXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZJAXm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZJAXmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:42:54 -0400
Received: from kroah.org ([198.145.64.141]:42032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbZJAXiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:20 2009
Message-Id: <20091001233320.245354779@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kiszka <jan.kiszka@siemens.com>, avi@redhat.com
Subject: [patch 10/30] KVM: x86: Disallow hypercalls for guest callers in rings > 0
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-disallow-hypercalls-for-guest-callers-in-rings-0.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Kiszka <jan.kiszka@siemens.com>

(cherry picked from commit 07708c4af1346ab1521b26a202f438366b7bcffd)

So far unprivileged guest callers running in ring 3 can issue, e.g., MMU
hypercalls. Normally, such callers cannot provide any hand-crafted MMU
command structure as it has to be passed by its physical address, but
they can still crash the guest kernel by passing random addresses.

To close the hole, this patch considers hypercalls valid only if issued
from guest ring 0. This may still be relaxed on a per-hypercall base in
the future once required.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c       |    6 ++++++
 include/linux/kvm_para.h |    1 +
 2 files changed, 7 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2898,6 +2898,11 @@ int kvm_emulate_hypercall(struct kvm_vcp
 		a3 &= 0xFFFFFFFF;
 	}
 
+	if (kvm_x86_ops->get_cpl(vcpu) != 0) {
+		ret = -KVM_EPERM;
+		goto out;
+	}
+
 	switch (nr) {
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
@@ -2909,6 +2914,7 @@ int kvm_emulate_hypercall(struct kvm_vcp
 		ret = -KVM_ENOSYS;
 		break;
 	}
+out:
 	kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
 	++vcpu->stat.hypercalls;
 	return r;
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -13,6 +13,7 @@
 #define KVM_ENOSYS		1000
 #define KVM_EFAULT		EFAULT
 #define KVM_E2BIG		E2BIG
+#define KVM_EPERM		EPERM
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
 #define KVM_HC_MMU_OP			2


