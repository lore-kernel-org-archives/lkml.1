Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbZIROaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbZIROaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZIROaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:30:17 -0400
Received: from mx1.riseup.net ([204.13.164.18]:33305 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZIROaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:30:16 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, nouveau@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: [PATCHv2] vgacon: Prevent vgacon_deinit from touching the hardware for inactive consoles.
Date: Fri, 18 Sep 2009 16:30:01 +0200
Message-Id: <1253284201-24866-1-git-send-email-currojerez@riseup.net>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253046897-9981-1-git-send-email-currojerez@riseup.net>
References: <1253046897-9981-1-git-send-email-currojerez@riseup.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon makes the (reasonable) assumption that it only needs to program
the hardware once, when fbcon_init() is called for the foreground
console. This doesn't always play well with vgacon because
vgacon_deinit() is only doing its job when the last console it owns is
closed (when switching from vgacon to fbcon, that's usually *after*
fbcon_init() has set the new mode). Depending on the hardware this can
cause the wrong framebuffer location to be scanned out
(e.g. reproduced on nv05 with the nouveau framebuffer driver).

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
---
Some minor stylistic changes WRT v1.

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

