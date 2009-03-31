Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZCaXbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZCaXbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763631AbZCaXVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:07 -0400
Received: from sous-sol.org ([216.99.217.87]:33221 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763801AbZCaXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:04 -0400
Message-Id: <20090331231454.378948626@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:58 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>
Subject: [patch 13/45] KVM: VMX: Dont allow uninhibited access to EFER on i386
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=kvm-vmx-don-t-allow-uninhibited-access-to-efer-on-i386.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Avi Kivity <avi@redhat.com>

upstream commit: 16175a796d061833aacfbd9672235f2d2725df65

vmx_set_msr() does not allow i386 guests to touch EFER, but they can still
do so through the default: label in the switch.  If they set EFER_LME, they
can oops the host.

Fix by having EFER access through the normal channel (which will check for
EFER_LME) even on i386.

Reported-and-tested-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -928,11 +928,11 @@ static int vmx_set_msr(struct kvm_vcpu *
 	int ret = 0;
 
 	switch (msr_index) {
-#ifdef CONFIG_X86_64
 	case MSR_EFER:
 		vmx_load_host_state(vmx);
 		ret = kvm_set_msr_common(vcpu, msr_index, data);
 		break;
+#ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		vmcs_writel(GUEST_FS_BASE, data);
 		break;

