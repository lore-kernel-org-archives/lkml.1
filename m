Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZFHRVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZFHRVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZFHRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:05 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43654 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753534AbZFHRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:04 -0400
Message-Id: <20090608172002.180226000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:54 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 06/12] GRU - cleanup gru inline functions
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_instruction_wait
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Cleanup of GRU inline functions to eliminate unnecessary
inline code. Update function descriptions.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru_instructions.h |   33 +++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-04-29 13:40:17.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2009-04-29 13:44:25.000000000 -0500
@@ -623,9 +623,11 @@ static inline int gru_get_cb_substatus(v
 	return cbs->isubstatus;
 }
 
-/* Check the status of a CB. If the CB is in UPM mode, call the
- * OS to handle the UPM status.
- * Returns the CB status field value (0 for normal completion)
+/*
+ * User interface to check an instruction status. UPM and exceptions
+ * are handled automatically. However, this function does NOT wait
+ * for an active instruction to complete.
+ *
  */
 static inline int gru_check_status(void *cb)
 {
@@ -633,34 +635,31 @@ static inline int gru_check_status(void 
 	int ret;
 
 	ret = cbs->istatus;
-	if (ret == CBS_CALL_OS)
+	if (ret != CBS_ACTIVE)
 		ret = gru_check_status_proc(cb);
 	return ret;
 }
 
-/* Wait for CB to complete.
- * Returns the CB status field value (0 for normal completion)
+/*
+ * User interface (via inline function) to wait for an instruction
+ * to complete. Completion status (IDLE or EXCEPTION is returned
+ * to the user. Exception due to hardware errors are automatically
+ * retried before returning an exception.
+ *
  */
 static inline int gru_wait(void *cb)
 {
-	struct gru_control_block_status *cbs = (void *)cb;
-	int ret = cbs->istatus;
-
-	if (ret != CBS_IDLE)
-		ret = gru_wait_proc(cb);
-	return ret;
+	return gru_wait_proc(cb);
 }
 
-/* Wait for CB to complete. Aborts program if error. (Note: error does NOT
+/*
+ * Wait for CB to complete. Aborts program if error. (Note: error does NOT
  * mean TLB mis - only fatal errors such as memory parity error or user
  * bugs will cause termination.
  */
 static inline void gru_wait_abort(void *cb)
 {
-	struct gru_control_block_status *cbs = (void *)cb;
-
-	if (cbs->istatus != CBS_IDLE)
-		gru_wait_abort_proc(cb);
+	gru_wait_abort_proc(cb);
 }
 
 

