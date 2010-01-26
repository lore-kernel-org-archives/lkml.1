Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232Ab0AZXqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0AZXqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080Ab0AZXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:46:35 -0500
Received: from kroah.org ([198.145.64.141]:35550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab0AZXoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.042852139@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [92/98] KVM: x86: Fix leak of free lapic date in kvm_arch_vcpu_init()
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

commit 443c39bc9ef7d8f648408d74c97e943f3bb3f48a upstream.

In function kvm_arch_vcpu_init(), if the memory malloc for
vcpu->arch.mce_banks is fail, it does not free the memory
of lapic date. This patch fixed it.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4766,12 +4766,13 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *
 				       GFP_KERNEL);
 	if (!vcpu->arch.mce_banks) {
 		r = -ENOMEM;
-		goto fail_mmu_destroy;
+		goto fail_free_lapic;
 	}
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
 	return 0;
-
+fail_free_lapic:
+	kvm_free_lapic(vcpu);
 fail_mmu_destroy:
 	kvm_mmu_destroy(vcpu);
 fail_free_pio_data:


