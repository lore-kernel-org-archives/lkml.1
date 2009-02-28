Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbZB1Bn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbZB1Bn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZB1BmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZB1Bl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:56 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/30] KVM: ia64: Add the support for translating PAL Call's pointer args
Date: Sat, 28 Feb 2009 03:41:21 +0200
Message-Id: <1235785309-12835-3-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Add the support to translate PAL Call's pointer args.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/process.c |   48 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index f9c9504..0e727ce 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -550,18 +550,60 @@ void reflect_interruption(u64 ifa, u64 isr, u64 iim,
 	inject_guest_interruption(vcpu, vector);
 }
 
+static unsigned long kvm_trans_pal_call_args(struct kvm_vcpu *vcpu,
+						unsigned long arg)
+{
+	struct thash_data *data;
+	unsigned long gpa, poff;
+
+	if (!is_physical_mode(vcpu)) {
+		/* Depends on caller to provide the DTR or DTC mapping.*/
+		data = vtlb_lookup(vcpu, arg, D_TLB);
+		if (data)
+			gpa = data->page_flags & _PAGE_PPN_MASK;
+		else {
+			data = vhpt_lookup(arg);
+			if (!data)
+				return 0;
+			gpa = data->gpaddr & _PAGE_PPN_MASK;
+		}
+
+		poff = arg & (PSIZE(data->ps) - 1);
+		arg = PAGEALIGN(gpa, data->ps) | poff;
+	}
+	arg = kvm_gpa_to_mpa(arg << 1 >> 1);
+
+	return (unsigned long)__va(arg);
+}
+
 static void set_pal_call_data(struct kvm_vcpu *vcpu)
 {
 	struct exit_ctl_data *p = &vcpu->arch.exit_data;
+	unsigned long gr28 = vcpu_get_gr(vcpu, 28);
+	unsigned long gr29 = vcpu_get_gr(vcpu, 29);
+	unsigned long gr30 = vcpu_get_gr(vcpu, 30);
 
 	/*FIXME:For static and stacked convention, firmware
 	 * has put the parameters in gr28-gr31 before
 	 * break to vmm  !!*/
 
-	p->u.pal_data.gr28 = vcpu_get_gr(vcpu, 28);
-	p->u.pal_data.gr29 = vcpu_get_gr(vcpu, 29);
-	p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
+	switch (gr28) {
+	case PAL_PERF_MON_INFO:
+	case PAL_HALT_INFO:
+		p->u.pal_data.gr29 =  kvm_trans_pal_call_args(vcpu, gr29);
+		p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
+		break;
+	case PAL_BRAND_INFO:
+		p->u.pal_data.gr29 = gr29;;
+		p->u.pal_data.gr30 = kvm_trans_pal_call_args(vcpu, gr30);
+		break;
+	default:
+		p->u.pal_data.gr29 = gr29;;
+		p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
+	}
+	p->u.pal_data.gr28 = gr28;
 	p->u.pal_data.gr31 = vcpu_get_gr(vcpu, 31);
+
 	p->exit_reason = EXIT_REASON_PAL_CALL;
 }
 
-- 
1.6.0.6

