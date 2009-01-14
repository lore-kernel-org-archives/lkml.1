Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbZANQLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbZANQLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZANQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:11:46 -0500
Received: from smtp.nokia.com ([192.100.105.134]:51156 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731AbZANQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:11:45 -0500
Message-ID: <496E1187.60305@nokia.com>
Date: Wed, 14 Jan 2009 18:23:35 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MMC: Add Extended CSD as a device attribute
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2009 16:11:17.0857 (UTC) FILETIME=[BB554510:01C97662]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/core/mmc.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 3f5b089..29291de 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -259,6 +259,34 @@ MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
 MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
 MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
 
+static ssize_t mmc_ext_csd_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mmc_card *card = container_of(dev, struct mmc_card, dev);
+	ssize_t n = 0;
+	u8 *ext_csd;
+	int err, i;
+
+	ext_csd = kmalloc(512, GFP_KERNEL);
+	if (!ext_csd)
+		return 0;
+
+	mmc_claim_host(card->host);
+	err = mmc_send_ext_csd(card, ext_csd);
+	mmc_release_host(card->host);
+
+	if (!err) {
+		for (i = 511; i >= 0; i--)
+			n += sprintf(buf + n, "%02x", (unsigned)ext_csd[i]);
+		n += sprintf(buf + n, "\n");
+	}
+
+	kfree(ext_csd);
+
+	return n;
+}
+
+static DEVICE_ATTR(ext_csd, S_IRUGO, mmc_ext_csd_show, NULL);
+
 static struct attribute *mmc_std_attrs[] = {
 	&dev_attr_cid.attr,
 	&dev_attr_csd.attr,
@@ -269,6 +297,7 @@ static struct attribute *mmc_std_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_oemid.attr,
 	&dev_attr_serial.attr,
+	&dev_attr_ext_csd.attr,
 	NULL,
 };
 
-- 
1.5.4.3
