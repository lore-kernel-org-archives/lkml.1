Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYIUQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYIUQBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYIUQBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:01:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:22049 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYIUQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WI1yKwJdFITBtJk8t52Ef8DmCSbnzcMaauvvRHxodSBOFF6VCEB+kw+9Mn/9QIWTyQ
         2HRQS0KKwx6wazE6gcpZo/rB0oSFQ8N2+sXAsaBpwAoqUYvZKzL3rjcOqkW/oPs9h4NP
         bbeLIL4m6921NbB9WMri0QXYBfXzUzxRrLh68=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 2/2] vgacon: vgacon_scrolldelta simplification
Date: Sun, 21 Sep 2008 18:00:09 +0200
Message-Id: <1222012809-5783-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com>
References: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in checking diff == c->vc_rows, because it can be true
only when count == 0, but we already checked that.
Additionally move variables used only in one block to this block.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/console/vgacon.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index de4f66c..a785f99 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -239,8 +239,7 @@ static void vgacon_restore_screen(struct vc_data *c)
 
 static int vgacon_scrolldelta(struct vc_data *c, int lines)
 {
-	int start, end, count, soff, diff;
-	void *d, *s;
+	int start, end, count, soff;
 
 	if (!lines) {
 		c->vc_visible_origin = c->vc_origin;
@@ -287,13 +286,13 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 	if (count > c->vc_rows)
 		count = c->vc_rows;
 
-	diff = c->vc_rows - count;
-
-	d = (void *) c->vc_origin;
-	s = (void *) c->vc_screenbuf;
-
 	if (count) {
 		int copysize;
+		
+		int diff = c->vc_rows - count;
+		void *d = (void *) c->vc_origin;
+		void *s = (void *) c->vc_screenbuf;
+		
 		count *= c->vc_size_row;
 		/* how much memory to end of buffer left? */
 		copysize = min(count, vgacon_scrollback_size - soff);
@@ -306,14 +305,11 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 			scr_memcpyw(d, vgacon_scrollback, copysize);
 			d += copysize;
 		}
-	}
-
-	if (diff == c->vc_rows) {
-		vgacon_cursor(c, CM_MOVE);
-	} else {
+		
 		if (diff)
 			scr_memcpyw(d, s, diff * c->vc_size_row);
-	}
+	} else
+		vgacon_cursor(c, CM_MOVE);
 
 	return 1;
 }
-- 
1.5.6.4

