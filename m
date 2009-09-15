Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbZIOUxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbZIOUxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758401AbZIOUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:53:38 -0400
Received: from mx1.riseup.net ([204.13.164.18]:49223 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374AbZIOUxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:53:37 -0400
X-Greylist: delayed 1094 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 16:53:37 EDT
From: Francisco Jerez <currojerez@riseup.net>
To: linux-kernel@vger.kernel.org
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, nouveau@lists.freedesktop.org
Subject: [PATCH] vgacon: Prevent vgacon_deinit from touching the hardware for inactive consoles.
Date: Tue, 15 Sep 2009 22:34:57 +0200
Message-Id: <1253046897-9981-1-git-send-email-currojerez@riseup.net>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon makes the (reasonable) assumption that it only needs to program
the hardware once, when fbcon_init() is called for the foreground
console. This doesn't always play well with vgacon because
vgacon_deinit() is only doing its job when the last console it owns is
closed (in most cases, that is *after* fbcon_init() has set the new
mode). Depending on the hardware this can cause the wrong framebuffer
location to be scanned out (e.g. reproduced on nv05 with the nouveau
framebuffer driver).

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
---
This makes me wonder if it's actually useful to restore the scanout
address on vgacon_deinit(). If it wasn't anymore, I guess the right
thing to do would be to just remove the offending lines...

 drivers/video/console/vgacon.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 59d7d5e..6bd75a9 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -590,12 +590,14 @@ static void vgacon_init(struct vc_data *c, int init)
 
 static void vgacon_deinit(struct vc_data *c)
 {
-	/* When closing the last console, reset video origin */
-	if (!--vgacon_uni_pagedir[1]) {
+	/* When closing the active console, reset video origin */
+	if (CON_IS_VISIBLE(c)) {
 		c->vc_visible_origin = vga_vram_base;
 		vga_set_mem_top(c);
-		con_free_unimap(c);
 	}
+
+	if (!--vgacon_uni_pagedir[1])
+		con_free_unimap(c);
 	c->vc_uni_pagedir_loc = &c->vc_uni_pagedir;
 	con_set_default_unimap(c);
 }
-- 
1.6.3.3

