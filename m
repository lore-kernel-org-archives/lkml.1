Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZBHVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZBHVqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZBHVp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:45:57 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55192 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbZBHVp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:45:56 -0500
Date: Sun, 8 Feb 2009 22:45:53 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/6] fs/btrfs/volumes.c: remove useless kzalloc
Message-ID: <Pine.LNX.4.64.0902082245250.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The call to kzalloc is followed by a kmalloc whose result is stored in the
same variable.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
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
 fs/btrfs/volumes.c                  |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3451e1c..f1a0eee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2905,10 +2905,6 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		free_extent_map(em);
 	}
 
-	map = kzalloc(sizeof(*map), GFP_NOFS);
-	if (!map)
-		return -ENOMEM;
-
 	em = alloc_extent_map(GFP_NOFS);
 	if (!em)
 		return -ENOMEM;
