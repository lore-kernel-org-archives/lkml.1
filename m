Return-Path: <linux-kernel-owner+w=401wt.eu-S964831AbZJIX1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbZJIX1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934546AbZJIX1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:27:30 -0400
Received: from kroah.org ([198.145.64.141]:56339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934606AbZJIX1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:27:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:22:34 2009
Message-Id: <20091009232234.187547993@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:21:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kiszka <jan.kiszka@siemens.com>, Avi Kivity <avi@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [6/8] KVM: x86: Disallow hypercalls for guest callers in rings > 0 [CVE-2009-3290]
From: gregkh@mini.kroah.org
References: <20091009232123.464253035@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-disallow-hypercalls-for-guest-callers-in-rings-0.patch
In-Reply-To: <20091009232300.GA403@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jan Kiszka <jan.kiszka@siemens.com>

[ backport to 2.6.27 by Chuck Ebbert <cebbert@redhat.com> ]

commit 07708c4af1346ab1521b26a202f438366b7bcffd upstream.

So far unprivileged guest callers running in ring 3 can issue, e.g., MMU
hypercalls. Normally, such callers cannot provide any hand-crafted MMU
command structure as it has to be passed by its physical address, but
they can still crash the guest kernel by passing random addresses.

To close the hole, this patch considers hypercalls valid only if issued
from guest ring 0. This may still be relaxed on a per-hypercall base in
the future once required.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c       |    6 ++++++
 include/linux/kvm_para.h |    1 +
 2 files changed, 7 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2571,6 +2571,11 @@ int kvm_emulate_hypercall(struct kvm_vcp
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
@@ -2582,6 +2587,7 @@ int kvm_emulate_hypercall(struct kvm_vcp
 		ret = -KVM_ENOSYS;
 		break;
 	}
+out:
 	vcpu->arch.regs[VCPU_REGS_RAX] = ret;
 	kvm_x86_ops->decache_regs(vcpu);
 	++vcpu->stat.hypercalls;
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -13,6 +13,7 @@
 #define KVM_ENOSYS		1000
 #define KVM_EFAULT		EFAULT
 #define KVM_E2BIG		E2BIG
+#define KVM_EPERM		EPERM
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
 #define KVM_HC_MMU_OP			2


