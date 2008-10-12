Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbYJLRr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbYJLRr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 13:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYJLRrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 13:47:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53222 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbYJLRrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 13:47:16 -0400
Date: Sun, 12 Oct 2008 18:47:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com
Subject: [PATCH] Add KD_X console mode to avoid keyboard passthrough
Message-ID: <20081012174710.GA5206@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the evdev input driver, X currently claims the devices 
exclusively in order to prevent characters leaking through to the 
underlying VT. This has the downside that other consumers of input 
events no longer receive the keys - rfkill and mouseemu no longer work 
in the kernel, and hal is unable to pass through input events. Removing 
the exclusive access results in events being passed through to the 
underlying VT, which may result in leaking sensitive information.

This patch adds an extra KD_X mode. It's semantically identical to 
KD_GRAPHICS, except that keyboard events are no longer sent to the 
console device. This allows X to avoid exclusive access without breaking 
any applications which depend upon the existing KD_GRAPHICS semantics.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 7b3a212..b0b8285 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1298,6 +1298,10 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 static void kbd_event(struct input_handle *handle, unsigned int event_type,
 		      unsigned int event_code, int value)
 {
+	struct vc_data *vc = vc_cons[fg_console].d;
+
+	if (vc->vc_mode == KD_X)
+		return;
 	if (event_type == EV_MSC && event_code == MSC_RAW && HW_RAW(handle->dev))
 		kbd_rawcode(value);
 	if (event_type == EV_KEY)
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 60359c3..1f56eab 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -601,7 +601,8 @@ static void hide_cursor(struct vc_data *vc)
 static void set_cursor(struct vc_data *vc)
 {
 	if (!IS_FG(vc) || console_blanked ||
-	    vc->vc_mode == KD_GRAPHICS)
+	    vc->vc_mode == KD_GRAPHICS ||
+	    vc->vc_mode == KD_X)
 		return;
 	if (vc->vc_deccm) {
 		if (vc == sel_cons)
@@ -696,7 +697,8 @@ void redraw_screen(struct vc_data *vc, int is_switch)
 			update_attr(vc);
 			clear_buffer_attributes(vc);
 		}
-		if (update && vc->vc_mode != KD_GRAPHICS)
+		if (update && vc->vc_mode != KD_GRAPHICS &&
+			vc->vc_mode != KD_X)
 			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 	}
 	set_cursor(vc);
@@ -790,7 +792,8 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
 	/* Resizes the resolution of the display adapater */
 	int err = 0;
 
-	if (vc->vc_mode != KD_GRAPHICS && vc->vc_sw->con_resize)
+	if (vc->vc_mode != KD_GRAPHICS && vc->vc_mode != KD_X &&
+	    vc->vc_sw->con_resize)
 		err = vc->vc_sw->con_resize(vc, width, height, user);
 
 	return err;
@@ -2426,7 +2429,8 @@ int set_console(int nr)
 	struct vc_data *vc = vc_cons[fg_console].d;
 
 	if (!vc_cons_allocated(nr) || vt_dont_switch ||
-		(vc->vt_mode.mode == VT_AUTO && vc->vc_mode == KD_GRAPHICS)) {
+	    (vc->vt_mode.mode == VT_AUTO && (vc->vc_mode == KD_GRAPHICS ||
+					     vc->vc_mode == KD_X))) {
 
 		/*
 		 * Console switch will fail in console_callback() or
@@ -3098,7 +3102,8 @@ static int con_is_graphics(const struct consw *csw, int first, int last)
 	for (i = first; i <= last; i++) {
 		struct vc_data *vc = vc_cons[i].d;
 
-		if (vc && vc->vc_mode == KD_GRAPHICS) {
+		if (vc && (vc->vc_mode == KD_GRAPHICS ||
+			   vc->vc_mode == KD_X)) {
 			retval = 1;
 			break;
 		}
@@ -3759,7 +3764,9 @@ void poke_blanked_console(void)
 	del_timer(&console_timer);
 	blank_timer_expired = 0;
 
-	if (ignore_poke || !vc_cons[fg_console].d || vc_cons[fg_console].d->vc_mode == KD_GRAPHICS)
+	if (ignore_poke || !vc_cons[fg_console].d ||
+	    vc_cons[fg_console].d->vc_mode == KD_GRAPHICS ||
+	    vc_cons[fg_console].d->vc_mode == KD_X)
 		return;
 	if (console_blanked)
 		unblank_screen();
@@ -3777,7 +3784,7 @@ static void set_palette(struct vc_data *vc)
 {
 	WARN_CONSOLE_UNLOCKED();
 
-	if (vc->vc_mode != KD_GRAPHICS)
+	if (vc->vc_mode != KD_GRAPHICS && vc->vc_mode != KD_X)
 		vc->vc_sw->con_set_palette(vc, color_table);
 }
 
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c904e9a..899d898 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -488,6 +488,8 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		if (!perm)
 			goto eperm;
 		switch (arg) {
+		case KD_X:
+			break;
 		case KD_GRAPHICS:
 			break;
 		case KD_TEXT0:
@@ -1383,7 +1385,7 @@ void change_console(struct vc_data *new_vc)
 	/*
 	 * Ignore all switches in KD_GRAPHICS+VT_AUTO mode
 	 */
-	if (vc->vc_mode == KD_GRAPHICS)
+	if (vc->vc_mode == KD_GRAPHICS || vc->vc_mode == KD_X)
 		return;
 
 	complete_change_console(new_vc);
diff --git a/include/linux/kd.h b/include/linux/kd.h
index 15f2853..36975a3 100644
--- a/include/linux/kd.h
+++ b/include/linux/kd.h
@@ -45,6 +45,9 @@ struct consolefontdesc {
 #define		KD_GRAPHICS	0x01
 #define		KD_TEXT0	0x02	/* obsolete */
 #define		KD_TEXT1	0x03	/* obsolete */
+#define		KD_X            0x04	/* Like KD_GRAPHICS, but doesn't allow
+					   input events to pass through to
+					   /dev/console */
 #define KDGETMODE	0x4B3B	/* get current mode */
 
 #define KDMAPDISP	0x4B3C	/* map display into address space */

-- 
Matthew Garrett | mjg59@srcf.ucam.org
