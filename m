Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbZJIXSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbZJIXSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761762AbZJIXR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:57 -0400
Received: from kroah.org ([198.145.64.141]:36858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761678AbZJIXR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.272019830@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 17/26] KVM: VMX: flush TLB with INVEPT on cpu migration
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-flush-tlb-with-invept-on-cpu-migration.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

commit eb5109e311b5152c0614a28d7d615d087f268f19 upstream.

It is possible that stale EPTP-tagged mappings are used, if a
vcpu migrates to a different pcpu.

Set KVM_REQ_TLB_FLUSH in vmx_vcpu_load, when switching pcpus, which
will invalidate both VPID and EPT mappings on the next vm-entry.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -661,7 +661,7 @@ static void vmx_vcpu_load(struct kvm_vcp
 	if (vcpu->cpu != cpu) {
 		vcpu_clear(vmx);
 		kvm_migrate_timers(vcpu);
-		vpid_sync_vcpu_all(vmx);
+		set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests);
 		local_irq_disable();
 		list_add(&vmx->local_vcpus_link,
 			 &per_cpu(vcpus_on_cpu, cpu));


