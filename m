Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYCCK6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYCCK6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbYCCK5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:57:33 -0500
Received: from mail.tnp-online.de ([212.80.247.147]:58292 "EHLO
	fallback.gigamail.to" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYCCK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:57:30 -0500
From: Arne Redlich <arne.redlich@xiranet.com>
To: Roland Dreier <rolandd@cisco.com>
Cc: ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>, erezz@voltaire.com
Subject: Re: [PATCH 2/2] IB/iSER: handle iser_device allocation error gracefully
Date: Mon, 03 Mar 2008 11:36:26 +0100
Message-ID: <87zltgw0ut.fsf@confield.dd.xiranet.com>
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

"iser_device" allocation failure is "handled" with a BUG_ON() right
before dereferencing the NULL-pointer - fix this!

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 1c0f968..cf70d15 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -243,7 +243,7 @@ struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 
 	list_for_each_entry(device, &ig.device_list, ig_list)
 		if (device->ib_device->node_guid == cma_id->device->node_guid)
-			goto out;
+			goto inc_refcnt;
 
 	device = kzalloc(sizeof *device, GFP_KERNEL);
 	if (device == NULL)
@@ -258,9 +258,9 @@ struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 	}
 	list_add(&device->ig_list, &ig.device_list);
 
-out:
-	BUG_ON(device == NULL);
+inc_refcnt:
 	device->refcount++;
+out:
 	mutex_unlock(&ig.device_list_mutex);
 	return device;
 }
@@ -366,6 +366,12 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 	int    ret;
 
 	device = iser_device_find_by_ib_device(cma_id);
+	if (!device) {
+		iser_err("device lookup/creation failed\n");
+		iser_connect_error(cma_id);
+		return;
+	}
+
 	ib_conn = (struct iser_conn *)cma_id->context;
 	ib_conn->device = device;
 
@@ -374,7 +380,6 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		iser_err("resolve route failed: %d\n", ret);
 		iser_connect_error(cma_id);
 	}
-	return;
 }
 
 static void iser_route_handler(struct rdma_cm_id *cma_id)
-- 
1.5.4.1

