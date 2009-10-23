Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZJWSOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZJWSOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZJWSOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:14:23 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:10356 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZJWSOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:14:22 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'gregkh@suse.de'" <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: hv: Fix null pointer error after vmbus loading
Thread-Topic: [PATCH] Staging: hv: Fix null pointer error after vmbus loading
Thread-Index: AQHKVAynh954eJTm40CVee2ubXphEQ==
Date: Fri, 23 Oct 2009 18:14:24 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72180B4422@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix null pointer error after vmbus loading. Remove code that checks for dev_name, the affected structure is kzalloc-ed prior to this routine, so it is always null at this stage.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 582318f..1c7f887 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -537,18 +537,7 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
 	DPRINT_DBG(VMBUS_DRV, "child device (%p) registering",
 		   child_device_ctx);
 
-	/* Make sure we are not registered already */
-	if (strlen(dev_name(&child_device_ctx->device)) != 0) {
-		DPRINT_ERR(VMBUS_DRV,
-			   "child device (%p) already registered - busid %s",
-			   child_device_ctx,
-			   dev_name(&child_device_ctx->device));
-
-		ret = -1;
-		goto Cleanup;
-	}
-
-	/* Set the device bus id. Otherwise, device_register()will fail. */
+	/* Set the device name. Otherwise, device_register()will fail. */
 	dev_set_name(&child_device_ctx->device, "vmbus_0_%d",
 		     atomic_inc_return(&device_num));
 
@@ -573,7 +562,6 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
 		DPRINT_INFO(VMBUS_DRV, "child device (%p) registered",
 			    &child_device_ctx->device);
 
-Cleanup:
 	DPRINT_EXIT(VMBUS_DRV);
 
 	return ret;
