Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZHXJhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZHXJhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZHXJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:37:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:60859 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZHXJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:37:19 -0400
From: Chunbo Luo <chunbo.luo@windriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
       linux-kernel@vger.kernel.org, chunbo.luo@windriver.com
Subject: [PATCH v2] sctp: fix the check for path failure detection
Date: Mon, 24 Aug 2009 17:37:17 +0800
Message-Id: <1251106637-434-1-git-send-email-chunbo.luo@windriver.com>
X-Mailer: git-send-email 1.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The transport error count should be incremented when an outstanding
HB is not acknowledged. And the path failure detection should be done
before sending out the HB.

Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
---
 net/sctp/sm_sideeffect.c |    6 +++++-
 net/sctp/sm_statefuns.c  |    8 ++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 86426aa..fbdf4de 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -446,7 +446,11 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	if (transport->state != SCTP_UNCONFIRMED)
 		asoc->overall_error_count++;
 
-	if (transport->state != SCTP_INACTIVE &&
+	/*
+	 * The transport error count is incremented when an outstanding HB
+	 * is not acknowledged. 
+	 */
+	if (transport->hb_sent && transport->state != SCTP_INACTIVE &&
 	    (transport->error_count++ >= transport->pathmaxrxt)) {
 		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
 					 " transport IP: port:%d failed.\n",
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7288192..7f77099 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -981,10 +981,6 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 	 */
 
 	if (transport->param_flags & SPP_HB_ENABLE) {
-		if (SCTP_DISPOSITION_NOMEM ==
-				sctp_sf_heartbeat(ep, asoc, type, arg,
-						  commands))
-			return SCTP_DISPOSITION_NOMEM;
 		/* Set transport error counter and association error counter
 		 * when sending heartbeat.
 		 */
@@ -992,6 +988,10 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 				SCTP_TRANSPORT(transport));
 		sctp_add_cmd_sf(commands, SCTP_CMD_TRANSPORT_HB_SENT,
 				SCTP_TRANSPORT(transport));
+		if (SCTP_DISPOSITION_NOMEM ==
+				sctp_sf_heartbeat(ep, asoc, type, arg,
+						  commands))
+			return SCTP_DISPOSITION_NOMEM;
 	}
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMER_UPDATE,
 			SCTP_TRANSPORT(transport));
-- 
1.6.4

