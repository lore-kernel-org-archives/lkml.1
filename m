Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXD2Pvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXD2Pvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXD2Puu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:34365 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbXD2Pu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 5/7] KVM: Remove extraneous guest entry on mmio read
Date: Sun, 29 Apr 2007 18:50:20 +0300
Message-Id: <11778618221425-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1177861822889-git-send-email-avi@qumranet.com>
References: <1177861822889-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When emulating an mmio read, we actually emulate twice: once to determine
the physical address of the mmio, and, after we've exited to userspace to
get the mmio value, we emulate again to place the value in the result
register and update any flags.

But we don't really need to enter the guest again for that, only to take
an immediate vmexit.  So, if we detect that we're doing an mmio read,
emulate a single instruction before entering the guest again.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f99e89e..41634fd 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -310,6 +310,7 @@ struct kvm_vcpu {
 	int mmio_size;
 	unsigned char mmio_data[8];
 	gpa_t mmio_phys_addr;
+	gva_t mmio_fault_cr2;
 	struct kvm_pio_request pio;
 	void *pio_data;
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index cdf0b17..a9ba42f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1186,6 +1186,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	int r;
 	int cs_db, cs_l;
 
+	vcpu->mmio_fault_cr2 = cr2;
 	kvm_arch_ops->cache_regs(vcpu);
 
 	kvm_arch_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
@@ -1804,9 +1805,11 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			r = complete_pio(vcpu);
 			if (r)
 				goto out;
-		} else {
+		} else if (!vcpu->mmio_is_write) {
 			memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
 			vcpu->mmio_read_completed = 1;
+			emulate_instruction(vcpu, kvm_run,
+					    vcpu->mmio_fault_cr2, 0);
 		}
 	}
 
-- 
1.5.0.6

