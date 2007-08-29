Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXH2QPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXH2QPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbXH2QPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:15:47 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:7920 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXH2QPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:15:46 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
Date: Wed, 29 Aug 2007 18:15:17 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291815.18197.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, ibmebus derived a device's bus_id from its location code. The
location code is not guaranteed to be unique, so we might get bus_id
collisions if two devices share the same location code. The OFDT full_name,
however, is unique, so we use that instead.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

The patch has been tested and works fine. If you think it's too much change
for 2.6.23-rc5, please schedule for 2.6.24 instead.

 arch/powerpc/kernel/ibmebus.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 9a8c9af..d6a38cd 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -188,33 +188,21 @@ static struct ibmebus_dev* __devinit ibmebus_register_device_node(
 	struct device_node *dn)
 {
 	struct ibmebus_dev *dev;
-	const char *loc_code;
-	int length;
-
-	loc_code = of_get_property(dn, "ibm,loc-code", NULL);
-	if (!loc_code) {
-                printk(KERN_WARNING "%s: node %s missing 'ibm,loc-code'\n",
-		       __FUNCTION__, dn->name ? dn->name : "<unknown>");
-		return ERR_PTR(-EINVAL);
-        }
-
-	if (strlen(loc_code) == 0) {
-	        printk(KERN_WARNING "%s: 'ibm,loc-code' is invalid\n",
-		       __FUNCTION__);
-		return ERR_PTR(-EINVAL);
-	}
+	int i, len, bus_len;
 
 	dev = kzalloc(sizeof(struct ibmebus_dev), GFP_KERNEL);
-	if (!dev) {
+	if (!dev)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	dev->ofdev.node = of_node_get(dn);
 
-	length = strlen(loc_code);
-	memcpy(dev->ofdev.dev.bus_id, loc_code
-		+ (length - min(length, BUS_ID_SIZE - 1)),
-		min(length, BUS_ID_SIZE - 1));
+	len = strlen(dn->full_name + 1);
+	bus_len = min(len, BUS_ID_SIZE - 1);
+	memcpy(dev->ofdev.dev.bus_id, dn->full_name + 1
+	       + (len - bus_len), bus_len);
+	for (i = 0; i < bus_len; i++)
+		if (dev->ofdev.dev.bus_id[i] == '/')
+			dev->ofdev.dev.bus_id[i] = '_';
 
 	/* Register with generic device framework. */
 	if (ibmebus_register_device_common(dev, dn->name) != 0) {
-- 
1.5.2




