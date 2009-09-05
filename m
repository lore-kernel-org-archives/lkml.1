Return-Path: <linux-kernel-owner+w=401wt.eu-S964872AbZIEAZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbZIEAZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934670AbZIEAVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:22 -0400
Received: from kroah.org ([198.145.64.141]:42156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934561AbZIEAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001452.063553307@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 30/71] KVM: SVM: force new asid on vcpu migration
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-svm-force-new-asid-on-vcpu-migration.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 4b656b1202498184a0ecef86b3b89ff613b9c6ab)

If a migrated vcpu matches the asid_generation value of the target pcpu,
there will be no TLB flush via TLB_CONTROL_FLUSH_ALL_ASID.

The check for vcpu.cpu in pre_svm_run is meaningless since svm_vcpu_load
already updated it on schedule in.

Such vcpu will VMRUN with stale TLB entries.

Based on original patch from Joerg Roedel (http://patchwork.kernel.org/patch/10021/)

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/svm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -736,6 +736,7 @@ static void svm_vcpu_load(struct kvm_vcp
 		svm->vmcb->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
+		svm->asid_generation = 0;
 	}
 
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
@@ -1046,7 +1047,6 @@ static void new_asid(struct vcpu_svm *sv
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 
-	svm->vcpu.cpu = svm_data->cpu;
 	svm->asid_generation = svm_data->asid_generation;
 	svm->vmcb->control.asid = svm_data->next_asid++;
 }
@@ -2258,8 +2258,8 @@ static void pre_svm_run(struct vcpu_svm 
 	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
-	if (svm->vcpu.cpu != cpu ||
-	    svm->asid_generation != svm_data->asid_generation)
+	/* FIXME: handle wraparound of asid_generation */
+	if (svm->asid_generation != svm_data->asid_generation)
 		new_asid(svm, svm_data);
 }
 


