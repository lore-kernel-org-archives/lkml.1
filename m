Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZGKVGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZGKVGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZGKVGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 17:06:33 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42631 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZGKVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 17:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=pwIs0ZMnwgzHb6WpzRs+8+YOLhxRjXiEwXejn/P6EsYNDyScf2n7235QOIneaXOhUr
         Oqwjv4y2VsmCM/m7E/lWCxNxkaf3V/onUa8LeqRgBRgccPGlndqKDyhrN8teceTKpVbI
         z697pzVs6X/kbdU8pDNFuvVDgruHB7XoHs0VA=
Date: Sun, 12 Jul 2009 00:06:25 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Kconfig, Makefile and ifdef: mod as yes vs. no?
Message-ID: <20090712000625.7e1bffc2@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having hard time making a patch that would compile nouveau_backlight.o
only if CONFIG_BACKLIGHT_CLASS_DEVICE is y or m, and define just stubs
when it is n.

I'm trying this in the nouveau/linux-2.6 kernel tree, which is basically
2.6.31-rc2.

I attempted the following:

--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -8,7 +8,7 @@ nouveau-y := nouveau_drv.o nouveau_state.o nouveau_fifo.o nouveau_mem.o \
              nouveau_sgdma.o nouveau_dma.o \
              nouveau_bo.o nouveau_fence.o nouveau_gem.o nouveau_ttm.o \
              nouveau_hw.o nouveau_calc.o nouveau_bios.o nouveau_i2c.o \
-            nouveau_display.o nouveau_fbcon.o nouveau_backlight.o \
+             nouveau_display.o nouveau_fbcon.o \
              nv04_timer.o \
              nv04_mc.o nv40_mc.o nv50_mc.o \
              nv04_fb.o nv10_fb.o nv40_fb.o \
@@ -19,8 +19,9 @@ nouveau-y := nouveau_drv.o nouveau_state.o nouveau_fifo.o nouveau_mem.o \
              nv50_crtc.o nv50_dac.o nv50_sor.o nv50_connector.o \
              nv50_cursor.o nv50_display.o nv50_fbcon.o \
              nv04_display.o nv04_output.o nv04_crtc.o nv04_cursor.o \
-            nv04_fbcon.o
+             nv04_fbcon.o
 
 nouveau-$(CONFIG_COMPAT) += nouveau_ioc32.o
+nouveau-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += nouveau_backlight.o
 
 obj-$(CONFIG_DRM_NOUVEAU)+= nouveau.o

--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -708,8 +708,21 @@ extern int  nouveau_dma_init(struct nouveau_channel *);
 extern int  nouveau_dma_wait(struct nouveau_channel *, int size);
 
 /* nouveau_backlight.c */
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 extern int nouveau_backlight_init(struct drm_device *);
 extern void nouveau_backlight_exit(struct drm_device *);
+#else
+static inline int nouveau_backlight_init(struct drm_device *dev)
+{
+       (void)dev;
+       return 0;
+}
+
+static inline void nouveau_backlight_exit(struct drm_device *dev)
+{
+       (void)dev;
+}
+#endif
 
When CONFIG_BACKLIGHT_CLASS_DEVICE=m this behaves as if it was n, i.e.
I get the stubs and no nouveau_backlight.o.

For CONFIG_BACKLIGHT_CLASS_DEVICE=y and n I get what I want.

What is the proper way to get m behave like y in this situation?

Oh, and should I use the following instead of (void)dev;?
static inline void nouveau_backlight_exit(struct drm_device *dev __used) { }

Please, Cc me.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
