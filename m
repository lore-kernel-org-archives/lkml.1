Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZFIKWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZFIKWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760569AbZFIKSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:49 -0400
Received: from kroah.org ([198.145.64.141]:54639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065AbZFIKSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:48 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:58 2009
Message-Id: <20090609094058.315161689@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:15 -0700
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 27/87] KVM: Fix PDPTR reloading on CR4 writes
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=kvm-fix-pdptr-reloading-on-cr4-writes.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit a2edf57f510cce6a389cc14e58c6ad0a4296d6f9 upstream.

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
@@ -334,6 +334,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	unsigned long old_cr4 = vcpu->arch.cr4;
+	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE;
+
 	if (cr4 & CR4_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
 		kvm_inject_gp(vcpu, 0);
@@ -347,7 +350,8 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, 
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}
-	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & X86_CR4_PAE)
+	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
+		   && ((cr4 ^ old_cr4) & pdptr_bits)
 		   && !load_pdptrs(vcpu, vcpu->arch.cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		kvm_inject_gp(vcpu, 0);


