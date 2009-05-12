Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZELROY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZELROY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZELRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:13:26 -0400
Received: from kroah.org ([198.145.64.141]:35188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbZELRNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:13:24 -0400
Date: Tue, 12 May 2009 09:29:08 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] kobject : kobject_set_name_vargs leak fix
Message-ID: <20090512162908.GF16247@kroah.com>
References: <a8e1da0905102316v1037c89cs48cb052924c250a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0905102316v1037c89cs48cb052924c250a9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 02:16:36PM +0800, Dave Young wrote:
> kobject_set_name_vargs will leak the old_name when return -ENOMEM,
> move the kfree(old_name) before the return path.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
> lib/kobject.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -uprN linux.old/lib/kobject.c linux.new/lib/kobject.c
> --- linux.old/lib/kobject.c	2009-05-11 13:59:01.000000000 +0800
> +++ linux.new/lib/kobject.c	2009-05-11 13:59:34.000000000 +0800
> @@ -221,6 +221,7 @@ int kobject_set_name_vargs(struct kobjec
>  	if (kobj->name && !fmt)
>  		return 0;
> 
> +	kfree(old_name);
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>  	if (!kobj->name)
>  		return -ENOMEM;
> @@ -229,7 +230,6 @@ int kobject_set_name_vargs(struct kobjec
>  	while ((s = strchr(kobj->name, '/')))
>  		s[0] = '!';
> 
> -	kfree(old_name);
>  	return 0;
>  }

No, it would be safer to put the kobj->name pointer back to old_name if
the kvasprintf() call failed.  That way the caller can properly clean up
if needed.

Care to respin this?

thanks,

greg k-h
