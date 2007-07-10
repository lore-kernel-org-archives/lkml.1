Return-Path: <linux-kernel-owner+w=401wt.eu-S1761216AbXGJASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216AbXGJASy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbXGJASr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:18:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56193 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759477AbXGJASr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:18:47 -0400
Date: Tue, 10 Jul 2007 02:19:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mikael Pettersson <mikpe@it.uu.se>, adaplas@gmail.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: [2.6 patch] drivers/video/macmodes.c:mac_find_mode() mustn't be
	__devinit
Message-ID: <20070710001918.GP3492@stusta.de>
References: <200707092347.l69NlElB023451@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707092347.l69NlElB023451@harpo.it.uu.se>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:47:14AM +0200, Mikael Pettersson wrote:
> A vanilla 2.6.22 built for ppc32 and configured with CONFIG_FB_MACMODES=y, CONFIG_HOTPLUG=n,
> and CONFIG_MODULES=y, triggers the following warning from modpost:
> 
> WARNING: drivers/built-in.o(__ksymtab+0x3b0): Section mismatch: reference to .init.text:mac_find_mode (between '__ksymtab_mac_find_mode' and '__ksymtab_mac_map_monitor_sense')
> 
> There's an EXPORT_SYMBOL(mac_find_mode), but mac_find_mode() is __devinit
> and thus __init in this kernel.

So let's fix it.  ;-)

> /Mikael

cu
Adrian


<--  snip  -->


If it's EXPORT_SYMBOL'ed it can't be __devinit.

Reported by Mikael Pettersson.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

@stable:
Fixes a real bug on ppc.

 drivers/video/macmodes.c |    5 ++---
 drivers/video/macmodes.h |    8 ++++----
 2 files changed, 6 insertions(+), 7 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/video/macmodes.h.old	2007-07-10 01:55:14.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/macmodes.h	2007-07-10 01:55:29.000000000 +0200
@@ -55,10 +55,10 @@
 extern int mac_var_to_vmode(const struct fb_var_screeninfo *var, int *vmode,
 			    int *cmode);
 extern int mac_map_monitor_sense(int sense);
-extern int __devinit mac_find_mode(struct fb_var_screeninfo *var,
-				   struct fb_info *info,
-				   const char *mode_option,
-				   unsigned int default_bpp);
+extern int mac_find_mode(struct fb_var_screeninfo *var,
+			 struct fb_info *info,
+			 const char *mode_option,
+			 unsigned int default_bpp);
 
 
     /*
--- linux-2.6.22-rc6-mm1/drivers/video/macmodes.c.old	2007-07-10 01:54:36.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/macmodes.c	2007-07-10 01:55:04.000000000 +0200
@@ -369,9 +369,8 @@
  *
  */
 
-int __devinit mac_find_mode(struct fb_var_screeninfo *var,
-			    struct fb_info *info, const char *mode_option,
-			    unsigned int default_bpp)
+int mac_find_mode(struct fb_var_screeninfo *var, struct fb_info *info,
+		  const char *mode_option, unsigned int default_bpp)
 {
     const struct fb_videomode *db = NULL;
     unsigned int dbsize = 0;

