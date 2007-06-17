Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbXFQJwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbXFQJwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbXFQJpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:55193 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 20/58] KVM: VMX: Only reload guest msrs if they are already loaded
Date: Sun, 17 Jun 2007 12:44:01 +0300
Message-Id: <11820734801415-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we set an msr via an ioctl() instead of by handling a guest exit, we
have the host state loaded, so reloading the msrs would clobber host
state instead of guest state.

This fixes a host oops (and loss of a cpu) on a guest reboot.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 096cb6a..b353eaa 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -600,7 +600,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		msr = find_msr_entry(vcpu, msr_index);
 		if (msr)
 			msr->data = data;
-		load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+		if (vcpu->vmx_host_state.loaded)
+			load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-- 
1.5.0.6

