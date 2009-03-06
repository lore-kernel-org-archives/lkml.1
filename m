Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZCFXEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZCFXEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZCFXEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:04:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbZCFXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:04:13 -0500
Date: Fri, 6 Mar 2009 15:03:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -v2] memdup_user(): introduce
Message-Id: <20090306150335.c512c1b6.akpm@linux-foundation.org>
In-Reply-To: <49B0F1B9.1080903@cn.fujitsu.com>
References: <49B0CAEC.80801@cn.fujitsu.com>
	<20090306082056.GB3450@x200.localdomain>
	<49B0DE89.9000401@cn.fujitsu.com>
	<20090306003900.a031a914.akpm@linux-foundation.org>
	<49B0E67C.2090404@cn.fujitsu.com>
	<20090306011548.ffdf9cbc.akpm@linux-foundation.org>
	<49B0F1B9.1080903@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 17:49:45 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> I notice there are many places doing copy_from_user() which follows
> kmalloc():
> 
>         dst = kmalloc(len, GFP_KERNEL);
>         if (!dst)
>                 return -ENOMEM;
>         if (copy_from_user(dst, src, len)) {
> 		kfree(dst);
> 		return -EFAULT
> 	}
> 
> memdup_user() is a wrapper of the above code. With this new function,
> we don't have to write 'len' twice, which can lead to typos/mistakes.
> It also produces smaller code and kernel text.
> 
> A quick grep shows 250+ places where memdup_user() *may* be used. I'll
> prepare a patchset to do this conversion.
> 
> v1 -> v2: change the name from kmemdup_from_user to memdup_user.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> Can this get into 2.6.29, so I can prepare patches based on linux-next?
> And this won't cause regression, since no one uses it yet. :)

I'd be OK with doing that from a patch logistics point of view, but I'd
prefer to leave a patch like this for a few days to gather more
feedback from other developers, which might push this into 2.6.30.


> diff --git a/include/linux/string.h b/include/linux/string.h
> index 76ec218..79f30f3 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -12,6 +12,7 @@
>  #include <linux/stddef.h>	/* for NULL */
>  
>  extern char *strndup_user(const char __user *, long);
> +extern void *memdup_user(const void __user *, size_t, gfp_t);
>  
>  /*
>   * Include machine specific inline routines
> diff --git a/mm/util.c b/mm/util.c
> index 37eaccd..3d21c21 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -70,6 +70,32 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
>  EXPORT_SYMBOL(kmemdup);
>  
>  /**
> + * memdup_user - duplicate memory region from user space
> + *
> + * @src: source address in user space
> + * @len: number of bytes to copy
> + * @gfp: GFP mask to use
> + *
> + * Returns an ERR_PTR() on failure.
> + */
> +void *memdup_user(const void __user *src, size_t len, gfp_t gfp)
> +{
> +	void *p;
> +
> +	p = kmalloc_track_caller(len, gfp);
> +	if (!p)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (copy_from_user(p, src, len)) {
> +		kfree(p);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	return p;
> +}
> +EXPORT_SYMBOL(memdup_user);
> +
> +/**
>   * __krealloc - like krealloc() but don't free @p.
>   * @p: object to reallocate memory for.
>   * @new_size: how many bytes of memory are required.
> -- 
> 1.5.4.rc3
