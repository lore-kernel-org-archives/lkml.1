Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZJKMyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZJKMyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZJKMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZJKMyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:54:17 -0400
Message-Id: <200910111250.n9BCojKG002692@int-mx05.intmail.prod.int.phx2.redhat.com>
Date: Sun, 11 Oct 2009 08:50:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: stable-review@kernel.org
Cc: stable@kernel.org, Joel Becker <Joel.Becker@oracle.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [patch][stable][stable-review] 2.6.31.4-rc2: Fix compile error
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacement patch for:
kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch

Fixes:
arch/x86/kvm/svm.c: In function 'svm_vcpu_load':
arch/x86/kvm/svm.c:713: error: 'struct vcpu_svm' has no member named 'nested' 


>From 77b1ab1732feb5e3dcbaf31d2f7547c5229f5f3a Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 16 Sep 2009 15:24:17 +0200
Subject: KVM: SVM: Fix tsc offset adjustment when running nested

From: Joerg Roedel <joerg.roedel@amd.com>

commit 77b1ab1732feb5e3dcbaf31d2f7547c5229f5f3a upstream.
[ backport to 2.6.31 by Chuck Ebbert <cebbert@redhat.com> ]

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
+			svm->hsave->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
