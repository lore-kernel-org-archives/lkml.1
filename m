Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZBVJZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZBVJZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZBVJZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:25:10 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:49710 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZBVJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UPeYkaDci1eqRujixjjWXSDG4XeLhgmqJC3oB75yMI1zf4bMMJQ43xafDywesIOiRq
         MxSUxs8m7bErF40mfz2AzUCfdcJy9Nk5Ng0U1OELQkymyGWBJm5asJuArTEmbUVd2ULE
         mBZnswC1ZqORit+0Vq2XTNeT4+DSORHoqYK7I=
MIME-Version: 1.0
In-Reply-To: <20090222081517.567a29bd.krzysztof.h1@poczta.fm>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	 <Pine.LNX.4.64.0901241425310.13803@anakin>
	 <46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	 <46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	 <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	 <20090211142409.b88c577e.akpm@linux-foundation.org>
	 <46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
	 <20090213210635.d094ffc8.krzysztof.h1@poczta.fm>
	 <20090222081517.567a29bd.krzysztof.h1@poczta.fm>
Date: Sun, 22 Feb 2009 11:25:04 +0200
Message-ID: <46e1c7760902220125l61700421gc4045ca10ea4dd10@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: adaplas@pol.net, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof, thank you for your efforts.

I've been using PowerMac platform with built-in ATI mach64 and Xorg
server 1.1.1. Kernel options related to frame buffers include:

CONFIG_FB=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MACMODES=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y

CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y

Xfbdev options include:

--disable-static \
--enable-xorg \
--enable-xtrap \
--enable-dmx \
--enable-vfb \
--enable-kdrive \
--enable-xephyr \
--disable-xsdl \
--disable-xfake \
--enable-xfbdev \
--disable-kdrive-vesa \
--disable-lbx \
--disable-xprint \
--disable-xorgconfig \
--disable-xorgcfg \
--disable-misc-utils

In my opinion, Xfbdev assumes that the cursor will disappear when
turning on graphics mode with ioctl(LinuxConsoleFd, KDSETMODE,
KD_GRAPHICS). It's obvious that fbcon is not doing anything to switch
the cursor off when it receives this ioctl, fbcon_is_inactive()
prevents it. The problem comes from that something has made it appear,
i.e. text mode frame buffer console. I have text consoles on VTs 1 to
6 and X on 7.

One maybe unusual property of atyfb is that the frame buffer is higher
than the screen. To make Xfbdev work correctly I needed the patch
below.

Risto

If virtual resolution is higher than the screen (as in atyfb), and yoffset
given by the framebuffer driver happens to be non-zero (fbcon changes it on-
the-fly), Xfbdev places its image starting above the displayed part of the
framebuffer. This patch makes sure that the whole picture is visible.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
---
The testing is done on version 1.1.1 and linux kernel version 2.6.18.

--- a/hw/kdrive/fbdev/fbdev.c.org       2006-07-05 21:31:39.000000000 +0300
+++ b/hw/kdrive/fbdev/fbdev.c   2009-01-18 15:42:06.000000000 +0200
@@ -215,6 +215,8 @@ fbdevScreenInitialize (KdScreenInfo *scr

     /* Now get the new screeninfo */
     ioctl (priv->fd, FBIOGET_VSCREENINFO, &priv->var);
+    /* We can get anything into yoffset if fbcon is active */
+    priv->var.yoffset = 0;
     depth = priv->var.bits_per_pixel;
     gray = priv->var.grayscale;
