Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYIUQCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYIUQCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYIUQCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:02:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:17105 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYIUQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FXSE64vRXD8MmlCsf3Equ+vt7cQXh3YMcsvqj38iAjgVIvMKSyRueSc+CprliNtmnU
         pmI7eU/PS01j8ZQLFDoC4fevAJCROl9C8acx2v6MAszCzsmm04gkbHYxzmK+LIJZxc2i
         U2pINsyth6ZInVYFaVf4czqR9nGhYfZ654flU=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] vgacon: remember scrollback buffer on console switch
Date: Sun, 21 Sep 2008 18:02:18 +0200
Message-Id: <1222012938-5829-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for persistent console history, surviving
console switches. It allocates new scrollback buffer only when
user switches console for the first time.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/console/Kconfig  |   11 ++++++
 drivers/video/console/vgacon.c |   75 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 06f87b0..9efb885 100644
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
 config VIDEO_SELECT
 	bool "Video mode selection support"
 	depends on  X86 && VGA_CONSOLE
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index a785f99..94ce971 100644
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
@@ -318,6 +381,10 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 #define vgacon_scrollback_init(...)    do { } while (0)
 #define vgacon_scrollback_update(...)  do { } while (0)
 
+static inline void vgacon_switch_scrollback(struct vc_data *c)
+{
+}
+
 static void vgacon_restore_screen(struct vc_data *c)
 {
 	if (c->vc_origin != c->vc_visible_origin)
@@ -824,7 +891,7 @@ static int vgacon_switch(struct vc_data *c)
 			vgacon_doresize(c, c->vc_cols, c->vc_rows);
 	}
 
-	vgacon_scrollback_init(c->vc_size_row);
+	vgacon_switch_scrollback(c);
 	return 0;		/* Redrawing not needed */
 }
 
-- 
1.5.6.4

