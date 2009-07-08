Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbZGHJsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbZGHJsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbZGHJsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:48:07 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:51906 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbZGHJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=n7IkWCrJweh6EbbCncZ/G5+MPiDVYf9/sLSAj1HLCS8Ly2ov7WhDymbUyd4SswoNpS
         Gtu/TJ7QjL8bz0ykCY39IQ92+HUxuo0V+lmRrPUP9yEhZwP8tL6k5Kw7j9mKnwAVgO04
         zPebCuJD4UZwvh/001orwdkLSKMDILFsZKsBU=
Subject: Re: [PATCH] fb: move mutex_init to framebuffer_alloc()
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1246465606-29346-1-git-send-email-daniel@caiaq.de>
References: <1246465606-29346-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Wed, 08 Jul 2009 17:42:25 +0800
Message-Id: <1247046145.22324.12.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 18:26 +0200, Daniel Mack wrote:
> In 537a1bf05, a per-fbinfo mutex was added and framebuffer drivers were
> adopted accordingly. This new lock is currently initialized in
> register_framebuffer().
> 
> The mx3fb driver takes this lock in mx3fb_map_video_memory() _before_
> register_framebuffer() is called and hence crashes the system very
> early.
> 
> Moving this mutex_init() to framebuffer_alloc() solves this and also
> seems a lot more straight forward.
> 

but this may introduce deadlock to some _old_ drivers which have not
used framebuffer_alloc to allocate fb_info structure.

to avoid deadlock, these drivers need to change kmalloc to
framebuffer_alloc, otherwise, they need to add their own mutexes
initialization source code:
		mutex_init(&info->lock);	mutex_init(&info->mm_lock);

here is only a record for the _old_ drivers' maintainers. hope they can
get this info from google or find this commit: 

commit 4148df9b0f38bdd362dd91d52076926c11cbe5a9
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Mon Jul 6 00:25:57 2009 +0900

    fb: Initialize fb_info mutexes in framebuffer_alloc()
    
    This way they'll be properly initialized early enough for users that
may
    touch them before the framebuffer has been registered.
    
    Drivers that allocate their fb_info structure some other way (like
    matrocfb's broken static allocation) need to be fixed up
appropriately.
    
    Signed-off-by: Paul Mundt <lethal@linux-sh.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Regards,
Wu Zhangjin

> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc:: Krzysztof Helt <krzysztof.h1@wp.pl>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: <stable@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/video/fbmem.c   |    3 ---
>  drivers/video/fbsysfs.c |    3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 53ea056..1d8d098 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1513,9 +1513,6 @@ register_framebuffer(struct fb_info *fb_info)
>  		if (!registered_fb[i])
>  			break;
>  	fb_info->node = i;
> -	mutex_init(&fb_info->lock);
> -	mutex_init(&fb_info->mm_lock);
> -
>  	fb_info->dev = device_create(fb_class, fb_info->device,
>  				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
>  	if (IS_ERR(fb_info->dev)) {
> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> index d4a2c11..60ddd1d 100644
> --- a/drivers/video/fbsysfs.c
> +++ b/drivers/video/fbsysfs.c
> @@ -58,6 +58,9 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
>  
>  	info->device = dev;
>  
> +	mutex_init(&info->lock);
> +	mutex_init(&info->mm_lock);
> +
>  #ifdef CONFIG_FB_BACKLIGHT
>  	mutex_init(&info->bl_curve_mutex);
>  #endif

