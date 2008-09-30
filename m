Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYI3Hti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYI3Hti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYI3Hmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:53 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58943 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYI3Hl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:41:59 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: allow for sync_fs when read-only
Date: Tue, 30 Sep 2008 12:19:13 +0300
Message-Id: <1222766358-21886-18-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:37.0772 (UTC) FILETIME=[F8651AC0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

sync_fs can be called even if the file system is mounted
read-only.  Ensure the commit is not run in that case.

Reported-by: Zoltan Sogor <weth@inf.u-szeged.hu>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/super.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 7e1f3ef..7fd759d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -420,21 +420,22 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
 	int i, ret = 0, err;
 	long long bud_bytes;
 
-	if (c->jheads)
+	if (c->jheads) {
 		for (i = 0; i < c->jhead_cnt; i++) {
 			err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
 			if (err && !ret)
 				ret = err;
 		}
 
-	/* Commit the journal unless it has too few data */
-	spin_lock(&c->buds_lock);
-	bud_bytes = c->bud_bytes;
-	spin_unlock(&c->buds_lock);
-	if (bud_bytes > c->leb_size) {
-		err = ubifs_run_commit(c);
-		if (err)
-			return err;
+		/* Commit the journal unless it has too little data */
+		spin_lock(&c->buds_lock);
+		bud_bytes = c->bud_bytes;
+		spin_unlock(&c->buds_lock);
+		if (bud_bytes > c->leb_size) {
+			err = ubifs_run_commit(c);
+			if (err)
+				return err;
+		}
 	}
 
 	/*
-- 
1.5.4.1

