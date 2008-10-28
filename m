Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJ1AHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJ1AHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYJ1AGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:06:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:55914 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYJ1AGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:06:18 -0400
Subject: Re: radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       "David S. Miller" <davem@davemloft.net>,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 11:05:47 +1100
Message-Id: <1225152347.8004.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 19:45 -0400, James Cloos wrote:
> Commit b1ee26bab1 breaks radeonfb on my inspiron 8100 (P3-M with a
> Mobility M7 LW [7500] (1002:4c57 1028:00e6)).
> 
> The boot is OK until init(8) starts; after init outputs its version info
> it calls rc(8), which starts by setting the fb font.  At that point any
> kernel with b1ee26bab1 locks hard.  The cursor stops flashing, magic
> sysrq stops working and the fan starts up after a few seconds.  (I can't
> tell whether it is the CPU or the GPU that heats up.)
> 
> If it is relevant, I use a 10x20 font, so the font change means the
> console converts from 200x75, 8x16 to 160x60, 10x20.

Annoying... Either I'm doing something wrong (which is always possible)
or we're hitting yet another fancy ATI bug (the M7 generation is known
to be pretty bad in that area).

First, let's see if it's related to the imageblit. Can you re-apply the
reverted patch and apply this little hack on top :

Index: linux-work/drivers/video/aty/radeon_accel.c
===================================================================
--- linux-work.orig/drivers/video/aty/radeon_accel.c	2008-10-28 11:01:49.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_accel.c	2008-10-28 11:01:57.000000000 +1100
@@ -252,6 +252,7 @@ void radeonfb_imageblit(struct fb_info *
 	if (!image->width || !image->height)
 		return;
 
+#if 0
 	/* We only do 1 bpp color expansion for now */
 	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1)
 		goto fallback;
@@ -275,6 +276,7 @@ void radeonfb_imageblit(struct fb_info *
 	return;
 
  fallback:
+#endif
 	radeon_engine_idle(rinfo);
 
 	cfb_imageblit(info, image);

And let me know if that makes it not lockup.

Cheers,
Ben.


