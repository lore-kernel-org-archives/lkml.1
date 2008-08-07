Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYHGMbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYHGMbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbYHGMad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:30:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:37550 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065AbYHGMa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:30:28 -0400
Subject: [PATCH]: radeonfb: Fix accel engine hangs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: akpm@linux-foundation.org
Cc: davem@davemloft.net, stable@kernel.org,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200808070905.m7794xQ7009009@imap1.linux-foundation.org>
References: <200808070905.m7794xQ7009009@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 19:40:59 +1000
Message-Id: <1218102059.24157.288.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

Some chips appear to have the 2D engine hang during screen redraw,
typically in a sequence of copyarea operations. This appear to be
solved by adding a flush of the engine destination pixel cache
and waiting for the engine to be idle before issuing the accel
operation. The performance impact seems to be fairly small.

Here is a trace on an RV370 (PCI device ID 0x5b64), it records the
RBBM_STATUS register, then the source x/y, destination x/y, and
width/height used for the copy:

----------------------------------------
radeonfb_prim_copyarea: STATUS[00000140] src[210:70] dst[210:60] wh[a0:10]
radeonfb_prim_copyarea: STATUS[00000140] src[2b8:70] dst[2b8:60] wh[88:10]
radeonfb_prim_copyarea: STATUS[00000140] src[348:70] dst[348:60] wh[40:10]
radeonfb_prim_copyarea: STATUS[80020140] src[390:70] dst[390:60] wh[88:10]
radeonfb_prim_copyarea: STATUS[8002613f] src[40:80] dst[40:70] wh[28:10]
radeonfb_prim_copyarea: STATUS[80026139] src[a8:80] dst[a8:70] wh[38:10]
radeonfb_prim_copyarea: STATUS[80026133] src[e8:80] dst[e8:70] wh[80:10]
radeonfb_prim_copyarea: STATUS[8002612d] src[170:80] dst[170:70] wh[30:10]
radeonfb_prim_copyarea: STATUS[80026127] src[1a8:80] dst[1a8:70] wh[8:10]
radeonfb_prim_copyarea: STATUS[80026121] src[1b8:80] dst[1b8:70] wh[88:10]
radeonfb_prim_copyarea: STATUS[8002611b] src[248:80] dst[248:70] wh[68:10]
----------------------------------------

When things are going fine the copies complete before the next ROP is
even issued, but all of a sudden the 2D unit becomes active (bit 17 in
RBBM_STATUS) and the FIFO retry (bit 13) and FIFO pipeline busy (bit
14) are set as well.  The FIFO begins to backup until it becomes full.

What happens next is the radeon_fifo_wait() times out, and we access
the chip illegally leading to a bus error which usually wedges the
box.  None of this makes it to the console screen, of course :-)
radeon_fifo_wait() should be modified to reset the accelerator when
this timeout happens instead of programming the chip anyways.

----------------------------------------
radeonfb: FIFO Timeout !
ERROR(0): Cheetah error trap taken afsr[0010080005000000] afar[000007f900800e40] TL1(0)
ERROR(0): TPC[595114] TNPC[595118] O7[459788] TSTATE[11009601]
ERROR(0): TPC<radeonfb_copyarea+0xfc/0x248>
ERROR(0): M_SYND(0),  E_SYND(0), Privileged
ERROR(0): Highest priority error (0000080000000000) "Bus error response from system bus"
ERROR(0): D-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000]
ERROR(0): D-cache data0[0000000000000000] data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
ERROR(0): I-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000] u[0000000000000000] l[00\

ERROR(0): I-cache INSN0[0000000000000000] INSN1[0000000000000000] INSN2[0000000000000000] INSN3[0000000000000000]
ERROR(0): I-cache INSN4[0000000000000000] INSN5[0000000000000000] INSN6[0000000000000000] INSN7[0000000000000000]
ERROR(0): E-cache idx[800e40] tag[000000000e049f4c]
ERROR(0): E-cache data0[fffff8127d300180] data1[00000000004b5384] data2[0000000000000000] data3[0000000000000000]
Ker:xnel panic - not syncing: Irrecoverable deferred error trap.
----------------------------------------

Another quirk is that these copyarea calls will not happen until the
first drivers/char/vt.c:redraw_screen() occurs.  This will only happen
if you 1) VC switch or 2) run "consolechars" or 3) unblank the screen.

This seems to happen because until a redraw_screen() the screen scrolling
method used by fbcon is not finalized yet.  I've seen this with other fb
drivers too.

So if all you do is boot straight into X you will never see this bug on
the relevant chips.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This replaces my previous ones. Just a minor change from David original
one and suitable for both upstream and stable. I'll sort out the other
stuff separately. Sorry for the confusion.

Index: linux-work/drivers/video/aty/radeon_accel.c
===================================================================
--- linux-work.orig/drivers/video/aty/radeon_accel.c	2008-08-07 19:11:24.000000000 +1000
+++ linux-work/drivers/video/aty/radeon_accel.c	2008-08-07 19:28:33.000000000 +1000
@@ -55,6 +55,10 @@ static void radeonfb_prim_fillrect(struc
 	OUTREG(DP_WRITE_MSK, 0xffffffff);
 	OUTREG(DP_CNTL, (DST_X_LEFT_TO_RIGHT | DST_Y_TOP_TO_BOTTOM));
 
+	radeon_fifo_wait(2);
+	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
+	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
+
 	radeon_fifo_wait(2);  
 	OUTREG(DST_Y_X, (region->dy << 16) | region->dx);
 	OUTREG(DST_WIDTH_HEIGHT, (region->width << 16) | region->height);
@@ -116,6 +120,10 @@ static void radeonfb_prim_copyarea(struc
 	OUTREG(DP_CNTL, (xdir>=0 ? DST_X_LEFT_TO_RIGHT : 0)
 			| (ydir>=0 ? DST_Y_TOP_TO_BOTTOM : 0));
 
+	radeon_fifo_wait(2);
+	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
+	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
+
 	radeon_fifo_wait(3);
 	OUTREG(SRC_Y_X, (sy << 16) | sx);
 	OUTREG(DST_Y_X, (dy << 16) | dx);
Index: linux-work/include/video/radeon.h
===================================================================
--- linux-work.orig/include/video/radeon.h	2008-08-07 19:11:24.000000000 +1000
+++ linux-work/include/video/radeon.h	2008-08-07 19:12:44.000000000 +1000
@@ -742,6 +742,10 @@
 #define SOFT_RESET_RB           		   (1 <<  6)
 #define SOFT_RESET_HDP          		   (1 <<  7)
 
+/* WAIT_UNTIL bit constants */
+#define WAIT_DMA_GUI_IDLE			   (1 << 9)
+#define WAIT_2D_IDLECLEAN			   (1 << 16)
+
 /* SURFACE_CNTL bit consants */
 #define SURF_TRANSLATION_DIS			   (1 << 8)
 #define NONSURF_AP0_SWP_16BPP			   (1 << 20)


