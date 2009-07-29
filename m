Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZG2MP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZG2MP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZG2MPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:15:25 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:60446 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbZG2MPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:15:23 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Staging: hv: Remove typedef STORVSC_REQUEST and PSTORVSC_REQUEST
Date: Wed, 29 Jul 2009 14:10:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907291410.20138.npalix@diku.dk>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


typedef STORVSC_REQUEST and PSTORVSC_REQUEST are removed and their
usages are replace by the use of struct hv_storvsc_request and
struct hv_storvsc_request * respectively.

Here is the semantic patch generated to perform this transformation:
(http://coccinelle.lip6.fr/)

//<smpl>
@rm_STORVSC_REQUEST@
@@
-typedef struct _STORVSC_REQUEST
+struct hv_storvsc_request
{...}
-STORVSC_REQUEST
;

@rm_PSTORVSC_REQUEST@
@@
-typedef struct _STORVSC_REQUEST *PSTORVSC_REQUEST;
+struct hv_storvsc_request;

@fixtypedef_STORVSC_REQUEST@
typedef STORVSC_REQUEST;
@@
-STORVSC_REQUEST
+struct hv_storvsc_request

@fixstruct__STORVSC_REQUEST@
@@
struct
-_STORVSC_REQUEST
+hv_storvsc_request

@fixtypedef_PSTORVSC_REQUEST@
typedef PSTORVSC_REQUEST;
@@
-PSTORVSC_REQUEST
+struct hv_storvsc_request*
//</smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/StorVsc.c            |   10 +++++-----
 drivers/staging/hv/blkvsc_drv.c         |   18 +++++++++---------
 drivers/staging/hv/include/StorVscApi.h |   10 +++++-----
 drivers/staging/hv/storvsc_drv.c        |    6 +++---
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index bc313a6..5955999 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -43,7 +43,7 @@
 typedef struct _STORVSC_REQUEST_EXTENSION {
 	/* LIST_ENTRY						ListEntry; */
 
-	STORVSC_REQUEST					*Request;
+	struct hv_storvsc_request *Request;
 	struct hv_device *Device;
 
 	/* Synchronize the request/response if needed */
@@ -108,7 +108,7 @@ StorVscOnDeviceRemove(
 static int
 StorVscOnIORequest(
 	struct hv_device *Device,
-	STORVSC_REQUEST	*Request
+	struct hv_storvsc_request *Request
 	);
 
 static int
@@ -272,7 +272,7 @@ StorVscInitialize(
 	DPRINT_ENTER(STORVSC);
 
 	DPRINT_DBG(STORVSC, "sizeof(STORVSC_REQUEST)=%zd sizeof(STORVSC_REQUEST_EXTENSION)=%zd sizeof(VSTOR_PACKET)=%zd, sizeof(VMSCSI_REQUEST)=%zd",
-		sizeof(STORVSC_REQUEST), sizeof(STORVSC_REQUEST_EXTENSION), sizeof(VSTOR_PACKET), sizeof(VMSCSI_REQUEST));
+		sizeof(struct hv_storvsc_request), sizeof(STORVSC_REQUEST_EXTENSION), sizeof(VSTOR_PACKET), sizeof(VMSCSI_REQUEST));
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
 	ASSERT(storDriver->RingBufferSize >= (PAGE_SIZE << 1));
@@ -704,7 +704,7 @@ Description:
 int
 StorVscOnIORequest(
 	struct hv_device *Device,
-	STORVSC_REQUEST	*Request
+	struct hv_storvsc_request *Request
 	)
 {
 	STORVSC_DEVICE *storDevice;
@@ -822,7 +822,7 @@ StorVscOnIOCompletion(
 	STORVSC_REQUEST_EXTENSION *RequestExt
 	)
 {
-	STORVSC_REQUEST *request;
+	struct hv_storvsc_request *request;
 	STORVSC_DEVICE *storDevice;
 
 	DPRINT_ENTER(STORVSC);
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index c5f3ce9..9de9654 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -54,7 +54,7 @@ enum blkvsc_device_type {
 
 /*
  * This request ties the struct request and struct
- * blkvsc_request/STORVSC_REQUEST together A struct request may be
+ * blkvsc_request/hv_storvsc_request together A struct request may be
  * represented by 1 or more struct blkvsc_request
  */
 struct blkvsc_request_group {
@@ -85,7 +85,7 @@ struct blkvsc_request {
 	unsigned char cmd_len;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 
-	STORVSC_REQUEST		request;
+	struct hv_storvsc_request request;
 	/* !!!DO NOT ADD ANYTHING BELOW HERE!!! Otherwise, memory can overlap, because - */
 	/* The extension buffer falls right here and is pointed to by request.Extension; */
 };
@@ -132,11 +132,11 @@ static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg);
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
 			unsigned cmd, unsigned long argument);
 static void blkvsc_request(struct request_queue *queue);
-static void blkvsc_request_completion(STORVSC_REQUEST* request);
+static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev, struct request *req);
-static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req, void (*request_completion)(STORVSC_REQUEST*) );
+static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req, void (*request_completion)(struct hv_storvsc_request*) );
 static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req);
-static void blkvsc_cmd_completion(STORVSC_REQUEST* request);
+static void blkvsc_cmd_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev);
@@ -900,7 +900,7 @@ static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 	}
 }
 
-static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req, void (*request_completion)(STORVSC_REQUEST*) )
+static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req, void (*request_completion)(struct hv_storvsc_request*) )
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
 	struct device_context *device_ctx=blkdev->device_ctx;
@@ -909,7 +909,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req, void (*reque
 	STORVSC_DRIVER_OBJECT* storvsc_drv_obj = &blkvsc_drv_ctx->drv_obj;
 	int ret =0;
 
-	STORVSC_REQUEST *storvsc_req;
+	struct hv_storvsc_request *storvsc_req;
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - req %p type %s start_sector %lu count %ld offset %d len %d\n",
 		blkvsc_req,
@@ -1104,7 +1104,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev, struct request
 	return pending;
 }
 
-static void blkvsc_cmd_completion(STORVSC_REQUEST* request)
+static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req=(struct blkvsc_request*)request->Context;
 	struct block_device_context *blkdev = (struct block_device_context*)blkvsc_req->dev;
@@ -1127,7 +1127,7 @@ static void blkvsc_cmd_completion(STORVSC_REQUEST* request)
 	wake_up_interruptible(&blkvsc_req->wevent);
 }
 
-static void blkvsc_request_completion(STORVSC_REQUEST* request)
+static void blkvsc_request_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req=(struct blkvsc_request*)request->Context;
 	struct block_device_context *blkdev = (struct block_device_context*)blkvsc_req->dev;
diff --git a/drivers/staging/hv/include/StorVscApi.h b/drivers/staging/hv/include/StorVscApi.h
index f6c9742..5d72f29 100644
--- a/drivers/staging/hv/include/StorVscApi.h
+++ b/drivers/staging/hv/include/StorVscApi.h
@@ -51,13 +51,13 @@
 /* Fwd decl */
 
 /* struct VMBUS_CHANNEL; */
-typedef struct _STORVSC_REQUEST* PSTORVSC_REQUEST;
+struct hv_storvsc_request;
 
 
 /* Data types */
 
-typedef int (*PFN_ON_IO_REQUEST)(struct hv_device *Device, PSTORVSC_REQUEST Request);
-typedef void (*PFN_ON_IO_REQUEST_COMPLTN)(PSTORVSC_REQUEST Request);
+typedef int (*PFN_ON_IO_REQUEST)(struct hv_device *Device, struct hv_storvsc_request *Request);
+typedef void (*PFN_ON_IO_REQUEST_COMPLTN)(struct hv_storvsc_request *Request);
 
 typedef int (*PFN_ON_HOST_RESET)(struct hv_device *Device);
 typedef void (*PFN_ON_HOST_RESCAN)(struct hv_device *Device);
@@ -71,7 +71,7 @@ typedef enum _STORVSC_REQUEST_TYPE{
 } STORVSC_REQUEST_TYPE;
 
 
-typedef struct _STORVSC_REQUEST {
+struct hv_storvsc_request {
 	STORVSC_REQUEST_TYPE		Type;
 	u32					Host;
 	u32					Bus;
@@ -93,7 +93,7 @@ typedef struct _STORVSC_REQUEST {
 	void *					Extension;
 
 	MULTIPAGE_BUFFER		DataBuffer;
-} STORVSC_REQUEST;
+};
 
 
 /* Represents the block vsc driver */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 120ec52..9a7ebca 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -64,7 +64,7 @@ struct storvsc_cmd_request {
 	unsigned int bounce_sgl_count;
 	struct scatterlist	*bounce_sgl;
 
-	STORVSC_REQUEST		request;
+	struct hv_storvsc_request request;
 	/* !!!DO NOT ADD ANYTHING BELOW HERE!!! */
 	/* The extension buffer falls right here and is pointed to by request.Extension; */
 };
@@ -388,7 +388,7 @@ Name:	storvsc_commmand_completion()
 Desc:	Command completion processing
 
 --*/
-static void storvsc_commmand_completion(STORVSC_REQUEST* request)
+static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 {
 	struct storvsc_cmd_request *cmd_request = (struct storvsc_cmd_request*)request->Context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
@@ -667,7 +667,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd, void (*done)(struct scs
 	struct storvsc_driver_context *storvsc_drv_ctx = (struct storvsc_driver_context*)driver_ctx;
 	STORVSC_DRIVER_OBJECT* storvsc_drv_obj = &storvsc_drv_ctx->drv_obj;
 
-	STORVSC_REQUEST *request;
+	struct hv_storvsc_request *request;
 	struct storvsc_cmd_request *cmd_request;
 	unsigned int request_size=0;
 	int i;
-- 
1.6.0.4


-- 
Nicolas Palix
