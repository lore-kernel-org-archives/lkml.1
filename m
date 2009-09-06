Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZIFQvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZIFQvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZIFQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:51:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48876 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbZIFQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:51:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 18:51:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/6] firewire: sbp2: fix status reception
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
In-Reply-To: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
Message-ID: <tkrat.2c7e855a0f668383@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per SBP-2 clause 5.3, a target shall store 8...32 bytes of status
information.  Trailing zeros after the first 8 bytes don't need to be
stored, they are implicit.  Fix the status write handler to clear all
unwritten status data.

While we are at it, remove the trivial fw_memcpy_from_be32() helper.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c  |   13 +++++++------
 include/linux/firewire.h |   10 ----------
 2 files changed, 7 insertions(+), 16 deletions(-)

Index: linux-2.6.31-rc9/drivers/firewire/sbp2.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/sbp2.c
+++ linux-2.6.31-rc9/drivers/firewire/sbp2.c
@@ -425,19 +425,20 @@ static void sbp2_status_write(struct fw_
 	struct sbp2_logical_unit *lu = callback_data;
 	struct sbp2_orb *orb;
 	struct sbp2_status status;
-	size_t header_size;
 	unsigned long flags;
 
 	if (tcode != TCODE_WRITE_BLOCK_REQUEST ||
-	    length == 0 || length > sizeof(status)) {
+	    length < 8 || length > sizeof(status)) {
 		fw_send_response(card, request, RCODE_TYPE_ERROR);
 		return;
 	}
 
-	header_size = min(length, 2 * sizeof(u32));
-	fw_memcpy_from_be32(&status, payload, header_size);
-	if (length > header_size)
-		memcpy(status.data, payload + 8, length - header_size);
+	status.status  = be32_to_cpup(payload);
+	status.orb_low = be32_to_cpup(payload + 4);
+	memset(status.data, 0, sizeof(status.data));
+	if (length > 8)
+		memcpy(status.data, payload + 8, length - 8);
+
 	if (STATUS_GET_SOURCE(status) == 2 || STATUS_GET_SOURCE(status) == 3) {
 		fw_notify("non-orb related status write, not handled\n");
 		fw_send_response(card, request, RCODE_COMPLETE);
Index: linux-2.6.31-rc9/include/linux/firewire.h
===================================================================
--- linux-2.6.31-rc9.orig/include/linux/firewire.h
+++ linux-2.6.31-rc9/include/linux/firewire.h
@@ -20,16 +20,6 @@
 #define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
 #define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
 
-static inline void fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
-{
-	u32    *dst = _dst;
-	__be32 *src = _src;
-	int i;
-
-	for (i = 0; i < size / 4; i++)
-		dst[i] = be32_to_cpu(src[i]);
-}
-
 #define CSR_REGISTER_BASE		0xfffff0000000ULL
 
 /* register offsets are relative to CSR_REGISTER_BASE */

-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/

