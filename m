Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXLBLTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXLBLTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbXLBLSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:15 -0500
Received: from il.qumranet.com ([82.166.9.18]:41441 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXLBLSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/10] KVM: Skip pio instruction when it is emulated, not executed
Date: Sun,  2 Dec 2007 13:18:45 +0200
Message-Id: <11965943273087-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we defer updating rip until pio instructions are executed, we have a
problem with reset:  a pio reset updates rip, and when the instruction
completes we skip the emulated instruction, pointing rip somewhere completely
unrelated.

Fix by updating rip when we see decode the instruction, not after emulation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 504e81d..b58fdf3 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1757,8 +1757,6 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 	io->count -= io->cur_count;
 	io->cur_count = 0;
 
-	if (!io->count)
-		kvm_arch_ops->skip_emulated_instruction(vcpu);
 	return 0;
 }
 
@@ -1804,6 +1802,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	pio_dev = vcpu_find_pio_dev(vcpu, port);
 	if (!string) {
+		kvm_arch_ops->skip_emulated_instruction(vcpu);
 		kvm_arch_ops->cache_regs(vcpu);
 		memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
 		kvm_arch_ops->decache_regs(vcpu);
@@ -1850,6 +1849,9 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->run->io.count = now;
 	vcpu->pio.cur_count = now;
 
+	if (now == count)
+		kvm_arch_ops->skip_emulated_instruction(vcpu);
+
 	for (i = 0; i < nr_pages; ++i) {
 		spin_lock(&vcpu->kvm->lock);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
-- 
1.5.3

