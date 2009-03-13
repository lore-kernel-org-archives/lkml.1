Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZCMQe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZCMQe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbZCMQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:54 -0400
Received: from gw.goop.org ([64.81.55.164]:56781 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759059AbZCMQaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:52 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 11/15] xen: allow enable use of VGA console on dom0
Date: Fri, 13 Mar 2009 09:29:52 -0700
Message-Id: <1236961796-13407-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236961796-13407-1-git-send-email-jeremy@goop.org>
References: <1236961796-13407-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/xen/Makefile       |    3 +-
 arch/x86/xen/enlighten.c    |   10 ++++++
 arch/x86/xen/vga.c          |   67 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h      |   11 +++++++
 include/xen/interface/xen.h |   39 +++++++++++++++++++++++++
 5 files changed, 129 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/xen/vga.c

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3b767d0..c4cda96 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -10,4 +10,5 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
+obj-$(CONFIG_XEN_DOM0)		+= vga.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f7c8afb..40a930b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1036,6 +1036,16 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
+
+		boot_params.screen_info.orig_video_isVGA = 0;
+	} else {
+		const struct dom0_vga_console_info *info =
+			(void *)((char *)xen_start_info +
+			         xen_start_info->console.dom0.info_off);
+
+		xen_init_vga(info, xen_start_info->console.dom0.info_size);
+		xen_start_info->console.domU.mfn = 0;
+		xen_start_info->console.domU.evtchn = 0;
 	}
 
 	pat_disable("PAT disabled on Xen");
diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
new file mode 100644
index 0000000..f2fca2c
--- /dev/null
+++ b/arch/x86/xen/vga.c
@@ -0,0 +1,67 @@
+#include <linux/screen_info.h>
+#include <linux/init.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+
+#include <xen/interface/xen.h>
+
+#include "xen-ops.h"
+
+void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
+{
+	struct screen_info *screen_info = &boot_params.screen_info;
+
+	/* This is drawn from a dump from vgacon:startup in
+	 * standard Linux. */
+	screen_info->orig_video_mode = 3;
+	screen_info->orig_video_isVGA = 1;
+	screen_info->orig_video_lines = 25;
+	screen_info->orig_video_cols = 80;
+	screen_info->orig_video_ega_bx = 3;
+	screen_info->orig_video_points = 16;
+	screen_info->orig_y = screen_info->orig_video_lines - 1;
+
+	switch (info->video_type) {
+	case XEN_VGATYPE_TEXT_MODE_3:
+		if (size < offsetof(struct dom0_vga_console_info, u.text_mode_3)
+		           + sizeof(info->u.text_mode_3))
+			break;
+		screen_info->orig_video_lines = info->u.text_mode_3.rows;
+		screen_info->orig_video_cols = info->u.text_mode_3.columns;
+		screen_info->orig_x = info->u.text_mode_3.cursor_x;
+		screen_info->orig_y = info->u.text_mode_3.cursor_y;
+		screen_info->orig_video_points =
+			info->u.text_mode_3.font_height;
+		break;
+
+	case XEN_VGATYPE_VESA_LFB:
+		if (size < offsetof(struct dom0_vga_console_info,
+		                    u.vesa_lfb.gbl_caps))
+			break;
+		screen_info->orig_video_isVGA = VIDEO_TYPE_VLFB;
+		screen_info->lfb_width = info->u.vesa_lfb.width;
+		screen_info->lfb_height = info->u.vesa_lfb.height;
+		screen_info->lfb_depth = info->u.vesa_lfb.bits_per_pixel;
+		screen_info->lfb_base = info->u.vesa_lfb.lfb_base;
+		screen_info->lfb_size = info->u.vesa_lfb.lfb_size;
+		screen_info->lfb_linelength = info->u.vesa_lfb.bytes_per_line;
+		screen_info->red_size = info->u.vesa_lfb.red_size;
+		screen_info->red_pos = info->u.vesa_lfb.red_pos;
+		screen_info->green_size = info->u.vesa_lfb.green_size;
+		screen_info->green_pos = info->u.vesa_lfb.green_pos;
+		screen_info->blue_size = info->u.vesa_lfb.blue_size;
+		screen_info->blue_pos = info->u.vesa_lfb.blue_pos;
+		screen_info->rsvd_size = info->u.vesa_lfb.rsvd_size;
+		screen_info->rsvd_pos = info->u.vesa_lfb.rsvd_pos;
+		if (size >= offsetof(struct dom0_vga_console_info,
+		                     u.vesa_lfb.gbl_caps)
+		            + sizeof(info->u.vesa_lfb.gbl_caps))
+			screen_info->capabilities = info->u.vesa_lfb.gbl_caps;
+		if (size >= offsetof(struct dom0_vga_console_info,
+		                     u.vesa_lfb.mode_attrs)
+		            + sizeof(info->u.vesa_lfb.mode_attrs))
+			screen_info->vesa_attributes = info->u.vesa_lfb.mode_attrs;
+		break;
+	}
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 8098ed1..4dad0ad 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -74,6 +74,17 @@ static inline void xen_smp_init(void) {}
 #endif
 
 
+struct dom0_vga_console_info;
+
+#ifdef CONFIG_XEN_DOM0
+void xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+#else
+static inline void xen_init_vga(const struct dom0_vga_console_info *info,
+				size_t size)
+{
+}
+#endif
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 18b5599..6c0af21 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -449,6 +449,45 @@ struct start_info {
 	int8_t cmd_line[MAX_GUEST_CMDLINE];
 };
 
+struct dom0_vga_console_info {
+    uint8_t video_type; /* DOM0_VGA_CONSOLE_??? */
+#define XEN_VGATYPE_TEXT_MODE_3 0x03
+#define XEN_VGATYPE_VESA_LFB    0x23
+
+    union {
+        struct {
+            /* Font height, in pixels. */
+            uint16_t font_height;
+            /* Cursor location (column, row). */
+            uint16_t cursor_x, cursor_y;
+            /* Number of rows and columns (dimensions in characters). */
+            uint16_t rows, columns;
+        } text_mode_3;
+
+        struct {
+            /* Width and height, in pixels. */
+            uint16_t width, height;
+            /* Bytes per scan line. */
+            uint16_t bytes_per_line;
+            /* Bits per pixel. */
+            uint16_t bits_per_pixel;
+            /* LFB physical address, and size (in units of 64kB). */
+            uint32_t lfb_base;
+            uint32_t lfb_size;
+            /* RGB mask offsets and sizes, as defined by VBE 1.2+ */
+            uint8_t  red_pos, red_size;
+            uint8_t  green_pos, green_size;
+            uint8_t  blue_pos, blue_size;
+            uint8_t  rsvd_pos, rsvd_size;
+
+            /* VESA capabilities (offset 0xa, VESA command 0x4f00). */
+            uint32_t gbl_caps;
+            /* Mode attributes (offset 0x0, VESA command 0x4f01). */
+            uint16_t mode_attrs;
+        } vesa_lfb;
+    } u;
+};
+
 /* These flags are passed in the 'flags' field of start_info_t. */
 #define SIF_PRIVILEGED    (1<<0)  /* Is the domain privileged? */
 #define SIF_INITDOMAIN    (1<<1)  /* Is this the initial control domain? */
-- 
1.6.0.6

