Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbZJQGlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbZJQGlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZJQGlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:41:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39122 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZJQGlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:41:23 -0400
Date: Sat, 17 Oct 2009 08:41:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/14] drivers/video: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170840540.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on fbi is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/pxafb.c               |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 1820c4a..fe3172c 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1208,13 +1208,14 @@ static void setup_smart_timing(struct pxafb_info *fbi,
 static int pxafb_smart_thread(void *arg)
 {
 	struct pxafb_info *fbi = arg;
-	struct pxafb_mach_info *inf = fbi->dev->platform_data;
+	struct pxafb_mach_info *inf;
 
-	if (!fbi || !inf->smart_update) {
+	if (!fbi || !fbi->dev->platform_data->smart_update) {
 		pr_err("%s: not properly initialized, thread terminated\n",
 				__func__);
 		return -EINVAL;
 	}
+	inf = fbi->dev->platform_data;
 
 	pr_debug("%s(): task starting\n", __func__);
 
