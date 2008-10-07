Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYJGAqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYJGAqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYJGAnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:15 -0400
Received: from mail.suse.de ([195.135.220.2]:46665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbYJGAnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:13 -0400
Date: Mon, 6 Oct 2008 17:38:11 -0700
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
       Alexander Graf <agraf@suse.de>, Avi Kivity <avi@qumranet.com>
Subject: [patch 17/71] KVM: SVM: fix random segfaults with NPT enabled
Message-ID: <20081007003811.GR3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-svm-fix-random-segfaults-with-npt-enabled.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

(cherry picked from commit 44874f84918e37b64bec6df1587e5fe2fdf6ab62)

This patch introduces a guest TLB flush on every NPF exit in KVM. This fixes
random segfaults and #UD exceptions in the guest seen under some workloads
(e.g. long running compile workloads or tbench). A kernbench run with and
without that fix showed that it has a slowdown lower than 0.5%

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -60,6 +60,7 @@ static int npt = 1;
 module_param(npt, int, S_IRUGO);
 
 static void kvm_reput_irq(struct vcpu_svm *svm);
+static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
@@ -1017,6 +1018,15 @@ static int pf_interception(struct vcpu_s
 
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
+
+	/*
+	 * FIXME: Tis shouldn't be necessary here, but there is a flush
+	 * missing in the MMU code. Until we find this bug, flush the
+	 * complete TLB here on an NPF
+	 */
+	if (npt_enabled)
+		svm_flush_tlb(&svm->vcpu);
+
 	if (event_injection)
 		kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);

-- 
