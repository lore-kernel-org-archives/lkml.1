Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZHRDYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZHRDYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHRDYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:24:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:60455 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZHRDYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:24:23 -0400
From: Chunbo Luo <chunbo.luo@windriver.com>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Cc: chunbo.luo@windriver.com
Subject: [PATCH 1/2] sctp: fix heartbeat process for association
Date: Tue, 18 Aug 2009 11:24:15 +0800
Message-Id: <1250565856-18198-1-git-send-email-chunbo.luo@windriver.com>
X-Mailer: git-send-email 1.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC4960 Section 8.1 defined that the association should enter CLOSE
state when the value of association error counter exceeds the limit 
indicated in the protocol parameter 'Association.Max.Retrans'. This
means that the association should enter CLOSE state after max_retrans+1 
heartbeats are not acknowledged.

Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
---
 net/sctp/sm_statefuns.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7288192..90e4f06 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5190,7 +5190,7 @@ sctp_disposition_t sctp_sf_do_6_3_3_rtx(const struct sctp_endpoint *ep,
 
 	SCTP_INC_STATS(SCTP_MIB_T3_RTX_EXPIREDS);
 
-	if (asoc->overall_error_count >= asoc->max_retrans) {
+	if (asoc->overall_error_count > asoc->max_retrans) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
 				SCTP_ERROR(ETIMEDOUT));
 		/* CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
@@ -5404,7 +5404,7 @@ sctp_disposition_t sctp_sf_t2_timer_expire(const struct sctp_endpoint *ep,
 
 	((struct sctp_association *)asoc)->shutdown_retries++;
 
-	if (asoc->overall_error_count >= asoc->max_retrans) {
+	if (asoc->overall_error_count > asoc->max_retrans) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
 				SCTP_ERROR(ETIMEDOUT));
 		/* Note:  CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
@@ -5487,7 +5487,7 @@ sctp_disposition_t sctp_sf_t4_timer_expire(
 	 * RFC2960 [5] section 8.1 and 8.2.
 	 * association error counter is incremented in SCTP_CMD_STRIKE.
 	 */
-	if (asoc->overall_error_count >= asoc->max_retrans) {
+	if (asoc->overall_error_count > asoc->max_retrans) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
-- 
1.6.4

