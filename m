Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZL1PzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZL1PzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZL1PzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:55:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53305 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZL1PzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:55:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qsHKKt1tOY2gUiiubwMnq4I6911VvGd5+PGul0svMeGJVUWFRy56LMdLl1DQZ/ZyoK
         gpfGnA7S4FuGDLXmTfgpWKzmzUt+EWJUeGNEvDswlEkNQpe+U+GOxm+chNhsZGNF33fu
         JkPlF9pYg/UiNULJ2fYyBAqZMRMbp1yeCDmZI=
From: Martin Jansa <martin.jansa@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia@diku.dk>, Martin Jansa <Martin.Jansa@gmail.com>
Subject: [PATCH] pxafb: fix regression from d2a34c13e7ccec5d06eafd60e6f80ea531b34668
Date: Mon, 28 Dec 2009 16:54:43 +0100
Message-Id: <1262015683-1711-1-git-send-email-Martin.Jansa@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbi->dev->platform_data is void * and gcc does not allow to access
!fbi->dev->platform_data->smart_update without cast platform_data to
(struct pxafb_mach_info) or assignment as used in this patch.

Signed-off-by: Martin Jansa <Martin.Jansa@gmail.com>
---
 drivers/video/pxafb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 415858b..241468c 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1223,12 +1223,17 @@ static int pxafb_smart_thread(void *arg)
 	struct pxafb_info *fbi = arg;
 	struct pxafb_mach_info *inf;
 
-	if (!fbi || !fbi->dev->platform_data->smart_update) {
+	if (!fbi) {
 		pr_err("%s: not properly initialized, thread terminated\n",
 				__func__);
 		return -EINVAL;
 	}
 	inf = fbi->dev->platform_data;
+	if (!inf || !inf->smart_update) {
+		pr_err("%s: not properly initialized, thread terminated\n",
+				__func__);
+		return -EINVAL;
+	}
 
 	pr_debug("%s(): task starting\n", __func__);
 
-- 
1.6.6

