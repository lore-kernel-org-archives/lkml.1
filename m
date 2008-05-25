Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbYEYKZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbYEYKZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbYEYKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbYEYKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:41 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Brice Goglin <brice@myri.com>, Andrew Gallatin <gallatin@myri.com>
Subject: [PATCHv2 05/28] myri10ge: treat firmware data as const
Message-Id: <E1K0DO2-0007D6-5V@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:34 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... which means allocating our own buffer for reading it back.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/myri10ge/myri10ge.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index c91b12e..ab7a80b 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -529,6 +529,7 @@ static int myri10ge_load_hotplug_firmware(struct myri10ge_priv *mgp, u32 * size)
 	unsigned crc, reread_crc;
 	const struct firmware *fw;
 	struct device *dev = &mgp->pdev->dev;
+	unsigned char *fw_readback;
 	struct mcp_gen_header *hdr;
 	size_t hdr_offset;
 	int status;
@@ -571,9 +572,15 @@ static int myri10ge_load_hotplug_firmware(struct myri10ge_priv *mgp, u32 * size)
 		mb();
 		readb(mgp->sram);
 	}
+	fw_readback = vmalloc(fw->size);
+	if (!fw_readback) {
+		status = -ENOMEM;
+		goto abort_with_fw;
+	}
 	/* corruption checking is good for parity recovery and buggy chipset */
-	memcpy_fromio(fw->data, mgp->sram + MYRI10GE_FW_OFFSET, fw->size);
-	reread_crc = crc32(~0, fw->data, fw->size);
+	memcpy_fromio(fw_readback, mgp->sram + MYRI10GE_FW_OFFSET, fw->size);
+	reread_crc = crc32(~0, fw_readback, fw->size);
+	vfree(fw_readback);
 	if (crc != reread_crc) {
 		dev_err(dev, "CRC failed(fw-len=%u), got 0x%x (expect 0x%x)\n",
 			(unsigned)fw->size, reread_crc, crc);
-- 
1.5.4.5

