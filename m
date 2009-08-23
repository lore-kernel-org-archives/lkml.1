Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbZHWMED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbZHWMED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933754AbZHWMD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933529AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/46] KVM: fix MMIO_CONF_BASE MSR access
Date: Sun, 23 Aug 2009 14:56:13 +0300
Message-Id: <1251028605-31977-15-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Some Windows versions check whether the BIOS has setup MMI/O for
config space accesses on AMD Fam10h CPUs, we say "no" by returning 0 on
reads and only allow disabling of MMI/O CfgSpace setup by igoring "0" writes.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e74d98..95fa45c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -844,6 +844,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 		}
 		break;
+	case MSR_FAM10H_MMIO_CONF_BASE:
+		if (data != 0) {
+			pr_unimpl(vcpu, "unimplemented MMIO_CONF_BASE wrmsr: "
+				"0x%llx\n", data);
+			return 1;
+		}
+		break;
 	case MSR_AMD64_NB_CFG:
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
@@ -1055,6 +1062,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_K7_EVNTSEL0:
 	case MSR_K8_INT_PENDING_MSG:
 	case MSR_AMD64_NB_CFG:
+	case MSR_FAM10H_MMIO_CONF_BASE:
 		data = 0;
 		break;
 	case MSR_MTRRcap:
-- 
1.6.4.1

