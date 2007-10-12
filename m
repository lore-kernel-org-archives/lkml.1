Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXJLR0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXJLR0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762868AbXJLRXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:23:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762106AbXJLRXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:23:31 -0400
Date: Fri, 12 Oct 2007 18:23:23 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Dave Wysochanski <dwysocha@redhat.com>,
       Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [2.6.24 PATCH 23/25] dm mpath: hp retry if not ready
Message-ID: <20071012172323.GI24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Dave Wysochanski <dwysocha@redhat.com>,
	Chandra Seetharaman <sekharan@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

This patch adds retries to the hp hardware handler, and utilizes the 
MP_RETRY flag of dm-multipath.  For now in the hp handler, if we get a 
pg_init completed with a check condition we just assume we can retry the
pg_init command.  We make this assumption because of incomplete data on
specific check condition code of the HP hardware, and because testing
has shown the HP path initialization command to be idempotent.
The number of times we retry is settable via the "pg_init_retries"
multipath map feature.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-mpath-hp-sw.c |   64 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 11 deletions(-)

Index: linux-2.6.23/drivers/md/dm-mpath-hp-sw.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-mpath-hp-sw.c	2007-10-12 15:03:29.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-mpath-hp-sw.c	2007-10-12 15:03:31.000000000 +0100
@@ -18,19 +18,54 @@
 #include <linux/types.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 
 #include "dm.h"
 #include "dm-hw-handler.h"
 
 #define DM_MSG_PREFIX "multipath hp-sw"
 #define DM_HP_HWH_NAME "hp-sw"
-#define DM_HP_HWH_VER "0.0.3"
+#define DM_HP_HWH_VER "1.0.0"
 
 struct hp_sw_context {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
 /*
+ * hp_sw_error_is_retryable - Is an HP-specific check condition retryable?
+ * @req: path activation request
+ *
+ * Examine error codes of request and determine whether the error is retryable.
+ * Some error codes are already retried by scsi-ml (see
+ * scsi_decide_disposition), but some HP specific codes are not.
+ * The intent of this routine is to supply the logic for the HP specific
+ * check conditions.
+ *
+ * Returns:
+ *  1 - command completed with retryable error
+ *  0 - command completed with non-retryable error
+ *
+ * Possible optimizations
+ * 1. More hardware-specific error codes
+ */
+static int hp_sw_error_is_retryable(struct request *req)
+{
+	/*
+	 * NOT_READY is known to be retryable
+	 * For now we just dump out the sense data and call it retryable
+	 */
+	if (status_byte(req->errors) == CHECK_CONDITION)
+		__scsi_print_sense(DM_HP_HWH_NAME, req->sense, req->sense_len);
+
+	/*
+	 * At this point we don't have complete information about all the error
+	 * codes from this hardware, so we are just conservative and retry
+	 * when in doubt.
+	 */
+	return 1;
+}
+
+/*
  * hp_sw_end_io - Completion handler for HP path activation.
  * @req: path activation request
  * @error: scsi-ml error
@@ -40,23 +75,30 @@ struct hp_sw_context {
  *
  * Context: scsi-ml softirq
  *
- * Possible optimizations
- * 1. Actually check sense data for retryable error (e.g. NOT_READY)
  */
 static void hp_sw_end_io(struct request *req, int error)
 {
 	struct dm_path *path = req->end_io_data;
 	unsigned err_flags = 0;
 
-	if (!error)
+	if (!error) {
 		DMDEBUG("%s path activation command - success",
 			path->dev->name);
-	else {
-		DMWARN("%s path activation command - error=0x%x",
-		       path->dev->name, error);
-		err_flags = MP_FAIL_PATH;
+		goto out;
+	}
+
+	if (hp_sw_error_is_retryable(req)) {
+		DMDEBUG("%s path activation command - retry",
+			path->dev->name);
+		err_flags = MP_RETRY;
+		goto out;
 	}
 
+	DMWARN("%s path activation fail - error=0x%x",
+	       path->dev->name, error);
+	err_flags = MP_FAIL_PATH;
+
+out:
 	req->end_io_data = NULL;
 	__blk_put_request(req->q, req);
 	dm_pg_init_complete(path, err_flags);
@@ -135,7 +177,7 @@ static void hp_sw_pg_init(struct hw_hand
 	if (!req) {
 		DMERR("%s path activation command - allocation fail",
 		      path->dev->name);
-		goto fail;
+		goto retry;
 	}
 
 	DMDEBUG("%s path activation command - sent", path->dev->name);
@@ -143,8 +185,8 @@ static void hp_sw_pg_init(struct hw_hand
 	blk_execute_rq_nowait(req->q, NULL, req, 1, hp_sw_end_io);
 	return;
 
-fail:
-	dm_pg_init_complete(path, MP_FAIL_PATH);
+retry:
+	dm_pg_init_complete(path, MP_RETRY);
 }
 
 static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
