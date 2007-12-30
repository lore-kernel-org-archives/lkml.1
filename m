Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbXL3HVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbXL3HVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbXL3HLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:23 -0500
Received: from il.qumranet.com ([82.166.9.18]:59477 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbXL3HKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 36/52] KVM: x86 emulator: prefetch up to 15 bytes of the instruction executed
Date: Sun, 30 Dec 2007 09:10:22 +0200
Message-Id: <1198998638-22713-37-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of fetching one byte at a time, prefetch 15 bytes (or until the next
page boundary) to avoid guest page table walks.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   38 ++++++++++++++++++++++++++++++++++++--
 drivers/kvm/x86_emulate.h |    7 +++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 8e2162f..6e7f774 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -414,8 +414,7 @@ static u16 twobyte_table[256] = {
 /* Fetch next part of the instruction being emulated. */
 #define insn_fetch(_type, _size, _eip)                                  \
 ({	unsigned long _x;						\
-	rc = ops->read_std((unsigned long)(_eip) + ctxt->cs_base, &_x,	\
-			   (_size), ctxt->vcpu);			\
+	rc = do_insn_fetch(ctxt, ops, (_eip), &_x, (_size));		\
 	if (rc != 0)							\
 		goto done;						\
 	(_eip) += (_size);						\
@@ -446,6 +445,41 @@ static u16 twobyte_table[256] = {
 		register_address_increment(c->eip, rel);		\
 	} while (0)
 
+static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
+			      struct x86_emulate_ops *ops,
+			      unsigned long linear, u8 *dest)
+{
+	struct fetch_cache *fc = &ctxt->decode.fetch;
+	int rc;
+	int size;
+
+	if (linear < fc->start || linear >= fc->end) {
+		size = min(15UL, PAGE_SIZE - offset_in_page(linear));
+		rc = ops->read_std(linear, fc->data, size, ctxt->vcpu);
+		if (rc)
+			return rc;
+		fc->start = linear;
+		fc->end = linear + size;
+	}
+	*dest = fc->data[linear - fc->start];
+	return 0;
+}
+
+static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
+			 struct x86_emulate_ops *ops,
+			 unsigned long eip, void *dest, unsigned size)
+{
+	int rc = 0;
+
+	eip += ctxt->cs_base;
+	while (size--) {
+		rc = do_fetch_insn_byte(ctxt, ops, eip++, dest++);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
 /*
  * Given the 'reg' portion of a ModRM byte, and a register block, return a
  * pointer into the block that addresses the relevant register.
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index a62bf14..4603b2b 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -108,6 +108,12 @@ struct operand {
 	unsigned long val, orig_val, *ptr;
 };
 
+struct fetch_cache {
+	u8 data[15];
+	unsigned long start;
+	unsigned long end;
+};
+
 struct decode_cache {
 	u8 twobyte;
 	u8 b;
@@ -130,6 +136,7 @@ struct decode_cache {
 	u8 use_modrm_ea;
 	unsigned long modrm_ea;
 	unsigned long modrm_val;
+	struct fetch_cache fetch;
 };
 
 struct x86_emulate_ctxt {
-- 
1.5.3.7

