Return-Path: <linux-kernel-owner+w=401wt.eu-S1764562AbZCaXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764562AbZCaXYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761822AbZCaXUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:32 -0400
Received: from sous-sol.org ([216.99.217.87]:33144 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757275AbZCaXU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:29 -0400
Message-Id: <20090331231634.779657354@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: [patch 28/45] ARM: pxa: fix overlay being un-necessarily initialized on pxa25x
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=arm-pxa-fix-overlay-being-un-necessarily-initialized-on-pxa25x.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Miao <eric.miao@marvell.com>

upstream commit: 782385ae176b304c7105051e1b06c68bc0b4a2ba

pxa25x doesn't support overlay in its LCD controller, this patch adds
pxafb_overlay_supported() functions to check the initialization is
necessary.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/video/pxafb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -883,10 +883,21 @@ static void __devinit init_pxafb_overlay
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
@@ -909,6 +920,9 @@ static void __devexit pxafb_overlay_exit
 {
 	int i;
 
+	if (!pxafb_overlay_supported())
+		return;
+
 	for (i = 0; i < 2; i++)
 		unregister_framebuffer(&fbi->overlay[i].fb);
 }

