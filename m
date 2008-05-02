Return-Path: <linux-kernel-owner+w=401wt.eu-S935364AbYEBSQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364AbYEBSQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762336AbYEBSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:16:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46041 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbYEBSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:16:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 2 May 2008 20:14:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: reduce log noise about config ROM CRC errors
To: Miles Lane <miles.lane@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       =?iso-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
In-Reply-To: <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com>
Message-ID: <tkrat.c81e039fca12e91f@s5r6.in-berlin.de>
References: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com> 
 <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de>
 <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  1 May, Miles Lane wrote:
> ohci1394: fw-host0: SelfID received outside of bus reset sequence
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> Program usplash tried to access /dev/mem between 0->8000000.
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00d0f54000000173]
> ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00e018000027d06c]
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> 
> Also, "cat /sys/bus/ieee1394/drivers/raw1394/device_ids" no longer
> causes an error.
> 
> Is it necessary for the code to spit out so many CRC errors for the
> OrangeMicro iBot?


This avoids redundant messages about a special and usually harmless
firmware flaw.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/csr1212.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

Index: linux/drivers/ieee1394/csr1212.c
===================================================================
--- linux.orig/drivers/ieee1394/csr1212.c
+++ linux/drivers/ieee1394/csr1212.c
@@ -1049,6 +1049,24 @@ int csr1212_read(struct csr1212_csr *csr
 	return -ENOENT;
 }
 
+/*
+ * Apparently there are many different wrong implementations of the CRC
+ * algorithm.  We don't fail, we just warn... approximately once per GUID.
+ */
+static void
+csr1212_check_crc(const u32 *buffer, size_t length, u16 crc, __be32 *guid)
+{
+	static u64 last_bad_eui64;
+	u64 eui64 = ((u64)be32_to_cpu(guid[0]) << 32) | be32_to_cpu(guid[1]);
+
+	if (csr1212_crc16(buffer, length) == crc ||
+	    csr1212_msft_crc16(buffer, length) == crc ||
+	    eui64 == last_bad_eui64)
+		return;
+
+	printk(KERN_DEBUG "ieee1394: config ROM CRC error\n");
+	last_bad_eui64 = eui64;
+}
 
 /* Parse a chunk of data as a Config ROM */
 
@@ -1092,11 +1110,8 @@ static int csr1212_parse_bus_info_block(
 			return ret;
 	}
 
-	/* Apparently there are many different wrong implementations of the CRC
-	 * algorithm.  We don't fail, we just warn. */
-	if ((csr1212_crc16(bi->data, bi->crc_length) != bi->crc) &&
-	    (csr1212_msft_crc16(bi->data, bi->crc_length) != bi->crc))
-		printk(KERN_DEBUG "IEEE 1394 device has ROM CRC error\n");
+	csr1212_check_crc(bi->data, bi->crc_length, bi->crc,
+			  &csr->bus_info_data[3]);
 
 	cr = CSR1212_MALLOC(sizeof(*cr));
 	if (!cr)
@@ -1205,11 +1220,8 @@ int csr1212_parse_keyval(struct csr1212_
 		&cache->data[bytes_to_quads(kv->offset - cache->offset)];
 	kvi_len = be16_to_cpu(kvi->length);
 
-	/* Apparently there are many different wrong implementations of the CRC
-	 * algorithm.  We don't fail, we just warn. */
-	if ((csr1212_crc16(kvi->data, kvi_len) != kvi->crc) &&
-	    (csr1212_msft_crc16(kvi->data, kvi_len) != kvi->crc))
-		printk(KERN_DEBUG "IEEE 1394 device has ROM CRC error\n");
+	/* GUID is wrong in here in case of extended ROM.  We don't care. */
+	csr1212_check_crc(kvi->data, kvi_len, kvi->crc, &cache->data[3]);
 
 	switch (kv->key.type) {
 	case CSR1212_KV_TYPE_DIRECTORY:


-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/

