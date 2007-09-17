Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbXIQI4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbXIQI4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXIQIdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:39 -0400
Received: from il.qumranet.com ([82.166.9.18]:45248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbXIQIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 092/104] KVM: VMX: Fix exit qualification width on i386
Date: Mon, 17 Sep 2007 10:32:14 +0200
Message-Id: <11900179493319-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

According to Intel Software Developer's Manual, Vol. 3B, Appendix H.4.2,
exit qualification should be of natural width. However, current code
uses u64 as the data type for this register, which occasionally
introduces invalid value to VMExit handling logics. This patch fixes
this bug.

I have tested Windows and Linux guest on i386 host, and they can boot
successfully with this patch.

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index fa4277d..c44c9ac 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1840,12 +1840,12 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u64 exit_qualification;
+	unsigned long exit_qualification;
 	int size, down, in, string, rep;
 	unsigned port;
 
 	++vcpu->stat.io_exits;
-	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	string = (exit_qualification & 16) != 0;
 
 	if (string) {
@@ -1877,11 +1877,11 @@ vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 
 static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u64 exit_qualification;
+	unsigned long exit_qualification;
 	int cr;
 	int reg;
 
-	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	cr = exit_qualification & 15;
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
@@ -1950,7 +1950,7 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	u64 exit_qualification;
+	unsigned long exit_qualification;
 	unsigned long val;
 	int dr, reg;
 
@@ -1958,7 +1958,7 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	 * FIXME: this code assumes the host is debugging the guest.
 	 *        need to deal with guest debugging itself too.
 	 */
-	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	dr = exit_qualification & 7;
 	reg = (exit_qualification >> 8) & 15;
 	vcpu_load_rsp_rip(vcpu);
-- 
1.5.3

