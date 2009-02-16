Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZBPXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZBPXxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZBPXqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:34 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50816
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753311AbZBPXqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:19 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/19] xen: allow enable use of VGA console on dom0
Date: Mon, 16 Feb 2009 15:46:08 -0800
Message-Id: <0dda0d4d9cf8e5aebba5d370def8c268e93e9800.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <b4adea5f3e4c3ebba175f2344d138f85aa48dd57.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0b79be113b42a033f3b3ca4d4f3ca4035c8a7bf5.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <b4adea5f3e4c3ebba175f2344d138f85aa48dd57.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're booting a privileged domain, then set up the vga console for use.
Xen provides us with all the information about the current vga state, without
need to use the BIOS.  We use that information to populate screen_info, which
allows the rest of the kernel to carry on as normal.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile       |    3 +-
 arch/x86/xen/enlighten.c    |   10 ++++++
 arch/x86/xen/vga.c          |   65 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h      |   11 +++++++
 include/xen/interface/xen.h |   39 +++++++++++++++++++++++++
 5 files changed, 127 insertions(+), 1 deletions(-)
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
index 676aaf8..639eeb1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -995,6 +995,16 @@ asmlinkage void __init xen_start_kernel(void)
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
index 0000000..f4a038a
--- /dev/null
+++ b/arch/x86/xen/vga.c
@@ -0,0 +1,65 @@
+#include <linux/screen_info.h>
+#include <linux/init.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
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
index 33f7538..414236b 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -4,6 +4,8 @@
 #include <linux/init.h>
 #include <linux/clocksource.h>
 #include <linux/irqreturn.h>
+
+#include <xen/interface/xen.h>
 #include <xen/xen-ops.h>
 
 /* These are code, but not functions.  Defined in entry.S */
@@ -75,6 +77,15 @@ static inline void xen_smp_init(void) {}
 #endif
 
 
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

