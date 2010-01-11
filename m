Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093Ab0AKV1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0AKV1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826Ab0AKV1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:48 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35373 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0AKV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EXbRtfmcLilfXlm76Tb21pZcO9adhC3cPlU+gR7Zx2yByqt4ZW2KISvyQax5wiDvPI
         sNVajlmSN3157hm6atDqrkJEBTb4F3w4aRqAPXXI4DH7u8pn0lYa9A8bO8KJTdphrMTh
         CHpHVXD5f3NR0g4Ty/NJv2yrOkF2mP7lviQhk=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 23/26] vgacon: Convert vga console lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:53 +0100
Message-Id: <1263245216-14754-24-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-23-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
 <1263245216-14754-20-git-send-email-jkacur@redhat.com>
 <1263245216-14754-21-git-send-email-jkacur@redhat.com>
 <1263245216-14754-22-git-send-email-jkacur@redhat.com>
 <1263245216-14754-23-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks

See also 87f163a2ab9601820c2a6b7d14f81ab3d7d2b642

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/video/console/vgacon.c |   42 ++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index cc4bbbe..7f29a2e 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -51,7 +51,7 @@
 #include <video/vga.h>
 #include <asm/io.h>
 
-static DEFINE_SPINLOCK(vga_lock);
+static DEFINE_RAW_SPINLOCK(vga_lock);
 static int cursor_size_lastfrom;
 static int cursor_size_lastto;
 static u32 vgacon_xres;
@@ -158,7 +158,7 @@ static inline void write_vga(unsigned char reg, unsigned int val)
 	 * ddprintk might set the console position from interrupt
 	 * handlers, thus the write has to be IRQ-atomic.
 	 */
-	spin_lock_irqsave(&vga_lock, flags);
+	raw_spin_lock_irqsave(&vga_lock, flags);
 
 #ifndef SLOW_VGA
 	v1 = reg + (val & 0xff00);
@@ -171,7 +171,7 @@ static inline void write_vga(unsigned char reg, unsigned int val)
 	outb_p(reg + 1, vga_video_port_reg);
 	outb_p(val & 0xff, vga_video_port_val);
 #endif
-	spin_unlock_irqrestore(&vga_lock, flags);
+	raw_spin_unlock_irqrestore(&vga_lock, flags);
 }
 
 static inline void vga_set_mem_top(struct vc_data *c)
@@ -668,7 +668,7 @@ static void vgacon_set_cursor_size(int xpos, int from, int to)
 	cursor_size_lastfrom = from;
 	cursor_size_lastto = to;
 
-	spin_lock_irqsave(&vga_lock, flags);
+	raw_spin_lock_irqsave(&vga_lock, flags);
 	if (vga_video_type >= VIDEO_TYPE_VGAC) {
 		outb_p(VGA_CRTC_CURSOR_START, vga_video_port_reg);
 		curs = inb_p(vga_video_port_val);
@@ -686,7 +686,7 @@ static void vgacon_set_cursor_size(int xpos, int from, int to)
 	outb_p(curs, vga_video_port_val);
 	outb_p(VGA_CRTC_CURSOR_END, vga_video_port_reg);
 	outb_p(cure, vga_video_port_val);
-	spin_unlock_irqrestore(&vga_lock, flags);
+	raw_spin_unlock_irqrestore(&vga_lock, flags);
 }
 
 static void vgacon_cursor(struct vc_data *c, int mode)
@@ -761,7 +761,7 @@ static int vgacon_doresize(struct vc_data *c,
 	unsigned int scanlines = height * c->vc_font.height;
 	u8 scanlines_lo = 0, r7 = 0, vsync_end = 0, mode, max_scan;
 
-	spin_lock_irqsave(&vga_lock, flags);
+	raw_spin_lock_irqsave(&vga_lock, flags);
 
 	vgacon_xres = width * VGA_FONTWIDTH;
 	vgacon_yres = height * c->vc_font.height;
@@ -812,7 +812,7 @@ static int vgacon_doresize(struct vc_data *c,
 		outb_p(vsync_end, vga_video_port_val);
 	}
 
-	spin_unlock_irqrestore(&vga_lock, flags);
+	raw_spin_unlock_irqrestore(&vga_lock, flags);
 	return 0;
 }
 
@@ -895,11 +895,11 @@ static void vga_vesa_blank(struct vgastate *state, int mode)
 {
 	/* save original values of VGA controller registers */
 	if (!vga_vesa_blanked) {
-		spin_lock_irq(&vga_lock);
+		raw_spin_lock_irq(&vga_lock);
 		vga_state.SeqCtrlIndex = vga_r(state->vgabase, VGA_SEQ_I);
 		vga_state.CrtCtrlIndex = inb_p(vga_video_port_reg);
 		vga_state.CrtMiscIO = vga_r(state->vgabase, VGA_MIS_R);
-		spin_unlock_irq(&vga_lock);
+		raw_spin_unlock_irq(&vga_lock);
 
 		outb_p(0x00, vga_video_port_reg);	/* HorizontalTotal */
 		vga_state.HorizontalTotal = inb_p(vga_video_port_val);
@@ -922,7 +922,7 @@ static void vga_vesa_blank(struct vgastate *state, int mode)
 
 	/* assure that video is enabled */
 	/* "0x20" is VIDEO_ENABLE_bit in register 01 of sequencer */
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	vga_wseq(state->vgabase, VGA_SEQ_CLOCK_MODE, vga_state.ClockingMode | 0x20);
 
 	/* test for vertical retrace in process.... */
@@ -958,13 +958,13 @@ static void vga_vesa_blank(struct vgastate *state, int mode)
 	/* restore both index registers */
 	vga_w(state->vgabase, VGA_SEQ_I, vga_state.SeqCtrlIndex);
 	outb_p(vga_state.CrtCtrlIndex, vga_video_port_reg);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 }
 
 static void vga_vesa_unblank(struct vgastate *state)
 {
 	/* restore original values of VGA controller registers */
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	vga_w(state->vgabase, VGA_MIS_W, vga_state.CrtMiscIO);
 
 	outb_p(0x00, vga_video_port_reg);	/* HorizontalTotal */
@@ -989,7 +989,7 @@ static void vga_vesa_unblank(struct vgastate *state)
 	/* restore index/control registers */
 	vga_w(state->vgabase, VGA_SEQ_I, vga_state.SeqCtrlIndex);
 	outb_p(vga_state.CrtCtrlIndex, vga_video_port_reg);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 }
 
 static void vga_pal_blank(struct vgastate *state)
@@ -1109,7 +1109,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 #endif
 
 	unlock_kernel();
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	/* First, the Sequencer */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
 	/* CPU writes only to map 2 */
@@ -1125,7 +1125,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 	vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x00);
 	/* map start at A000:0000 */
 	vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x00);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 
 	if (arg) {
 		if (set)
@@ -1152,7 +1152,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		}
 	}
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	/* First, the sequencer, Synchronous reset */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x01);	
 	/* CPU writes to maps 0 and 1 */
@@ -1191,7 +1191,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		inb_p(video_port_status);
 		vga_wattr(state->vgabase, VGA_AR_ENABLE_DISPLAY, 0);	
 	}
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 	lock_kernel();
 	return 0;
 }
@@ -1217,26 +1217,26 @@ static int vgacon_adjust_height(struct vc_data *vc, unsigned fontheight)
 	   registers; they are write-only on EGA, but it appears that they
 	   are all don't care bits on EGA, so I guess it doesn't matter. */
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	outb_p(0x07, vga_video_port_reg);	/* CRTC overflow register */
 	ovr = inb_p(vga_video_port_val);
 	outb_p(0x09, vga_video_port_reg);	/* Font size register */
 	fsr = inb_p(vga_video_port_val);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 
 	vde = maxscan & 0xff;	/* Vertical display end reg */
 	ovr = (ovr & 0xbd) +	/* Overflow register */
 	    ((maxscan & 0x100) >> 7) + ((maxscan & 0x200) >> 3);
 	fsr = (fsr & 0xe0) + (fontheight - 1);	/*  Font size register */
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	outb_p(0x07, vga_video_port_reg);	/* CRTC overflow register */
 	outb_p(ovr, vga_video_port_val);
 	outb_p(0x09, vga_video_port_reg);	/* Font size */
 	outb_p(fsr, vga_video_port_val);
 	outb_p(0x12, vga_video_port_reg);	/* Vertical display limit */
 	outb_p(vde, vga_video_port_val);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 	vga_video_font_height = fontheight;
 
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
-- 
1.6.5.2

