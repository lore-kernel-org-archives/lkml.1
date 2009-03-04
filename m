Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZCDXSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZCDXSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZCDXR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:17:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbZCDXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:17:55 -0500
Date: Wed, 4 Mar 2009 15:17:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Samuel.CUELLA@supinfo.com, adaplas@gmail.com, linux-kernel@vger.kernel.org,
       trivial@kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.28 ] i810: kernel crash fix when  struct
 fb_var_screeninfo is supplied
Message-Id: <20090304151707.804b5e84.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.0903042353350.4971@jikos.suse.cz>
References: <02E43B9E8855E74E886358B5184B4CC9104620C0@mail2-aub1fr.esi-supinfo.com>
	<alpine.LNX.2.00.0903041108470.4971@jikos.suse.cz>
	<20090304142006.20ad72fe.akpm@linux-foundation.org>
	<alpine.LNX.2.00.0903042353350.4971@jikos.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 23:54:49 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 4 Mar 2009, Andrew Morton wrote:
> 
> > > This is not appropriate for trivial tree. CCing akpm and lkml.
> > I don't have a copy of the original patch.
> 
> This is what I got from Samuel (and rejected it for trivial tree, not 
> being trivial enough :) )
> 

ok, thanks.

> --- linux-2.6.28/drivers/video/i810/i810_main.c.orig    2009-02-26 15:23:03.000000000 +0100
> +++ linux-2.6.28/drivers/video/i810/i810_main.c 2009-02-26 14:50:06.000000000 +0100
> @@ -993,6 +993,8 @@ static int i810_check_params(struct fb_v
>         struct i810fb_par *par = info->par;
>         int line_length, vidmem, mode_valid = 0, retval = 0;
>         u32 vyres = var->yres_virtual, vxres = var->xres_virtual;
> +       u32 yres = info->var.yres;
> +
>         /*
>          *  Memory limit
>          */

So we have a file-wide static called `yres' - seems a bit dangerous.

Rather than defining a local which shadows the global, it would be
clearer to do it in this equivalent way, yes?

--- a/drivers/video/i810/i810_main.c~i810-fix-kernel-crash-fix-when-struct-fb_var_screeninfo-is-supplied
+++ a/drivers/video/i810/i810_main.c
@@ -993,6 +993,7 @@ static int i810_check_params(struct fb_v
 	struct i810fb_par *par = info->par;
 	int line_length, vidmem, mode_valid = 0, retval = 0;
 	u32 vyres = var->yres_virtual, vxres = var->xres_virtual;
+
 	/*
 	 *  Memory limit
 	 */
@@ -1002,12 +1003,12 @@ static int i810_check_params(struct fb_v
 	if (vidmem > par->fb.size) {
 		vyres = par->fb.size/line_length;
 		if (vyres < var->yres) {
-			vyres = yres;
+			vyres = info->var.yres;
 			vxres = par->fb.size/vyres;
 			vxres /= var->bits_per_pixel >> 3;
 			line_length = get_line_length(par, vxres, 
 						      var->bits_per_pixel);
-			vidmem = line_length * yres;
+			vidmem = line_length * info->var.yres;
 			if (vxres < var->xres) {
 				printk("i810fb: required video memory, "
 				       "%d bytes, for %dx%d-%d (virtual) "
_

This assumes that the original change was actually correct.  Should
both sites whcih use the global `yres' have been converted to use
info->var.yres, or just one of them?
