Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYLMWMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYLMWMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 17:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYLMWMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 17:12:16 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49249 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYLMWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 17:12:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 13 Dec 2008 23:12:06 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] ieee1394: ignore nonzero Bus_Info_Block.max_rom, fetch
 config ROM in quadlets
To: linux1394-devel@lists.sourceforge.net
cc: Christian Mueller <cm1@mumac.de>, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.61dc116fccdc7aa8@s5r6.in-berlin.de>
Message-ID: <tkrat.10e07e7e94d24c32@s5r6.in-berlin.de>
References: <20081212220902.10115108040@picon.linux-foundation.org>
 <4942E4E0.2030109@s5r6.in-berlin.de>
 <tkrat.cf2109296e2ea177@s5r6.in-berlin.de>
 <49441769.1060209@s5r6.in-berlin.de>
 <tkrat.aa600853dd4a55d9@s5r6.in-berlin.de>
 <tkrat.61dc116fccdc7aa8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is already known that buggy firmwares exist which report a bogus
link_spd in their config ROM bus info block.  We now got the first
report of a bogus max_rom too (Freecom FireWire Hard Drive 1TB,
http://bugzilla.kernel.org/show_bug.cgi?id=12206).

I suspect other OSs only use quadlet reads to fetch the config ROM,
otherwise the firmware authors would have noticed their mistake.
Hence limit ieee1394's config ROM fetching routine to quadlets as the
safe minimum regardless of what the bus info block says.

This will potentially slow the bus reset handling by nodemgr somewhat
down.  But most existing devices support only quadlet reads anyway,
hence there will often be no actual difference to before this change.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Candidate patch for after 2.6.28.

 drivers/ieee1394/csr1212.c |   45 +++++++++++--------------------------
 drivers/ieee1394/csr1212.h |    7 -----
 drivers/ieee1394/nodemgr.c |   20 +++-------------
 3 files changed, 19 insertions(+), 53 deletions(-)

Index: linux/drivers/ieee1394/csr1212.c
===================================================================
--- linux.orig/drivers/ieee1394/csr1212.c
+++ linux/drivers/ieee1394/csr1212.c
@@ -1077,15 +1077,10 @@ static int csr1212_parse_bus_info_block(
 	int i;
 	int ret;
 
-	/* IEEE 1212 says that the entire bus info block should be readable in
-	 * a single transaction regardless of the max_rom value.
-	 * Unfortunately, many IEEE 1394 devices do not abide by that, so the
-	 * bus info block will be read 1 quadlet at a time.  The rest of the
-	 * ConfigROM will be read according to the max_rom field. */
 	for (i = 0; i < csr->bus_info_len; i += sizeof(u32)) {
 		ret = csr->ops->bus_read(csr, CSR1212_CONFIG_ROM_SPACE_BASE + i,
-			sizeof(u32), &csr->cache_head->data[bytes_to_quads(i)],
-			csr->private);
+				&csr->cache_head->data[bytes_to_quads(i)],
+				csr->private);
 		if (ret != CSR1212_SUCCESS)
 			return ret;
 
@@ -1104,8 +1099,8 @@ static int csr1212_parse_bus_info_block(
 	 * a time. */
 	for (i = csr->bus_info_len; i <= csr->crc_len; i += sizeof(u32)) {
 		ret = csr->ops->bus_read(csr, CSR1212_CONFIG_ROM_SPACE_BASE + i,
-			sizeof(u32), &csr->cache_head->data[bytes_to_quads(i)],
-			csr->private);
+				&csr->cache_head->data[bytes_to_quads(i)],
+				csr->private);
 		if (ret != CSR1212_SUCCESS)
 			return ret;
 	}
@@ -1289,7 +1284,7 @@ csr1212_read_keyval(struct csr1212_csr *
 
 		if (csr->ops->bus_read(csr,
 				       CSR1212_REGISTER_SPACE_BASE + kv->offset,
-				       sizeof(u32), &q, csr->private))
+				       &q, csr->private))
 			return -EIO;
 
 		kv->value.leaf.len = be32_to_cpu(q) >> 16;
@@ -1372,17 +1367,8 @@ csr1212_read_keyval(struct csr1212_csr *
 		addr = (CSR1212_CSR_ARCH_REG_SPACE_BASE + cache->offset +
 			cr->offset_end) & ~(csr->max_rom - 1);
 
-		if (csr->ops->bus_read(csr, addr, csr->max_rom, cache_ptr,
-				       csr->private)) {
-			if (csr->max_rom == 4)
-				/* We've got problems! */
-				return -EIO;
-
-			/* Apperently the max_rom value was a lie, set it to
-			 * do quadlet reads and try again. */
-			csr->max_rom = 4;
-			continue;
-		}
+		if (csr->ops->bus_read(csr, addr, cache_ptr, csr->private))
+			return -EIO;
 
 		cr->offset_end += csr->max_rom - (cr->offset_end &
 						  (csr->max_rom - 1));
@@ -1433,7 +1419,6 @@ csr1212_get_keyval(struct csr1212_csr *c
 
 int csr1212_parse_csr(struct csr1212_csr *csr)
 {
-	static const int mr_map[] = { 4, 64, 1024, 0 };
 	struct csr1212_dentry *dentry;
 	int ret;
 
@@ -1443,15 +1428,13 @@ int csr1212_parse_csr(struct csr1212_csr
 	if (ret != CSR1212_SUCCESS)
 		return ret;
 
-	if (!csr->ops->get_max_rom) {
-		csr->max_rom = mr_map[0];	/* default value */
-	} else {
-		int i = csr->ops->get_max_rom(csr->bus_info_data,
-					      csr->private);
-		if (i & ~0x3)
-			return -EINVAL;
-		csr->max_rom = mr_map[i];
-	}
+	/*
+	 * There has been a buggy firmware with bus_info_block.max_rom > 0
+	 * spotted which actually only supported quadlet read requests to the
+	 * config ROM.  Therefore read everything quadlet by quadlet regardless
+	 * of what the bus info block says.
+	 */
+	csr->max_rom = 4;
 
 	csr->cache_head->layout_head = csr->root_kv;
 	csr->cache_head->layout_tail = csr->root_kv;
Index: linux/drivers/ieee1394/csr1212.h
===================================================================
--- linux.orig/drivers/ieee1394/csr1212.h
+++ linux/drivers/ieee1394/csr1212.h
@@ -200,7 +200,7 @@ struct csr1212_bus_ops {
 	 * entries located in the Units Space.  Must return 0 on success
 	 * anything else indicates an error. */
 	int (*bus_read) (struct csr1212_csr *csr, u64 addr,
-			 u16 length, void *buffer, void *private);
+			 void *buffer, void *private);
 
 	/* This function is used by csr1212 to allocate a region in units space
 	 * in the event that Config ROM entries don't all fit in the predefined
@@ -211,11 +211,6 @@ struct csr1212_bus_ops {
 	/* This function is used by csr1212 to release a region in units space
 	 * that is no longer needed. */
 	void (*release_addr) (u64 addr, void *private);
-
-	/* This function is used by csr1212 to determine the max read request
-	 * supported by a remote node when reading the ConfigROM space.  Must
-	 * return 0, 1, or 2 per IEEE 1212.  */
-	int (*get_max_rom) (u32 *bus_info, void *private);
 };
 
 
Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -67,7 +67,7 @@ static int nodemgr_check_speed(struct no
 	for (i = IEEE1394_SPEED_100; i <= old_speed; i++) {
 		*speed = i;
 		error = hpsb_read(ci->host, ci->nodeid, ci->generation, addr,
-				  &q, sizeof(quadlet_t));
+				  &q, 4);
 		if (error)
 			break;
 		*buffer = q;
@@ -85,7 +85,7 @@ static int nodemgr_check_speed(struct no
 	return error;
 }
 
-static int nodemgr_bus_read(struct csr1212_csr *csr, u64 addr, u16 length,
+static int nodemgr_bus_read(struct csr1212_csr *csr, u64 addr,
 			    void *buffer, void *__ci)
 {
 	struct nodemgr_csr_info *ci = (struct nodemgr_csr_info*)__ci;
@@ -93,7 +93,7 @@ static int nodemgr_bus_read(struct csr12
 
 	for (i = 1; ; i++) {
 		error = hpsb_read(ci->host, ci->nodeid, ci->generation, addr,
-				  buffer, length);
+				  buffer, 4);
 		if (!error) {
 			ci->speed_unverified = 0;
 			break;
@@ -104,7 +104,7 @@ static int nodemgr_bus_read(struct csr12
 
 		/* The ieee1394_core guessed the node's speed capability from
 		 * the self ID.  Check whether a lower speed works. */
-		if (ci->speed_unverified && length == sizeof(quadlet_t)) {
+		if (ci->speed_unverified) {
 			error = nodemgr_check_speed(ci, addr, buffer);
 			if (!error)
 				break;
@@ -115,20 +115,8 @@ static int nodemgr_bus_read(struct csr12
 	return error;
 }
 
-#define OUI_FREECOM_TECHNOLOGIES_GMBH 0x0001db
-
-static int nodemgr_get_max_rom(quadlet_t *bus_info_data, void *__ci)
-{
-	/* Freecom FireWire Hard Drive firmware bug */
-	if (be32_to_cpu(bus_info_data[3]) >> 8 == OUI_FREECOM_TECHNOLOGIES_GMBH)
-		return 0;
-
-	return (be32_to_cpu(bus_info_data[2]) >> 8) & 0x3;
-}
-
 static struct csr1212_bus_ops nodemgr_csr_ops = {
 	.bus_read =	nodemgr_bus_read,
-	.get_max_rom =	nodemgr_get_max_rom
 };
 
 

-- 
Stefan Richter
-=====-==--- ==-- -==-=
http://arcgraph.de/sr/

