Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbYCCK5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbYCCK5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYCCK5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:57:31 -0500
Received: from mail.tnp-online.de ([212.80.247.147]:58254 "EHLO
	fallback.gigamail.to" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYCCK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:57:30 -0500
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2008 05:57:29 EST
From: Arne Redlich <arne.redlich@xiranet.com>
To: Roland Dreier <rolandd@cisco.com>
Cc: ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>, erezz@voltaire.com
Subject: Re: [PATCH 1/2] IB/iSER: fix list iteration bug
Date: Mon, 03 Mar 2008 11:36:14 +0100
Message-ID: <877igkxffl.fsf@confield.dd.xiranet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-xiranet-MailScanner-OpenProtect-Information: Please contact the ISP for more information
X-xiranet-MailScanner-OpenProtect: Found to be clean
X-xiranet-MailScanner-OpenProtect-MCPCheck: 
X-xiranet-MailScanner-OpenProtect-From: arne.redlich@xiranet.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iteration through the list of "iser_device"s during device
lookup/creation is broken - it might result in an infinite loop if more
than 1 HCA is used with iSER. Use list_for_each_entry() instead of the
custom, flawed list iteration code.

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   36 ++++++++++++-----------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 714b8db..1c0f968 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -237,33 +237,27 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
 static
 struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 {
-	struct list_head    *p_list;
-	struct iser_device  *device = NULL;
+	struct iser_device *device;
 
 	mutex_lock(&ig.device_list_mutex);
 
-	p_list = ig.device_list.next;
-	while (p_list != &ig.device_list) {
-		device = list_entry(p_list, struct iser_device, ig_list);
-		/* find if there's a match using the node GUID */
+	list_for_each_entry(device, &ig.device_list, ig_list)
 		if (device->ib_device->node_guid == cma_id->device->node_guid)
-			break;
-	}
-
-	if (device == NULL) {
-		device = kzalloc(sizeof *device, GFP_KERNEL);
-		if (device == NULL)
 			goto out;
-		/* assign this device to the device */
-		device->ib_device = cma_id->device;
-		/* init the device and link it into ig device list */
-		if (iser_create_device_ib_res(device)) {
-			kfree(device);
-			device = NULL;
-			goto out;
-		}
-		list_add(&device->ig_list, &ig.device_list);
+
+	device = kzalloc(sizeof *device, GFP_KERNEL);
+	if (device == NULL)
+		goto out;
+
+	device->ib_device = cma_id->device;
+	/* init the device and link it into ig device list */
+	if (iser_create_device_ib_res(device)) {
+		kfree(device);
+		device = NULL;
+		goto out;
 	}
+	list_add(&device->ig_list, &ig.device_list);
+
 out:
 	BUG_ON(device == NULL);
 	device->refcount++;
-- 
1.5.4.1

