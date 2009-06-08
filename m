Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZFHRUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZFHRUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZFHRTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:19:54 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43642 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753156AbZFHRTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:19:53 -0400
Message-Id: <20090608171950.161110000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:51 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 03/12] GRU - fix automatic retry of gru instruction failures
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_exception_retry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix bug in automatic retry of GRU instruction failures.
CBR substatus (message queue failure) was being checked
incorrectly.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukservices.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-04-29 13:41:24.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-04-29 13:43:32.000000000 -0500
@@ -436,11 +436,10 @@ static int gru_retry_exception(void *cb)
 	int retry = EXCEPTION_RETRY_LIMIT;
 
 	while (1)  {
-		if (gru_get_cb_message_queue_substatus(cb))
-			break;
 		if (gru_wait_idle_or_exception(gen) == CBS_IDLE)
 			return CBS_IDLE;
-
+		if (gru_get_cb_message_queue_substatus(cb))
+			return CBS_EXCEPTION;
 		gru_get_cb_exception_detail(cb, &excdet);
 		if ((excdet.ecause & ~EXCEPTION_RETRY_BITS) ||
 				(excdet.cbrexecstatus & CBR_EXS_ABORT_OCC))

