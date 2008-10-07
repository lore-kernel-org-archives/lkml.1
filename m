Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYJGArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYJGArT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYJGAnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:46691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbYJGAnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:17 -0400
Date: Mon, 6 Oct 2008 17:38:13 -0700
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
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 18/71] KVM: SVM: fix guest global tlb flushes with NPT
Message-ID: <20081007003813.GS3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-svm-fix-guest-global-tlb-flushes-with-npt.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

(cherry picked from commit e5eab0cede4b1ffaca4ad857d840127622038e55)

Accesses to CR4 are intercepted even with Nested Paging enabled. But the code
does not check if the guest wants to do a global TLB flush. So this flush gets
lost. This patch adds the check and the flush to svm_set_cr4.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -880,6 +880,10 @@ set:
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long host_cr4_mce = read_cr4() & X86_CR4_MCE;
+	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
+
+	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
+		force_new_asid(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)

-- 
