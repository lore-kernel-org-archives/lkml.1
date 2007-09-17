Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbXIQIeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbXIQIeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXIQIc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:26 -0400
Received: from il.qumranet.com ([82.166.9.18]:45229 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXIQIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:22 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 004/104] KVM: In-kernel string pio write support
Date: Mon, 17 Sep 2007 10:30:46 +0200
Message-Id: <1190017946663-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Add string pio write support to support some version of Windows.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index df9c05e..1be510b 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1760,18 +1760,35 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kernel_pio(struct kvm_io_device *pio_dev, struct kvm_vcpu *vcpu)
+static void kernel_pio(struct kvm_io_device *pio_dev,
+		       struct kvm_vcpu *vcpu,
+		       void *pd)
 {
 	/* TODO: String I/O for in kernel device */
 
 	if (vcpu->pio.in)
 		kvm_iodevice_read(pio_dev, vcpu->pio.port,
 				  vcpu->pio.size,
-				  vcpu->pio_data);
+				  pd);
 	else
 		kvm_iodevice_write(pio_dev, vcpu->pio.port,
 				   vcpu->pio.size,
-				   vcpu->pio_data);
+				   pd);
+}
+
+static void pio_string_write(struct kvm_io_device *pio_dev,
+			     struct kvm_vcpu *vcpu)
+{
+	struct kvm_pio_request *io = &vcpu->pio;
+	void *pd = vcpu->pio_data;
+	int i;
+
+	for (i = 0; i < io->cur_count; i++) {
+		kvm_iodevice_write(pio_dev, io->port,
+				   io->size,
+				   pd);
+		pd += io->size;
+	}
 }
 
 int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
@@ -1779,7 +1796,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  gva_t address, int rep, unsigned port)
 {
 	unsigned now, in_page;
-	int i;
+	int i, ret = 0;
 	int nr_pages = 1;
 	struct page *page;
 	struct kvm_io_device *pio_dev;
@@ -1806,15 +1823,12 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
 		kvm_arch_ops->decache_regs(vcpu);
 		if (pio_dev) {
-			kernel_pio(pio_dev, vcpu);
+			kernel_pio(pio_dev, vcpu, vcpu->pio_data);
 			complete_pio(vcpu);
 			return 1;
 		}
 		return 0;
 	}
-	/* TODO: String I/O for in kernel device */
-	if (pio_dev)
-		printk(KERN_ERR "kvm_setup_pio: no string io support\n");
 
 	if (!count) {
 		kvm_arch_ops->skip_emulated_instruction(vcpu);
@@ -1862,9 +1876,21 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		}
 	}
 
-	if (!vcpu->pio.in)
-		return pio_copy_data(vcpu);
-	return 0;
+	if (!vcpu->pio.in) {
+		/* string PIO write */
+		ret = pio_copy_data(vcpu);
+		if (ret >= 0 && pio_dev) {
+			pio_string_write(pio_dev, vcpu);
+			complete_pio(vcpu);
+			if (vcpu->pio.count == 0)
+				ret = 1;
+		}
+	} else if (pio_dev)
+		printk(KERN_ERR "no string pio read support yet, "
+		       "port %x size %d count %ld\n",
+			port, size, count);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_setup_pio);
 
-- 
1.5.3

