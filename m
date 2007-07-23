Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXGWKCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXGWKCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGWKCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:02:31 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:58694 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXGWKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:02:30 -0400
Date: Mon, 23 Jul 2007 03:02:29 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Adrian Bunk <bunk@stusta.de>
cc: Thierry MERLE <thierry.merle@free.fr>,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [2.6.23 regression fix] usbvision: don't
 return an uninitialized	value
In-Reply-To: <20070723080203.GD26212@stusta.de>
Message-ID: <Pine.LNX.4.58.0707230254390.5535@shell2.speakeasy.net>
References: <20070723080203.GD26212@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Adrian Bunk wrote:
> Commit c5f48367fe54c46805774eeea8e828de54a5ad7b introduced this return
> of an uninitialized variable.
>
> Spotted by the Coverity checker.

It spotted that, but it seems it missed the bigger bug, reg->val is
unsigned.  Since reg->val can't be less than 0, it will never actually
return the unitialized variable.

This patch should fix it correctly.  The vidioc_g_register function was
broken too, it wasn't actually setting reg->val to the register value it
read.

--------------------------------------------------------------------
usbvision: fix bugs in vidioc_[sg]_register functions

From: Trent Piepho <xyzzy@speakeasy.org>

s_register was assigning the return code to (unsigned)reg->val, rather than
errCode, which it what it would return.  Except reg->val can't be < 0, so it
would never actually return an error.

g_register never actually put the value it read into reg->val.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff -r 8e72fe5675b3 -r d5c4fffbbad3 linux/drivers/media/video/usbvision/usbvision-video.c
--- a/linux/drivers/media/video/usbvision/usbvision-video.c	Sat Jul 21 17:26:40 2007 -0700
+++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Mon Jul 23 02:58:31 2007 -0700
@@ -550,6 +550,7 @@ static int vidioc_g_register (struct fil
 		    __FUNCTION__, errCode);
 		return errCode;
 	}
+	reg->val = errCode;
 	return 0;
 }

@@ -564,8 +565,8 @@ static int vidioc_s_register (struct fil
 	if (!v4l2_chip_match_host(reg->match_type, reg->match_chip))
 		return -EINVAL;
 	/* NT100x has a 8-bit register space */
-	reg->val = (u8)usbvision_write_reg(usbvision, reg->reg&0xff, reg->val);
-	if (reg->val < 0) {
+	errCode = usbvision_write_reg(usbvision, reg->reg&0xff, reg->val);
+	if (errCode < 0) {
 		err("%s: VIDIOC_DBG_S_REGISTER failed: error %d",
 		    __FUNCTION__, errCode);
 		return errCode;
