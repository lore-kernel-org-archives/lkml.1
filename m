Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXL3HMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXL3HMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXL3HKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:59478 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 06/52] KVM: Add instruction emulation statistics
Date: Sun, 30 Dec 2007 09:09:52 +0200
Message-Id: <1198998638-22713-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/kvm/kvm.h |    2 ++
 drivers/kvm/x86.c |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a85c590..5a8a9af 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -249,6 +249,8 @@ struct kvm_stat {
 	u32 host_state_reload;
 	u32 efer_reload;
 	u32 fpu_reload;
+	u32 insn_emulation;
+	u32 insn_emulation_fail;
 };
 
 struct kvm_io_device {
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index c1211e1..a46b95b 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -63,6 +63,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "host_state_reload", STAT_OFFSET(host_state_reload) },
 	{ "efer_reload", STAT_OFFSET(efer_reload) },
 	{ "fpu_reload", STAT_OFFSET(fpu_reload) },
+	{ "insn_emulation", STAT_OFFSET(insn_emulation) },
+	{ "insn_emulation_fail", STAT_OFFSET(insn_emulation_fail) },
 	{ NULL }
 };
 
@@ -1381,7 +1383,9 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 					get_segment_base(vcpu, VCPU_SREG_FS);
 
 		r = x86_decode_insn(&vcpu->emulate_ctxt, &emulate_ops);
+		++vcpu->stat.insn_emulation;
 		if (r)  {
+			++vcpu->stat.insn_emulation_fail;
 			if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
 				return EMULATE_DONE;
 			return EMULATE_FAIL;
-- 
1.5.3.7

