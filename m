Return-Path: <linux-kernel-owner+w=401wt.eu-S1751278AbZH1NUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbZH1NUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZH1NUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:20:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57010 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZH1NUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:20:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 28 Aug 2009 15:20:29 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: reduce stack usage in bus reset tasklet
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.82fef6d14408ae6d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_compute_block_crc() used 1024 bytes of the kernel stack.  This
function is called
  - in process context when the local node's config ROM is updated,
  - in tasklet context of the bus reset handler.

Replace the stack-allocated buffer by a static buffer.
Serialize buffer accesses by a static local spinlock.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc8/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31-rc8.orig/drivers/firewire/core-card.c
+++ linux-2.6.31-rc8/drivers/firewire/core-card.c
@@ -40,13 +40,19 @@
 
 int fw_compute_block_crc(u32 *block)
 {
-	__be32 be32_block[256];
+	static DEFINE_SPINLOCK(buffer_lock);
+	static __be32 buffer[256];
+	unsigned long flags;
 	int i, length;
 
+	spin_lock_irqsave(&buffer_lock, flags);
+
 	length = (*block >> 16) & 0xff;
 	for (i = 0; i < length; i++)
-		be32_block[i] = cpu_to_be32(block[i + 1]);
-	*block |= crc_itu_t(0, (u8 *) be32_block, length * 4);
+		buffer[i] = cpu_to_be32(block[i + 1]);
+	*block |= crc_itu_t(0, (u8 *)buffer, length * 4);
+
+	spin_unlock_irqrestore(&buffer_lock, flags);
 
 	return length;
 }

-- 
Stefan Richter
-=====-==--= =--- ===--
http://arcgraph.de/sr/

