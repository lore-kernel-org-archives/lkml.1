Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYJYT6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYJYT6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYJYT6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:58:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:56310 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYJYT6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gDvgVpmOt/U9MIfhyuSfl+6TeE00K4zmLNtfPwMJQ7YPi1EZp7D0S2yB43PUvMkq0H
         gMglxknOtUqCOD7jsb9fl0oqXriYiLAWzRCYlSboDGXq7OZWQoW2jMEnKhH9+XP5lyz+
         XbGp7S8xm7Tpb0Q9OQPlKaM1SbOEOfOQlPfjc=
Date: Sat, 25 Oct 2008 21:58:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] vgacon: remember scrollback buffer on console switch
Message-ID: <20081025195814.GD10932@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for persistent console history, surviving
console switches. It allocates new scrollback buffer only when
user switches console for the first time.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/console/Kconfig  |   11 ++++++
 drivers/video/console/vgacon.c |   75 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 2f50a80..09e3d98 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -43,6 +43,17 @@ config VGACON_SOFT_SCROLLBACK_SIZE
 	 buffer.  Each 64KB will give you approximately 16 80x25
 	 screenfuls of scrollback buffer
 
+config VGACON_REMEMBER_SCROLLBACK
+	bool "Remember scrollback buffer on console switch"
+	depends on VGACON_SOFT_SCROLLBACK
+	default y
+	help
+	 Say 'Y' here if you want the scrollback buffer to be remembered
+	 on console switch and restored when you switch back.
+
+	 Note: every VGA console will use its own buffer, but it will be
+	 allocated only when you switch to this console for the first time.
+
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
 	tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 448d209..15ee7e1 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -174,9 +174,11 @@ static int vgacon_scrollback_cur;
 static int vgacon_scrollback_save;
 static int vgacon_scrollback_restore;
 
+#define SCROLLBACK_SIZE (CONFIG_VGACON_SOFT_SCROLLBACK_SIZE * 1024)
+
 static void vgacon_scrollback_init(int pitch)
 {
-	int rows = CONFIG_VGACON_SOFT_SCROLLBACK_SIZE * 1024/pitch;
+	int rows = SCROLLBACK_SIZE / pitch;
 
 	if (vgacon_scrollback) {
 		vgacon_scrollback_cnt  = 0;
@@ -187,15 +189,76 @@ static void vgacon_scrollback_init(int pitch)
 	}
 }
 
+#ifdef CONFIG_VGACON_REMEMBER_SCROLLBACK
+static struct vgacon_scrollback_info {
+	void *data;
+	int cnt;
+	int tail;
+	int cur;
+	int rows;
+	int size;
+} vgacon_scrollbacks[MAX_NR_CONSOLES];
+static int vgacon_last_vc_num;
+
+static void vgacon_switch_scrollback(struct vc_data *c)
+{
+	int num = c->vc_num;
+	struct vgacon_scrollback_info *old_scrollback =
+				&vgacon_scrollbacks[vgacon_last_vc_num];
+	struct vgacon_scrollback_info *new_scrollback =
+				&vgacon_scrollbacks[num];
+
+	old_scrollback->cnt  = vgacon_scrollback_cnt;
+	old_scrollback->tail = vgacon_scrollback_tail;
+	old_scrollback->cur  = vgacon_scrollback_cur;
+	old_scrollback->rows = vgacon_scrollback_rows;
+	old_scrollback->size = vgacon_scrollback_size;
+
+	if (!new_scrollback->data) {
+		int rows = SCROLLBACK_SIZE / c->vc_size_row;
+
+		new_scrollback->data = kmalloc(SCROLLBACK_SIZE, GFP_KERNEL);
+		new_scrollback->cnt  = 0;
+		new_scrollback->tail = 0;
+		new_scrollback->cur  = 0;
+		new_scrollback->rows = rows - 1;
+		new_scrollback->size = rows * c->vc_size_row;
+
+		if (!new_scrollback->data) {
+			printk(KERN_WARNING "VGAcon: failed to allocate memory for scrollback of console %d, using scrollback of console %d.\n",
+						num, vgacon_last_vc_num);
+			new_scrollback->data = old_scrollback->data;
+			old_scrollback->data = NULL;
+		}
+	}
+
+	vgacon_scrollback      = new_scrollback->data;
+	vgacon_scrollback_cnt  = new_scrollback->cnt;
+	vgacon_scrollback_tail = new_scrollback->tail;
+	vgacon_scrollback_cur  = new_scrollback->cur;
+	vgacon_scrollback_rows = new_scrollback->rows;
+	vgacon_scrollback_size = new_scrollback->size;
+
+	vgacon_last_vc_num = num;
+}
+#else
+static inline void vgacon_switch_scrollback(struct vc_data *c)
+{
+	vgacon_scrollback_init(c->vc_size_row);
+}
+#endif
 /*
  * Called only duing init so call of alloc_bootmen is ok.
  * Marked __init_refok to silence modpost.
  */
 static void __init_refok vgacon_scrollback_startup(void)
 {
-	vgacon_scrollback = alloc_bootmem(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE
-					  * 1024);
+	vgacon_scrollback = alloc_bootmem(SCROLLBACK_SIZE);
 	vgacon_scrollback_init(vga_video_num_columns * 2);
+#ifdef CONFIG_VGACON_REMEMBER_SCROLLBACK
+	vgacon_scrollbacks[0].data = vgacon_scrollback;
+	vgacon_last_vc_num = 0;
+#endif
 }
 
 static void vgacon_scrollback_update(struct vc_data *c, int t, int count)
@@ -317,6 +380,10 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 #define vgacon_scrollback_init(...)    do { } while (0)
 #define vgacon_scrollback_update(...)  do { } while (0)
 
+static inline void vgacon_switch_scrollback(struct vc_data *c)
+{
+}
+
 static void vgacon_restore_screen(struct vc_data *c)
 {
 	if (c->vc_origin != c->vc_visible_origin)
@@ -823,7 +890,7 @@ static int vgacon_switch(struct vc_data *c)
 			vgacon_doresize(c, c->vc_cols, c->vc_rows);
 	}
 
-	vgacon_scrollback_init(c->vc_size_row);
+	vgacon_switch_scrollback(c);
 	return 0;		/* Redrawing not needed */
 }
 
-- 
1.5.6.4

