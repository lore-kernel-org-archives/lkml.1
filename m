Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYI3Hmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYI3Hmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYI3Hlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:41:52 -0400
Received: from smtp.nokia.com ([192.100.122.233]:41728 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYI3Hls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:41:48 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: improve znode splitting rules
Date: Tue, 30 Sep 2008 12:19:03 +0300
Message-Id: <1222766358-21886-8-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0709 (UTC) FILETIME=[F7C2E750:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

When inserting into a full znode it is split into two
znodes.  Because data node keys are usually consecutive,
it is better to try to keep them together.  This patch
does a better job of that.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/tnc.c |   54 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 66dc571..e0878a4 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1962,7 +1962,7 @@ static int tnc_insert(struct ubifs_info *c, struct ubifs_znode *znode,
 {
 	struct ubifs_znode *zn, *zi, *zp;
 	int i, keep, move, appending = 0;
-	union ubifs_key *key = &zbr->key;
+	union ubifs_key *key = &zbr->key, *key1;
 
 	ubifs_assert(n >= 0 && n <= c->fanout);
 
@@ -2003,20 +2003,33 @@ again:
 	zn->level = znode->level;
 
 	/* Decide where to split */
-	if (znode->level == 0 && n == c->fanout &&
-	    key_type(c, key) == UBIFS_DATA_KEY) {
-		union ubifs_key *key1;
-
-		/*
-		 * If this is an inode which is being appended - do not split
-		 * it because no other zbranches can be inserted between
-		 * zbranches of consecutive data nodes anyway.
-		 */
-		key1 = &znode->zbranch[n - 1].key;
-		if (key_inum(c, key1) == key_inum(c, key) &&
-		    key_type(c, key1) == UBIFS_DATA_KEY &&
-		    key_block(c, key1) == key_block(c, key) - 1)
-			appending = 1;
+	if (znode->level == 0 && key_type(c, key) == UBIFS_DATA_KEY) {
+		/* Try not to split consecutive data keys */
+		if (n == c->fanout) {
+			key1 = &znode->zbranch[n - 1].key;
+			if (key_inum(c, key1) == key_inum(c, key) &&
+			    key_type(c, key1) == UBIFS_DATA_KEY)
+				appending = 1;
+		} else
+			goto check_split;
+	} else if (appending && n != c->fanout) {
+		/* Try not to split consecutive data keys */
+		appending = 0;
+check_split:
+		if (n >= (c->fanout + 1) / 2) {
+			key1 = &znode->zbranch[0].key;
+			if (key_inum(c, key1) == key_inum(c, key) &&
+			    key_type(c, key1) == UBIFS_DATA_KEY) {
+				key1 = &znode->zbranch[n].key;
+				if (key_inum(c, key1) != key_inum(c, key) ||
+				    key_type(c, key1) != UBIFS_DATA_KEY) {
+					keep = n;
+					move = c->fanout - keep;
+					zi = znode;
+					goto do_split;
+				}
+			}
+		}
 	}
 
 	if (appending) {
@@ -2046,6 +2059,8 @@ again:
 			zbr->znode->parent = zn;
 	}
 
+do_split:
+
 	__set_bit(DIRTY_ZNODE, &zn->flags);
 	atomic_long_inc(&c->dirty_zn_cnt);
 
@@ -2072,14 +2087,11 @@ again:
 
 	/* Insert new znode (produced by spitting) into the parent */
 	if (zp) {
-		i = n;
+		if (n == 0 && zi == znode && znode->iip == 0)
+			correct_parent_keys(c, znode);
+
 		/* Locate insertion point */
 		n = znode->iip + 1;
-		if (appending && n != c->fanout)
-			appending = 0;
-
-		if (i == 0 && zi == znode && znode->iip == 0)
-			correct_parent_keys(c, znode);
 
 		/* Tail recursion */
 		zbr->key = zn->zbranch[0].key;
-- 
1.5.4.1

