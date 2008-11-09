Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYKITgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYKITgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYKITgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:36:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645AbYKITgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:36:15 -0500
Date: Sun, 9 Nov 2008 11:36:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: JosephChan@via.com.tw, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-Id: <20081109113603.d45361ad.akpm@linux-foundation.org>
In-Reply-To: <20081109202537.33ead0a2@neptune.home>
References: <20081109202537.33ead0a2@neptune.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 20:25:37 +0100 Bruno Pr__mont <bonbons@linux-vserver.org> wrote:

> The function viafb_cursor() uses 2 stack-variables of CURSOR_SIZE bits;
> CURSOR_SIZE is defined as (8 * 1024). Using up twice 1k on stack is too much
> for 4k-stack (though it works with 8k-stacks).

yup, we should fix that.

> Make those two variables kzalloc'ed to preserve stack space.
> 
> Signed-off-by: Bruno Pr__mont <bonbons@linux-vserver.org>
> 
> ---
> --- linux-2.6.28-rc3.orig/drviers/video/via/viafbdev.c	2008-11-09 19:22:15.000000000 +0100

                              ^^  typo in pathname?

> +++ linux-2.6.28-rc3/drivers/video/via/viafbdev.c	2008-11-09 19:36:15.000000000 +0100
> @@ -1052,10 +1052,8 @@ static void viafb_imageblit(struct fb_in
>  
>  static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
>  {
> -	u8 data[CURSOR_SIZE / 8];
> -	u32 data_bak[CURSOR_SIZE / 32];
>  	u32 temp, xx, yy, bg_col = 0, fg_col = 0;
> -	int size, i, j = 0;
> +	int i, j = 0;
>  	static int hw_cursor;
>  	struct viafb_par *p_viafb_par;
>  
> @@ -1178,10 +1176,15 @@ static int viafb_cursor(struct fb_info *
>  	}
>  
>  	if (cursor->set & FB_CUR_SETSHAPE) {
> -		size =
> +		u8 *data = kzalloc(CURSOR_SIZE / 8, GFP_KERNEL);
> +		u32 *data_bak = kzalloc(CURSOR_SIZE / 32, GFP_KERNEL);
> +		int size =
>  		    ((viacursor.image.width + 7) >> 3) *
>  		    viacursor.image.height;
>  
> +		if (data == NULL || data_bak == NULL)
> +			goto out;
> +
>  		if (MAX_CURS == 32) {
>  			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
>  				data_bak[i] = 0x0;
> @@ -1231,6 +1234,9 @@ static int viafb_cursor(struct fb_info *
>  		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
>  		       ((struct viafb_par *)(info->par))->cursor_start,
>  		       data_bak, CURSOR_SIZE);
> +out:
> +		kfree(data);
> +		kfree(data_bak);
>  	}
>  
>  	if (viacursor.enable)

Is the ->fb_cursor handler allowed to perform GFP_KERNEL memory
allocations?  It's never called from atomic contexts?

