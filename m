Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0BUQ5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:57:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58347 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0BUQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:57:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:57:32 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/8] firewire: ohci: reorder struct fw_ohci for better cache
 efficiency
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.33043f8443197ade@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config_rom struct members are only accessed during relatively
infrequent self-ID-complete interrupts and only if the local config ROM
was changed, while the ar_, at_, ir_, it_ members are used very
frequently during I/O.  Hence move the config_rom members further down.

More importantly, make the huge self_id_buffer member the last one; this
is only accessed in self-ID-complete interrupts.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -166,9 +166,6 @@ struct fw_ohci {
 	struct fw_card card;
 
 	__iomem char *registers;
-	dma_addr_t self_id_bus;
-	__le32 *self_id_cpu;
-	struct tasklet_struct bus_reset_tasklet;
 	int node_id;
 	int generation;
 	int request_generation;	/* for timestamping incoming requests */
@@ -182,14 +179,6 @@ struct fw_ohci {
 	 * this driver with this lock held.
 	 */
 	spinlock_t lock;
-	u32 self_id_buffer[512];
-
-	/* Config rom buffers */
-	__be32 *config_rom;
-	dma_addr_t config_rom_bus;
-	__be32 *next_config_rom;
-	dma_addr_t next_config_rom_bus;
-	__be32 next_header;
 
 	struct ar_context ar_request_ctx;
 	struct ar_context ar_response_ctx;
@@ -201,6 +190,18 @@ struct fw_ohci {
 	u64 ir_context_channels;
 	u32 ir_context_mask;
 	struct iso_context *ir_context_list;
+
+	__be32    *config_rom;
+	dma_addr_t config_rom_bus;
+	__be32    *next_config_rom;
+	dma_addr_t next_config_rom_bus;
+	__be32     next_header;
+
+	__le32    *self_id_cpu;
+	dma_addr_t self_id_bus;
+	struct tasklet_struct bus_reset_tasklet;
+
+	u32 self_id_buffer[512];
 };
 
 static inline struct fw_ohci *fw_ohci(struct fw_card *card)

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

