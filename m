Return-Path: <linux-kernel-owner+w=401wt.eu-S1751577AbZG3ORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbZG3ORR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZG3ORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:17:16 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:49999 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZG3ORP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:17:15 -0400
Date: Thu, 30 Jul 2009 16:08:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] fs/hppfs: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0907301607550.8734@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the result of kmalloc using a ! test, as most commonly done elsewhere,
rather than a test on 0.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/hppfs/hppfs.c                    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index a5089a6..b705a3c 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -385,7 +385,7 @@ static struct hppfs_data *hppfs_get_data(int fd, int filter,
 			break;
 
 		new = kmalloc(sizeof(*data), GFP_KERNEL);
-		if (new == 0) {
+		if (!new) {
 			printk(KERN_ERR "hppfs_get_data : data allocation "
 			       "failed\n");
 			err = -ENOMEM;
