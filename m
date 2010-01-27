Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384Ab0A0B5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0A0B5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996Ab0A0B5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:57:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59620 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0A0B5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:57:35 -0500
Date: Wed, 27 Jan 2010 12:57:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20100127125730.6fb414ec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/kvm/x86.c between commit
36cb93fd6b6bf7e9163a69a8bf20207aed5fea44 ("KVM: x86: Fix probable memory
leak of vcpu->arch.mce_banks") from Linus' tree and commit
kvm_arch_vcpu_uninit ("KVM: switch vcpu context to use SRCU") from the
kvm tree.

I fixed it up (I think ... see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kvm/x86.c
index 1ddcad4,a311751..0000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -5089,11 -5468,12 +5469,13 @@@ fail
  
  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
  {
+ 	int idx;
+ 
 +	kfree(vcpu->arch.mce_banks);
  	kvm_free_lapic(vcpu);
- 	down_read(&vcpu->kvm->slots_lock);
+ 	idx = srcu_read_lock(&vcpu->kvm->srcu);
  	kvm_mmu_destroy(vcpu);
- 	up_read(&vcpu->kvm->slots_lock);
+ 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
  	free_page((unsigned long)vcpu->arch.pio_data);
  }
  
