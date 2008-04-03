Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYDCT1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYDCT1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYDCT13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:27:29 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:47314 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbYDCT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:27:28 -0400
Message-ID: <47F5300D.9040906@keyaccess.nl>
Date: Thu, 03 Apr 2008 21:29:17 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
References: <20080401151634.730901933@ldl.fc.hp.com> <200804021535.22011.bjorn.helgaas@hp.com> <47F4FDCB.2000803@keyaccess.nl> <200804031043.43068.bjorn.helgaas@hp.com> <47F50FF0.40602@keyaccess.nl>
In-Reply-To: <47F50FF0.40602@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------020009020705020108060107"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020009020705020108060107
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 03-04-08 19:12, Rene Herman wrote:

>>> isapnp_read_resources() stores the resources as read from the 
>>> hardware at the index in the table that matches the actual index in 
>>> the hardware and isapnp_set_resources() stores them back into those 
>>> same hardware indices.

While I was there a small cleanup by the way.

Rene.

--------------020009020705020108060107
Content-Type: text/plain;
 name="isapnp_get_resources.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="isapnp_get_resources.diff"

commit 8329f61f01c5edf3060ccf19c6341eb49953158f
Author: Rene Herman <rene.herman@gmail.com>
Date:   Thu Apr 3 21:01:38 2008 +0200

    ISAPNP: fold isapnp_read_resources() back into isapnp_get_resources()
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index fa66597..0bec593 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -921,52 +921,37 @@ EXPORT_SYMBOL(isapnp_cfg_begin);
 EXPORT_SYMBOL(isapnp_cfg_end);
 EXPORT_SYMBOL(isapnp_write_byte);
 
-static int isapnp_read_resources(struct pnp_dev *dev)
+static int isapnp_get_resources(struct pnp_dev *dev)
 {
-	int tmp, ret;
+	int i, ret;
 
+	pnp_init_resources(dev);
+	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (dev->active) {
-		for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
-			if (!ret)
-				continue;
-			pnp_add_io_resource(dev, ret, 1, 0);
+		for (i = 0; i < ISAPNP_MAX_PORT; i++) {
+			ret = isapnp_read_word(ISAPNP_CFG_PORT + (i << 1));
+			if (ret)
+				pnp_add_io_resource(dev, ret, 1, 0);
 		}
-		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-			ret =
-			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
-			if (!ret)
-				continue;
-			pnp_add_mem_resource(dev, ret, 1, 0);
+		for (i = 0; i < ISAPNP_MAX_MEM; i++) {
+			ret = isapnp_read_word(ISAPNP_CFG_MEM + (i << 3)) << 8;
+			if (ret)
+				pnp_add_mem_resource(dev, ret, 1, 0);
 		}
-		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-			ret =
-			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
-			     8);
-			if (!ret)
-				continue;
-			pnp_add_irq_resource(dev, ret, 0);
+		for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
+			ret = isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >> 8;
+			if (ret)
+				pnp_add_irq_resource(dev, ret, 0);
 		}
-		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
-			if (ret == 4)
-				continue;
-			pnp_add_dma_resource(dev, ret, 0);
+		for (i = 0; i < ISAPNP_MAX_DMA; i++) {
+			ret = isapnp_read_byte(ISAPNP_CFG_DMA + i);
+			if (ret != 4)
+				pnp_add_dma_resource(dev, ret, 0);
 		}
 	}
-	return 0;
-}
-
-static int isapnp_get_resources(struct pnp_dev *dev)
-{
-	int ret;
-
-	pnp_init_resources(dev);
-	isapnp_cfg_begin(dev->card->number, dev->number);
-	ret = isapnp_read_resources(dev);
 	isapnp_cfg_end();
-	return ret;
+	return 0;
 }
 
 static int isapnp_set_resources(struct pnp_dev *dev)

--------------020009020705020108060107--
