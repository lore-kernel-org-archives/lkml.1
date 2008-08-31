Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbYHaNPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbYHaNPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbYHaNOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:14:45 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61150 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802AbYHaNOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:14:44 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: always read hashed-key nodes under TNC mutex
Date: Sun, 31 Aug 2008 17:52:36 +0300
Message-Id: <1220194366-12731-3-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0509 (UTC) FILETIME=[7DB37950:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Leaf-nodes that have a hashed key are stored in the
leaf-node-cache (LNC) which is protected by the TNC
mutex.  Consequently, when reading a leaf node with
a hashed key (i.e. directory entries, xattr entries)
the TNC mutex is always required.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/tnc.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index e909f4a..4fbc592 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1498,7 +1498,6 @@ static int do_lookup_nm(struct ubifs_info *c, const union ubifs_key *key,
 {
 	int found, n, err;
 	struct ubifs_znode *znode;
-	struct ubifs_zbranch zbr;
 
 	dbg_tnc("name '%.*s' key %s", nm->len, nm->name, DBGKEY(key));
 	mutex_lock(&c->tnc_mutex);
@@ -1522,11 +1521,7 @@ static int do_lookup_nm(struct ubifs_info *c, const union ubifs_key *key,
 		goto out_unlock;
 	}
 
-	zbr = znode->zbranch[n];
-	mutex_unlock(&c->tnc_mutex);
-
-	err = tnc_read_node_nm(c, &zbr, node);
-	return err;
+	err = tnc_read_node_nm(c, &znode->zbranch[n], node);
 
 out_unlock:
 	mutex_unlock(&c->tnc_mutex);
-- 
1.5.4.1

