Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbZIDUTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbZIDUTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbZIDUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:19:45 -0400
Received: from kroah.org ([198.145.64.141]:36201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934036AbZIDUO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200853.702476063@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 23/48] KVM: VMX: Dont allow uninhibited access to EFER on i386
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-don-t-allow-uninhibited-access-to-efer-on-i386.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 16175a796d061833aacfbd9672235f2d2725df65)

vmx_set_msr() does not allow i386 guests to touch EFER, but they can still
do so through the default: label in the switch.  If they set EFER_LME, they
can oops the host.

Fix by having EFER access through the normal channel (which will check for
EFER_LME) even on i386.

Reported-and-tested-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -898,11 +898,11 @@ static int vmx_set_msr(struct kvm_vcpu *
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


