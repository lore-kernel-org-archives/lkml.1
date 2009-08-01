Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZHAI5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZHAI5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 04:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZHAI5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 04:57:45 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50934 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZHAI5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 04:57:44 -0400
Date: Sat, 1 Aug 2009 10:55:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/10] drivers/md: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0908011054440.23408@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/md/dm-exception-store.c     |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 3710ff8..ee68d17 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -217,7 +217,8 @@ int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 		type = get_type("N");
 	else {
 		ti->error = "Persistent flag is not P or N";
-		return -EINVAL;
+		r = -EINVAL;
+		goto bad_type;
 	}
 
 	if (!type) {
