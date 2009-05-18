Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZERJop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZERJop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbZERJZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 27/43] KVM: ia64: SN2 adjust emulated ITC frequency to match RTC frequency
Date: Mon, 18 May 2009 12:22:49 +0300
Message-Id: <1242638585-18470-28-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

On SN2 do not pass down the real ITC frequency, but rather patch the
values to match the SN2 RTC frequency.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm_fw.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
index a8ae52e..e4b8231 100644
--- a/arch/ia64/kvm/kvm_fw.c
+++ b/arch/ia64/kvm/kvm_fw.c
@@ -21,6 +21,9 @@
 
 #include <linux/kvm_host.h>
 #include <linux/smp.h>
+#include <asm/sn/addrs.h>
+#include <asm/sn/clksupport.h>
+#include <asm/sn/shub_mmr.h>
 
 #include "vti.h"
 #include "misc.h"
@@ -188,12 +191,35 @@ static struct ia64_pal_retval pal_freq_base(struct kvm_vcpu *vcpu)
 	return result;
 }
 
-static struct ia64_pal_retval pal_freq_ratios(struct kvm_vcpu *vcpu)
+/*
+ * On the SGI SN2, the ITC isn't stable. Emulation backed by the SN2
+ * RTC is used instead. This function patches the ratios from SAL
+ * to match the RTC before providing them to the guest.
+ */
+static void sn2_patch_itc_freq_ratios(struct ia64_pal_retval *result)
 {
+	struct pal_freq_ratio *ratio;
+	unsigned long sal_freq, sal_drift, factor;
+
+	result->status = ia64_sal_freq_base(SAL_FREQ_BASE_PLATFORM,
+					    &sal_freq, &sal_drift);
+	ratio = (struct pal_freq_ratio *)&result->v2;
+	factor = ((sal_freq * 3) + (sn_rtc_cycles_per_second / 2)) /
+		sn_rtc_cycles_per_second;
+
+	ratio->num = 3;
+	ratio->den = factor;
+}
 
+static struct ia64_pal_retval pal_freq_ratios(struct kvm_vcpu *vcpu)
+{
 	struct ia64_pal_retval result;
 
 	PAL_CALL(result, PAL_FREQ_RATIOS, 0, 0, 0);
+
+	if (vcpu->kvm->arch.is_sn2)
+		sn2_patch_itc_freq_ratios(&result);
+
 	return result;
 }
 
-- 
1.6.0.6

