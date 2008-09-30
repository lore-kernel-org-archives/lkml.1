Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYI3HoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYI3HoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYI3HmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:01 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58929 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYI3Hl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:41:56 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: use an IS_ERR test rather than a NULL test
Date: Tue, 30 Sep 2008 12:19:00 +0300
Message-Id: <1222766358-21886-5-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0631 (UTC) FILETIME=[F7B70070:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function kthread_create returns an ERR pointer,
but never returns a NULL pointer. So a NULL test that comes before an
IS_ERR test should be deleted.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = kthread_create(...)
... when != x = E
* if (x == NULL)
S1 else S2
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 667c72d..d87b0cf 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1032,8 +1032,6 @@ static int mount_ubifs(struct ubifs_info *c)
 
 		/* Create background thread */
 		c->bgt = kthread_create(ubifs_bg_thread, c, c->bgt_name);
-		if (!c->bgt)
-			c->bgt = ERR_PTR(-EINVAL);
 		if (IS_ERR(c->bgt)) {
 			err = PTR_ERR(c->bgt);
 			c->bgt = NULL;
@@ -1347,8 +1345,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 
 	/* Create background thread */
 	c->bgt = kthread_create(ubifs_bg_thread, c, c->bgt_name);
-	if (!c->bgt)
-		c->bgt = ERR_PTR(-EINVAL);
 	if (IS_ERR(c->bgt)) {
 		err = PTR_ERR(c->bgt);
 		c->bgt = NULL;
-- 
1.5.4.1

