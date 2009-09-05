Return-Path: <linux-kernel-owner+w=401wt.eu-S964929AbZIEA05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929AbZIEA05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934625AbZIEAVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:17 -0400
Received: from kroah.org ([198.145.64.141]:42152 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934529AbZIEAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001451.901615820@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 29/71] KVM: x86: verify MTRR/PAT validity
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-verify-mtrr-pat-validity.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit d6289b9365c3f622a8cfe62c4fb054bb70b5061a)

Do not allow invalid memory types in MTRR/PAT (generating a #GP
otherwise).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -706,11 +706,48 @@ static bool msr_mtrr_valid(unsigned msr)
 	return false;
 }
 
+static bool valid_pat_type(unsigned t)
+{
+	return t < 8 && (1 << t) & 0xf3; /* 0, 1, 4, 5, 6, 7 */
+}
+
+static bool valid_mtrr_type(unsigned t)
+{
+	return t < 8 && (1 << t) & 0x73; /* 0, 1, 4, 5, 6 */
+}
+
+static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	int i;
+
+	if (!msr_mtrr_valid(msr))
+		return false;
+
+	if (msr == MSR_IA32_CR_PAT) {
+		for (i = 0; i < 8; i++)
+			if (!valid_pat_type((data >> (i * 8)) & 0xff))
+				return false;
+		return true;
+	} else if (msr == MSR_MTRRdefType) {
+		if (data & ~0xcff)
+			return false;
+		return valid_mtrr_type(data & 0xff);
+	} else if (msr >= MSR_MTRRfix64K_00000 && msr <= MSR_MTRRfix4K_F8000) {
+		for (i = 0; i < 8 ; i++)
+			if (!valid_mtrr_type((data >> (i * 8)) & 0xff))
+				return false;
+		return true;
+	}
+
+	/* variable MTRRs */
+	return valid_mtrr_type(data & 0xff);
+}
+
 static int set_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	u64 *p = (u64 *)&vcpu->arch.mtrr_state.fixed_ranges;
 
-	if (!msr_mtrr_valid(msr))
+	if (!mtrr_valid(vcpu, msr, data))
 		return 1;
 
 	if (msr == MSR_MTRRdefType) {


