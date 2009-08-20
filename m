Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZHTWbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZHTWbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZHTWbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:31:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491AbZHTWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:31:15 -0400
Date: Thu, 20 Aug 2009 15:31:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       FlorianSchandinat@gmx.de
Subject: Re: [PATCH] fb: do not ignore fb_set_par errors
Message-Id: <20090820153100.eec12070.akpm@linux-foundation.org>
In-Reply-To: <1250769597-14861-2-git-send-email-FlorianSchandinat@gmx.de>
References: <1250769597-14861-1-git-send-email-FlorianSchandinat@gmx.de>
	<1250769597-14861-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Aug 2009 11:59:56 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> at the moment about half of the framebuffer drivers can return an error
> code in fb_set_par. Until now it would be silently ignored by fbmem.c
> and fbcon.c. The following patch fixes fbmem.c to pass it on but I have
> no idea what the right behaviour in fbcon.c would look like.
> Any comments?

Nobody really maintains this code any more and I don't know to whom
your question should be addressed.  All I can suggest is that you
decide what is the best path to take, and propose that we take it!  

On Thu, 20 Aug 2009 11:59:57 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> fb: do not ignore fb_set_par errors
> 
> At the moment about half of the framebuffer drivers can return an error
> code in fb_set_par. Until now it would be silently ignored by fbmem.c
> and fbcon.c. This patch fixes fbmem.c to return the error code and
> restore var on error. But it is not clear in which video mode the device
> is when fb_set_par fails. It would be good and reasonable if it were in
> the old state but there is no guarantee that this is true for all
> existing drivers.
> Although most errors should be caught by the previous fb_check_var some
> errors can't as they are dynamic (memory allocations, ...) and can only
> be detected while performing the operations which is forbidden in
> fb_check_var.
> This patch shouldn't have a negative impact on normal operation as all
> drivers return 0 on success. The impact in case of error depends heavily
> on the driver and caller but it's expected to be better than before.
> 
> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---
>  drivers/video/fbmem.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index a85c818..85c1595 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -954,6 +954,7 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
>  			goto done;
>  
>  		if ((var->activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW) {
> +			struct fb_var_screeninfo old_var;
>  			struct fb_videomode mode;
>  
>  			if (info->fbops->fb_get_caps) {
> @@ -963,10 +964,17 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
>  					goto done;
>  			}
>  
> +			old_var = info->var;
>  			info->var = *var;
>  
> -			if (info->fbops->fb_set_par)
> -				info->fbops->fb_set_par(info);
> +			if (info->fbops->fb_set_par) {
> +				ret = info->fbops->fb_set_par(info);
> +
> +				if (ret) {
> +					info->var = old_var;
> +					goto done;
> +				}
> +			}

Yes, it seems reasonable to me - if we ignore this the machine will
probably crash later anyway.

A well-behaved driver should leave the hardware in an unchanged state
if it's going to return an error (IMO).

Do you know of any bug reports which are due to this lack of checking?

If you're concerned about the effects of this change, perhaps you
should add a nice big printk when we decide to error out, so that it
makes it easier for bug reporters (and responders!) to work out what
happened?

