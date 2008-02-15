Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYBORZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYBORZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYBORZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:25:34 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:58557 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYBORZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:25:33 -0500
Date: Fri, 15 Feb 2008 18:25:16 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: [PATCH] VT notifier extension for accessibility
Message-ID: <20080215172516.GK4511@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org,
	linuxconsole-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some accessibility modules need to be able to catch the output on the
console before the VT interpretation, and possibly swallow it.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
From: Karl Dahlke <eklhad@comcast.net>

--- include/linux/notifier.h	2008-02-15 08:44:10.000000000 -0500
+++ include/linux/notifier.h.new	2008-02-15 09:58:00.000000000 -0500
@@ -247,6 +247,7 @@ extern struct blocking_notifier_head reb
 #define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
 #define VT_WRITE		0x0003 /* A char got output */
 #define VT_UPDATE		0x0004 /* A bigger update occurred */
+#define VT_PREWRITE		0x0005 /* A char is about to be written to the console */
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
--- drivers/char/vt.c	2008-02-15 08:43:35.000000000 -0500
+++ drivers/char/vt.c.new	2008-02-15 10:11:14.000000000 -0500
@@ -2053,6 +2053,7 @@ static int do_con_write(struct tty_struc
 	unsigned long draw_from = 0, draw_to = 0;
 	struct vc_data *vc;
 	unsigned char vc_attr;
+	struct vt_notifier_param param;
 	uint8_t rescan;
 	uint8_t inverse;
 	uint8_t width;
@@ -2112,6 +2113,8 @@ static int do_con_write(struct tty_struc
 	if (IS_FG(vc))
 		hide_cursor(vc);
 
+	param.vc = vc;
+
 	while (!tty->stopped && count) {
 		int orig = *buf;
 		c = orig;
@@ -2200,6 +2203,10 @@ rescan_last_byte:
 		    tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
 		}
 
+		param.c = tc;
+		if (atomic_notifier_call_chain(&vt_notifier_list, VT_PREWRITE, &param) == NOTIFY_STOP)
+			continue;
+
                 /* If the original code was a control character we
                  * only allow a glyph to be displayed if the code is
                  * not normally used (such as for cursor movement) or
