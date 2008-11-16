Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYKPEpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYKPEpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYKPEp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:45:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:1478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYKPEp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:45:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KS3uFJzuj/AECmGizPlz7iZNJzJ++EEkcZxXdbS0dLtH29vbvTuzyh4XMWnLcbgKuO
         9zwwcikSiE7qXMyFhDy6CKRsL9ppU4dgo9J8mIgAn9uovB93KeYWWX/ezA/J75eionls
         KEe92hRQdC8etXApSdD/MwEiNoBosCWuD0qww=
Date: Sun, 16 Nov 2008 07:49:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-ID: <20081116044901.GA24624@x200.localdomain>
References: <491FA28B.2070003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FA28B.2070003@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 12:33:15PM +0800, Lai Jiangshan wrote:
> some subsystem needs vmalloc() when required memory is large.
> but current kernel has not APIs for this requirement.

It doesn't mean there should be such an API.

> this patch introduces simple_malloc() and simple_free().

Grossly misnamed. It should be kvmalloc/kvfree, at least.

> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -278,6 +279,36 @@ static inline int is_vmalloc_addr(const void *x)
>  #endif
>  }
>  
> +static inline void *__simple_malloc(unsigned long size, int pages_hint)
> +{
> +	if (size <= PAGE_SIZE * pages_hint)
> +		return kmalloc(size, GFP_KERNEL);
> +	else
> +		return vmalloc(size);
> +}
> +
> +/**
> + * simple_malloc - allocate memory by kmalloc() or vmalloc()
> + *
> + * if @size <= PAGE_SIZE, memory is allocated by kmalloc(),
> + * otherwise by vmalloc()
> + */
> +static inline void *simple_malloc(unsigned long size)
> +{
> +	return __simple_malloc(size, 1);
> +}
> +
> +/**
> + * simple_free - free the memory by kfree(), or vfree() if it is vmalloc addr
> + */
> +static inline void simple_free(void *ptr)
> +{
> +	if (is_vmalloc_addr(ptr))
> +		vfree(ptr);
> +	else
> +		kfree(ptr);
> +}
