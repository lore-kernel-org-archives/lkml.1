Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYGaAIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYGaAIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYGaAH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:07:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:38009 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbYGaAH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:07:56 -0400
Date: Wed, 30 Jul 2008 16:58:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sheng Yang <sheng.yang@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 11/62] KVM: VMX: Add ept_sync_context in flush_tlb
Message-ID: <20080730235810.GK12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-vmx-add-ept_sync_context-in-flush_tlb.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Sheng Yang <sheng.yang@intel.com>

Original-Commit-Hash: 73f785350b92e1a3af945340f7d10f3978193cba

Fix a potention issue caused by kvm_mmu_slot_remove_write_access(). The
old behavior don't sync EPT TLB with modified EPT entry, which result
in inconsistent content of EPT TLB and EPT table.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kvm/vmx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -88,6 +88,7 @@ static inline struct vcpu_vmx *to_vmx(st
 }
 
 static int init_rmode(struct kvm *kvm);
+static u64 construct_eptp(unsigned long root_hpa);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
@@ -1389,6 +1390,8 @@ static void exit_lmode(struct kvm_vcpu *
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	vpid_sync_vcpu_all(to_vmx(vcpu));
+	if (vm_need_ept())
+		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
 }
 
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)

-- 
