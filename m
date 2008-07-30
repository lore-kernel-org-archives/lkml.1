Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbYGaAIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbYGaAIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbYGaAIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:08:07 -0400
Received: from mail.suse.de ([195.135.220.2]:38052 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbYGaAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:08:04 -0400
Date: Wed, 30 Jul 2008 16:58:14 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 13/62] KVM: MMU: nuke shadowed pgtable pages and ptes on
	memslot destruction
Message-ID: <20080730235814.GM12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-mmu-nuke-shadowed-pgtable-pages-and-ptes-on-memslot-destruction.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

Original-Commit-Hash: 3cc312f03e06a8fa39ecb4cc0189efc2bd888899

Flush the shadow mmu before removing regions to avoid stale entries.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kvm/kvm-ia64.c   |    3 +++
 arch/powerpc/kvm/powerpc.c |    4 ++++
 arch/s390/kvm/kvm-s390.c   |    4 ++++
 arch/x86/kvm/x86.c         |    5 +++++
 include/linux/kvm_host.h   |    1 +
 virt/kvm/kvm_main.c        |    3 +++
 6 files changed, 20 insertions(+)

--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1460,6 +1460,9 @@ int kvm_arch_set_memory_region(struct kv
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+}
 
 long kvm_arch_dev_ioctl(struct file *filp,
 		unsigned int ioctl, unsigned long arg)
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -167,6 +167,10 @@ int kvm_arch_set_memory_region(struct kv
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -672,6 +672,10 @@ int kvm_arch_set_memory_region(struct kv
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+}
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4016,6 +4016,11 @@ int kvm_arch_set_memory_region(struct kv
 	return 0;
 }
 
+void kvm_arch_flush_shadow(struct kvm *kvm)
+{
+	kvm_mmu_zap_all(kvm);
+}
+
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -166,6 +166,7 @@ int kvm_arch_set_memory_region(struct kv
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
 				int user_alloc);
+void kvm_arch_flush_shadow(struct kvm *kvm);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -377,6 +377,9 @@ int __kvm_set_memory_region(struct kvm *
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
 
+	if (!npages)
+		kvm_arch_flush_shadow(kvm);
+
 	*memslot = new;
 
 	r = kvm_arch_set_memory_region(kvm, mem, old, user_alloc);

-- 
