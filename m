Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbZJIXRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbZJIXRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761675AbZJIXRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:44 -0400
Received: from kroah.org ([198.145.64.141]:36847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761692AbZJIXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.521034233@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 19/26] KVM: SVM: Fix tsc offset adjustment when running nested
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit 77b1ab1732feb5e3dcbaf31d2f7547c5229f5f3a upstream.

When svm_vcpu_load is called while the vcpu is running in
guest mode the tsc adjustment made there is lost on the next
emulated #vmexit. This causes the tsc running backwards in
the guest. This patch fixes the issue by also adjusting the
tsc_offset in the emulated hsave area so that it will not
get lost.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -709,6 +709,8 @@ static void svm_vcpu_load(struct kvm_vcp
 		rdtscll(tsc_this);
 		delta = vcpu->arch.host_tsc - tsc_this;
 		svm->vmcb->control.tsc_offset += delta;
+		if (is_nested(svm))
+			svm->nested.hsave->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;


