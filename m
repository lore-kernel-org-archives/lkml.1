Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYIUQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYIUQBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYIUQAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:00:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:26019 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYIUQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vRtSvUdAtiFL58bwSCVJTSEx0qCY1rtT8oQ/TlmNCtrca2FtoD+KBrrT2zG5mvPuT8
         tEA82X3M1yNrJ/eRgKQiCm9NY0P8Ve62lESdirj9n0bE/QponPUPz8f+3iTV9PwfQSLg
         jF8J/5NvMXPN6oewKjOXZY+KbtxVUDcchoLbY=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 1/2] vgacon: optimize scrolling
Date: Sun, 21 Sep 2008 18:00:08 +0200
Message-Id: <1222012809-5783-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com>
References: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Join multiple scr_memcpyw into 1-3 calls (usually 2).
(benchmarked average speedup: 1%)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/console/vgacon.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index bd1f57b..de4f66c 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -292,23 +292,27 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 	d = (void *) c->vc_origin;
 	s = (void *) c->vc_screenbuf;
 
-	while (count--) {
-		scr_memcpyw(d, vgacon_scrollback + soff, c->vc_size_row);
-		d += c->vc_size_row;
-		soff += c->vc_size_row;
-
-		if (soff >= vgacon_scrollback_size)
-			soff = 0;
+	if (count) {
+		int copysize;
+		count *= c->vc_size_row;
+		/* how much memory to end of buffer left? */
+		copysize = min(count, vgacon_scrollback_size - soff);
+		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
+		d += copysize;
+		count -= copysize;
+		
+		if (count) {
+			copysize = min(count, vgacon_scrollback_size);
+			scr_memcpyw(d, vgacon_scrollback, copysize);
+			d += copysize;
+		}
 	}
 
 	if (diff == c->vc_rows) {
 		vgacon_cursor(c, CM_MOVE);
 	} else {
-		while (diff--) {
-			scr_memcpyw(d, s, c->vc_size_row);
-			d += c->vc_size_row;
-			s += c->vc_size_row;
-		}
+		if (diff)
+			scr_memcpyw(d, s, diff * c->vc_size_row);
 	}
 
 	return 1;
-- 
1.5.6.4

