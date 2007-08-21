Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbXHUVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbXHUVaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbXHUV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:29:53 -0400
Received: from iona.labri.fr ([147.210.8.143]:51817 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbXHUV3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:29:46 -0400
Date: Tue, 21 Aug 2007 23:29:39 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Console events and accessibility
Message-ID: <20070821212939.GD3658@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some external modules like Speakup need to monitor console output.

This adds a VT notifier that such modules can use to get console output events:
allocation, deallocation, writes, other updates (cursor position, switch, etc.)

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---

This is the second hook for Speakup.  I've already set symbols exported
to GPL only.

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index c20773a..8b87263 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -99,6 +99,7 @@
 #include <linux/pm.h>
 #include <linux/font.h>
 #include <linux/bitops.h>
+#include <linux/notifier.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -223,6 +224,35 @@ enum {
 };
 
 /*
+ * Notifier list for console events.
+ */
+static ATOMIC_NOTIFIER_HEAD(vt_notifier_list);
+
+int register_vt_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&vt_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_vt_notifier);
+
+int unregister_vt_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&vt_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_vt_notifier);
+
+static void notify_write(struct vc_data *vc, unsigned int unicode)
+{
+	struct vt_notifier_param param = { .vc = vc, unicode = unicode };
+	atomic_notifier_call_chain(&vt_notifier_list, VT_WRITE, &param);
+}
+
+static void notify_update(struct vc_data *vc)
+{
+	struct vt_notifier_param param = { .vc = vc };
+	atomic_notifier_call_chain(&vt_notifier_list, VT_UPDATE, &param);
+}
+
+/*
  *	Low-Level Functions
  */
 
@@ -718,6 +748,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		return -ENXIO;
 	if (!vc_cons[currcons].d) {
 	    struct vc_data *vc;
+	    struct vt_notifier_param param;
 
 	    /* prevent users from taking too much memory */
 	    if (currcons >= MAX_NR_USER_CONSOLES && !capable(CAP_SYS_RESOURCE))
@@ -729,7 +760,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    /* although the numbers above are not valid since long ago, the
 	       point is still up-to-date and the comment still has its value
 	       even if only as a historical artifact.  --mj, July 1998 */
-	    vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
+	    param.vc = vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
 	    if (!vc)
 		return -ENOMEM;
 	    vc_cons[currcons].d = vc;
@@ -746,6 +777,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    }
 	    vc->vc_kmalloced = 1;
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
+	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
 	}
 	return 0;
 }
@@ -902,6 +934,8 @@ void vc_deallocate(unsigned int currcons)
 
 	if (vc_cons_allocated(currcons)) {
 		struct vc_data *vc = vc_cons[currcons].d;
+		struct vt_notifier_param param = { .vc = vc };
+		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
@@ -1014,6 +1048,7 @@ static void lf(struct vc_data *vc)
 		vc->vc_pos += vc->vc_size_row;
 	}
 	vc->vc_need_wrap = 0;
+	notify_write(vc, '\n');
 }
 
 static void ri(struct vc_data *vc)
@@ -1034,6 +1069,7 @@ static inline void cr(struct vc_data *vc)
 {
 	vc->vc_pos -= vc->vc_x << 1;
 	vc->vc_need_wrap = vc->vc_x = 0;
+	notify_write(vc, '\r');
 }
 
 static inline void bs(struct vc_data *vc)
@@ -1042,6 +1078,7 @@ static inline void bs(struct vc_data *vc)
 		vc->vc_pos -= 2;
 		vc->vc_x--;
 		vc->vc_need_wrap = 0;
+		notify_write(vc, '\b');
 	}
 }
 
@@ -1588,6 +1625,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 				break;
 		}
 		vc->vc_pos += (vc->vc_x << 1);
+		notify_write(vc, '\t');
 		return;
 	case 10: case 11: case 12:
 		lf(vc);
@@ -2247,6 +2285,7 @@ rescan_last_byte:
 				tc = conv_uni_to_pc(vc, ' '); /* A space is printed in the second column */
 				if (tc < 0) tc = ' ';
 			}
+			notify_write(vc, c);
 
 			if (inverse) {
 				FLUSH
@@ -2269,6 +2308,7 @@ rescan_last_byte:
 	release_console_sem();
 
 out:
+	notify_update(vc);
 	return n;
 #undef FLUSH
 }
@@ -2312,6 +2352,7 @@ static void console_callback(struct work_struct *ignored)
 		do_blank_screen(0);
 		blank_timer_expired = 0;
 	}
+	notify_update(vc_cons[fg_console].d);
 
 	release_console_sem();
 }
@@ -2413,6 +2454,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 				continue;
 		}
 		scr_writew((vc->vc_attr << 8) + c, (unsigned short *)vc->vc_pos);
+		notify_write(vc, c);
 		cnt++;
 		if (myx == vc->vc_cols - 1) {
 			vc->vc_need_wrap = 1;
@@ -2431,6 +2473,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 		}
 	}
 	set_cursor(vc);
+	notify_update(vc);
 
 quit:
 	clear_bit(0, &printing);
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index bd37880..fb88436 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -240,5 +240,11 @@ static inline int notifier_to_errno(int ret)
 #define KBD_KEYSYM		0x0004 /* Keyboard keysym */
 #define KBD_POST_KEYSYM		0x0005 /* Called after keyboard keysym interpretation */
 
+/* Virtual Terminal events. */
+#define VT_ALLOCATE		0x0001 /* Console got allocated */
+#define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
+#define VT_WRITE		0x0003 /* A char got output */
+#define VT_UPDATE		0x0004 /* A bigger update occurred */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/include/linux/vt.h b/include/linux/vt.h
index ba806e8..40216b0 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -1,6 +1,18 @@
 #ifndef _LINUX_VT_H
 #define _LINUX_VT_H
 
+#ifdef __KERNEL__
+#include <linux/notifier.h>
+
+struct vt_notifier_param {
+	struct vc_data *vc;	/* VC on which the update happened */
+	unsigned int c;		/* Printed char */
+};
+
+extern int register_vt_notifier(struct notifier_block *nb);
+extern int unregister_vt_notifier(struct notifier_block *nb);
+#endif
+
 /*
  * These constants are also useful for user-level apps (e.g., VC
  * resizing).
