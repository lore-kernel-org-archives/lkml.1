Return-Path: <linux-kernel-owner+w=401wt.eu-S935212AbXLNWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212AbXLNWn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935193AbXLNWlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:41:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935179AbXLNWly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:41:54 -0500
Date: Fri, 14 Dec 2007 14:23:10 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] kobject_add error handling when set name failed
Message-ID: <20071214222310.GC29375@suse.de>
References: <20071214092405.GA3361@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214092405.GA3361@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 05:24:05PM +0800, Dave Young wrote:
> In kobject_add, when kobject_set_name failed we should put the kobj and return.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> lib/kobject.c |   11 ++++++++---
> 1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff -upr linux/lib/kobject.c linux.new/lib/kobject.c
> --- linux/lib/kobject.c	2007-12-14 17:14:03.000000000 +0800
> +++ linux.new/lib/kobject.c	2007-12-14 17:17:48.000000000 +0800
> @@ -228,8 +228,13 @@ int kobject_add(struct kobject * kobj)
>  
>  	if (!(kobj = kobject_get(kobj)))
>  		return -ENOENT;
> -	if (!kobj->k_name)
> -		kobject_set_name(kobj, "NO_NAME");
> +	if (!kobj->k_name) {
> +		error = kobject_set_name(kobj, "NO_NAME"));
> +		if (error) {
> +			kobject_put(kobj);
> +			return error;
> +		}
> +	}

Thanks, but I have a pending patch from Kay in my inbox that messes up
this patch, as it drops most of this nonsense :)

>  	if (!*kobj->k_name) {
>  		pr_debug("kobject (%p) attempted to be registered with no "
>  			 "name!\n", kobj);
> @@ -371,7 +376,7 @@ void kobject_init_ng(struct kobject *kob
>  		goto error;
>  	}
>  	if (!ktype) {
> -		err_str = "must have a ktype to be initialized properly!\n";
> +		err_str = "must have a ktype to be initialized properly!";
>  		goto error;

Oops, good catch, I'll just go add this change to my tree.

thanks,

greg k-h
