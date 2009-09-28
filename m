Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZI1ITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZI1ITf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZI1ITf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:19:35 -0400
Received: from server1.wserver.cz ([82.113.45.157]:44276 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZI1ITe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:19:34 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       linux-kernel@vger.kernel.org,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH v2 1/1] qla2xxx: Fix Null ptr dereference in fail path in queue create code
Date: Mon, 28 Sep 2009 10:19:36 +0200
Message-Id: <1254125976-11005-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Current code jumps to fail path in queue create functions and there it invokes
the queue free call with a (NULL) pointer to the queue which could not be
allocated. Fix it by returning ENOMEM directly without invoking the queue free
call.

[v2] use return 0 instead of return ENOMEM. Callers expect that.

Signed-off-by Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..005050e 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -568,7 +568,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	if (req == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory"
 			"for request que\n");
-		goto que_failed;
+		return 0;
 	}
 
 	req->length = REQUEST_ENTRY_CNT_24XX;
@@ -659,7 +659,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		return 0;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
-- 
1.6.4.2

