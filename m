Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0BDOok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:44:40 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5051 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0BDOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:40 -0500
Subject: [PATCH 12/30] hpsa: make tag macros into functions
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:42:24 -0600
Message-ID: <20100204144224.10406.63430.stgit@beardog.cce.hp.com>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: make tag macros into functions

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   26 ++++++++++++++++++++++----
 drivers/scsi/hpsa.h |    3 ---
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ba3dead..82987e1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2723,6 +2723,24 @@ static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
 		complete(c->waiting);
 }
 
+static inline u32 hpsa_tag_contains_index(u32 tag)
+{
+#define DIRECT_LOOKUP_BIT 0x04
+	return tag & DIRECT_LOOKUP_BIT;
+}
+
+static inline u32 hpsa_tag_to_index(u32 tag)
+{
+#define DIRECT_LOOKUP_SHIFT 3
+	return tag >> DIRECT_LOOKUP_SHIFT;
+}
+
+static inline u32 hpsa_tag_discard_error_bits(u32 tag)
+{
+#define HPSA_ERROR_BITS 0x03
+	return tag & ~HPSA_ERROR_BITS;
+}
+
 static irqreturn_t do_hpsa_intr(int irq, void *dev_id)
 {
 	struct ctlr_info *h = dev_id;
@@ -2736,15 +2754,15 @@ static irqreturn_t do_hpsa_intr(int irq, void *dev_id)
 	spin_lock_irqsave(&h->lock, flags);
 	while (interrupt_pending(h)) {
 		while ((raw_tag = get_next_completion(h)) != FIFO_EMPTY) {
-			if (likely(HPSA_TAG_CONTAINS_INDEX(raw_tag))) {
-				tag_index = HPSA_TAG_TO_INDEX(raw_tag);
+			if (likely(hpsa_tag_contains_index(raw_tag))) {
+				tag_index = hpsa_tag_to_index(raw_tag);
 				if (bad_tag(h, tag_index, raw_tag))
 					return IRQ_HANDLED;
 				c = h->cmd_pool + tag_index;
 				finish_cmd(c, raw_tag);
 				continue;
 			}
-			tag = HPSA_TAG_DISCARD_ERROR_BITS(raw_tag);
+			tag = hpsa_tag_discard_error_bits(raw_tag);
 			c = NULL;
 			hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
 				if (c->busaddr == tag) {
@@ -2824,7 +2842,7 @@ static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 
 	for (i = 0; i < HPSA_MSG_SEND_RETRY_LIMIT; i++) {
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
-		if (HPSA_TAG_DISCARD_ERROR_BITS(tag) == paddr32)
+		if (hpsa_tag_discard_error_bits(tag) == paddr32)
 			break;
 		msleep(HPSA_MSG_SEND_RETRY_INTERVAL_MSECS);
 	}
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 194968e..da8dd3e 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -164,9 +164,6 @@ struct ctlr_info {
 #define HPSA_FIRMWARE_READY	0xffff0000 /* value in scratchpad register */
 
 #define HPSA_ERROR_BIT		0x02
-#define HPSA_TAG_CONTAINS_INDEX(tag) ((tag) & 0x04)
-#define HPSA_TAG_TO_INDEX(tag) ((tag) >> 3)
-#define HPSA_TAG_DISCARD_ERROR_BITS(tag) ((tag) & ~3)
 
 #define HPSA_INTR_ON 	1
 #define HPSA_INTR_OFF	0

