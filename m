Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZC2Ix0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZC2Ix0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZC2IxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:53:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40091 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZC2IxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:53:05 -0400
References: <git-1238272225-c68ffddabcaaa64c6ea681d2944cbda50a8654ea@dyn-67.arm.linux.org.uk>
Message-ID: <git-1238272225-782385ae176b304c7105051e1b06c68bc0b4a2ba@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: stable@kernel.org,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Mar 2009 20:30:25 +0000
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] pxa: fix overlay being un-necessarily initialized on pxa25x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

pxa25x doesn't support overlay in its LCD controller, this patch adds
pxafb_overlay_supported() functions to check the initialization is
necessary.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/video/pxafb.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 48ff701..40a5d9d 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -883,10 +883,21 @@ static void __devinit init_pxafb_overlay(struct pxafb_info *fbi,
 	init_completion(&ofb->branch_done);
 }
 
+static inline int pxafb_overlay_supported(void)
+{
+	if (cpu_is_pxa27x() || cpu_is_pxa3xx())
+		return 1;
+
+	return 0;
+}
+
 static int __devinit pxafb_overlay_init(struct pxafb_info *fbi)
 {
 	int i, ret;
 
+	if (!pxafb_overlay_supported())
+		return 0;
+
 	for (i = 0; i < 2; i++) {
 		init_pxafb_overlay(fbi, &fbi->overlay[i], i);
 		ret = register_framebuffer(&fbi->overlay[i].fb);
@@ -909,6 +920,9 @@ static void __devexit pxafb_overlay_exit(struct pxafb_info *fbi)
 {
 	int i;
 
+	if (!pxafb_overlay_supported())
+		return;
+
 	for (i = 0; i < 2; i++)
 		unregister_framebuffer(&fbi->overlay[i].fb);
 }
