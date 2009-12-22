Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZLVUd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZLVUd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbZLVUdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:33:25 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43137 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZLVUdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:33:24 -0500
Date: Tue, 22 Dec 2009 21:33:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/6] drivers/video: Correct use after free
Message-ID: <Pine.LNX.4.64.0912222132290.28669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the case of igafb.c, the free appears to be part of cleanup code in the
case of an error.  The code afterwards under the #ifdef is not meaningful
in this case, because it extensively refers to structures that have been
freed.  Furthermore, this initialization function would seem to have failed
in the case where the kfrees are executed, so it does not seem reasonable
to return 0 in this case.  Some other errors in the course of the function
cause -ENOXIO to be returned, so that is added here.

In panel-sharp-ls037v7dw01.c, a variable is introduced to hold the error
code to return before freeing the structure that contains it.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x->f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 video/igafb.c                                  |    1 +
 video/omap2/displays/panel-sharp-ls037v7dw01.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/igafb.c b/drivers/video/igafb.c
index 15d2001..f18df8f 100644
--- a/drivers/video/igafb.c
+++ b/drivers/video/igafb.c
@@ -531,6 +531,7 @@ int __init igafb_init(void)
 		iounmap(info->screen_base);
 		kfree(par->mmap_map);
 		kfree(info);
+		return -ENXIO;
         }
 
 #ifdef CONFIG_SPARC
diff --git a/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c b/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
index bbe880b..8882535 100644
--- a/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
+++ b/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
@@ -51,6 +51,7 @@ static struct omap_video_timings sharp_ls_timings = {
 static int sharp_ls_panel_probe(struct omap_dss_device *dssdev)
 {
 	struct sharp_data *sd;
+	int err;
 
 	dssdev->panel.config = OMAP_DSS_LCD_TFT | OMAP_DSS_LCD_IVS |
 		OMAP_DSS_LCD_IHS;
@@ -65,9 +66,10 @@ static int sharp_ls_panel_probe(struct omap_dss_device *dssdev)
 
 	sd->vdvi_reg = regulator_get(&dssdev->dev, "vdvi");
 	if (IS_ERR(sd->vdvi_reg)) {
+		err = PTR_ERR(sd->vdvi_reg);
 		kfree(sd);
 		pr_err("failed to get VDVI regulator\n");
-		return PTR_ERR(sd->vdvi_reg);
+		return err;
 	}
 
 	return 0;
