Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYCYPa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYCYPa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYCYPaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:30:11 -0400
Received: from mail.queued.net ([207.210.101.209]:3427 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbYCYPaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:30:10 -0400
Date: Tue, 25 Mar 2008 11:30:34 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH] gxfb: two suspend/resume fixes
Message-ID: <20080325113034.489d8643@ephemeral>
In-Reply-To: <20080311181807.454effb7@ephemeral>
References: <20080311181807.454effb7@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Can you please also add/merge this patch as well?  It fixes bugs in
gxfb-add-power-management-functionality.patch (currently in your tree).




Two suspend/resume fixes:
  - we weren't saving/restoring the palette correctly; I wasn't setting
    PAL_ADDRESS correctly.
  - the original GP restore code had an off-by-one bug that I happily
    reproduced in this code.  This fixes that, which fixes the RASTER_MODE
    register not getting set.

And drop an unnecessary comment.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/suspend_gx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/geode/suspend_gx.c b/drivers/video/geode/suspend_gx.c
index bc1f2b9..9aff32e 100644
--- a/drivers/video/geode/suspend_gx.c
+++ b/drivers/video/geode/suspend_gx.c
@@ -39,7 +39,7 @@ static void gx_save_regs(struct gxfb_par *par)
 	memcpy(par->fp, par->vid_regs + VP_FP_START, sizeof(par->fp));
 
 	/* save the palette */
-	write_gp(par, DC_PAL_ADDRESS, 0);
+	write_dc(par, DC_PAL_ADDRESS, 0);
 	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
 		par->pal[i] = read_dc(par, DC_PAL_DATA);
 }
@@ -73,10 +73,10 @@ static void gx_restore_gfx_proc(struct gxfb_par *par)
 
 	for (i = 0; i < ARRAY_SIZE(par->gp); i++) {
 		switch (i) {
-		case GP_RASTER_MODE:
 		case GP_VECTOR_MODE:
 		case GP_BLT_MODE:
 		case GP_BLT_STATUS:
+		case GP_HST_SRC:
 			/* don't restore these registers */
 			break;
 		default:
@@ -130,7 +130,7 @@ static void gx_restore_display_ctlr(struct gxfb_par *par)
 	}
 
 	/* restore the palette */
-	write_gp(par, DC_PAL_ADDRESS, 0);
+	write_dc(par, DC_PAL_ADDRESS, 0);
 	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
 		write_dc(par, DC_PAL_DATA, par->pal[i]);
 }
@@ -163,7 +163,7 @@ static void gx_restore_video_proc(struct gxfb_par *par)
 		case VP_RSVD_3:
 		case VP_CRC32:
 		case VP_AWT:
-		case VP_VTM:    /* this is r/w, shouldn't we restore?  -dil */
+		case VP_VTM:
 			/* don't restore these registers */
 			break;
 		default:
-- 
1.5.3.7

