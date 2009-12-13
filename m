Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZLMLmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZLMLmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZLMLmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:42:46 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:39728 "HELO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752679AbZLMLmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:42:44 -0500
Date: Sun, 13 Dec 2009 12:42:41 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: JosephChan@via.com.tw, Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/9] drivers/video: Correct code taking the size of a pointer
Message-ID: <Pine.LNX.4.64.0912131242240.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(viafb_gamma_table) is just the size of the pointer.  This is changed
to the size used when calling kmalloc to initialize the pointer.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/via/viafbdev.c        |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 56ec696..a0b47f1 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -680,7 +680,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		if (!viafb_gamma_table)
 			return -ENOMEM;
 		if (copy_from_user(viafb_gamma_table, argp,
-				sizeof(viafb_gamma_table))) {
+				256 * sizeof(u32))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
@@ -694,7 +694,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 			return -ENOMEM;
 		viafb_get_gamma_table(viafb_gamma_table);
 		if (copy_to_user(argp, viafb_gamma_table,
-			sizeof(viafb_gamma_table))) {
+			256 * sizeof(u32))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
