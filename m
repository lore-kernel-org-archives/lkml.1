Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZAPKaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZAPKaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbZAPK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:29:54 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41458 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbZAPK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:29:53 -0500
Message-ID: <4970646E.5020404@nokia.com>
Date: Fri, 16 Jan 2009 12:41:50 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add Extended CSD as a device attribute
References: <496E1187.60305@nokia.com> <20090115160527.4cdbe94b.akpm@linux-foundation.org>
In-Reply-To: <20090115160527.4cdbe94b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 10:29:25.0954 (UTC) FILETIME=[4E1CC220:01C977C5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Wed, 14 Jan 2009 17:45:53 +0200
Subject: [PATCH] MMC: Add Extended CSD as a device attribute

Extended CSD is a MMC card register.  The Card Identification
(CID) register and the Card-Specific Data (CSD) register are
already device attributes.  As increasingly interesting
fields are being added to Extended CSD, it seems reasonable to
add it too.  Note that SD cards do not have an Extended CSD
register, so it is MMC only.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/core/mmc.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 3f5b089..4eadba6 100644
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
+			n += sprintf(buf + n, "%02x", ext_csd[i]);
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
