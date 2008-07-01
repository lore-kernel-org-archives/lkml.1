Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYGAMyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYGAMyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbYGAMur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:50:47 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:27858 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbYGAMup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:50:45 -0400
Message-Id: <20080701124959.399733091@de.ibm.com>
References: <20080701124809.319736054@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Jul 2008 14:48:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 08/14] cio: suppress chpid event in case of configure error
Content-Disposition: inline; filename=127-cio-suppress.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Do not send CHP_ONLINE/CHP_OFFLINE events to subchannel drivers when a
channel-path configure request failed.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chp.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: quilt-2.6/drivers/s390/cio/chp.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/chp.c
+++ quilt-2.6/drivers/s390/cio/chp.c
@@ -624,6 +624,7 @@ static void cfg_func(struct work_struct 
 {
 	struct chp_id chpid;
 	enum cfg_task_t t;
+	int rc;
 
 	mutex_lock(&cfg_lock);
 	t = cfg_none;
@@ -638,14 +639,24 @@ static void cfg_func(struct work_struct 
 
 	switch (t) {
 	case cfg_configure:
-		sclp_chp_configure(chpid);
-		info_expire();
-		chsc_chp_online(chpid);
+		rc = sclp_chp_configure(chpid);
+		if (rc)
+			CIO_MSG_EVENT(2, "chp: sclp_chp_configure(%x.%02x)="
+				      "%d\n", chpid.cssid, chpid.id, rc);
+		else {
+			info_expire();
+			chsc_chp_online(chpid);
+		}
 		break;
 	case cfg_deconfigure:
-		sclp_chp_deconfigure(chpid);
-		info_expire();
-		chsc_chp_offline(chpid);
+		rc = sclp_chp_deconfigure(chpid);
+		if (rc)
+			CIO_MSG_EVENT(2, "chp: sclp_chp_deconfigure(%x.%02x)="
+				      "%d\n", chpid.cssid, chpid.id, rc);
+		else {
+			info_expire();
+			chsc_chp_offline(chpid);
+		}
 		break;
 	case cfg_none:
 		/* Get updated information after last change. */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

