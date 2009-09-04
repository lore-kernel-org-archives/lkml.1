Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbZIDUTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbZIDUTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934210AbZIDUTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:19:00 -0400
Received: from kroah.org ([198.145.64.141]:36220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934054AbZIDUOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:54 2009
Message-Id: <20090904200854.433072752@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 28/48] KVM: Fix PDPTR reloading on CR4 writes
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-pdptr-reloading-on-cr4-writes.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit a2edf57f510cce6a389cc14e58c6ad0a4296d6f9)

The processor is documented to reload the PDPTRs while in PAE mode if any
of the CR4 bits PSE, PGE, or PAE change.  Linux relies on this
behaviour when zapping the low mappings of PAE kernels during boot.

The code already handled changes to CR4.PAE; augment it to also notice changes
to PSE and PGE.

This triggered while booting an F11 PAE kernel; the futex initialization code
runs before any CR3 reloads and writes to a NULL pointer; the futex subsystem
ended up uninitialized, killing PI futexes and pulseaudio which uses them.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -318,6 +318,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	unsigned long old_cr4 = vcpu->arch.cr4;
+	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE;
+
 	if (cr4 & CR4_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
 		kvm_inject_gp(vcpu, 0);
@@ -331,7 +334,8 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, 
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}
-	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & X86_CR4_PAE)
+	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
+		   && ((cr4 ^ old_cr4) & pdptr_bits)
 		   && !load_pdptrs(vcpu, vcpu->arch.cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		kvm_inject_gp(vcpu, 0);


