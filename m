Return-Path: <linux-kernel-owner+w=401wt.eu-S935066AbXKPVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbXKPVnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760853AbXKPVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:42:50 -0500
Received: from namei.org ([69.55.235.186]:52409 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758858AbXKPVmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:42:49 -0500
Date: Sat, 17 Nov 2007 08:42:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] mmap: round mmap hint address above mmap_min_addr
In-Reply-To: <1195246486.2924.87.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0711170841200.22208@us.intercode.com.au>
References: <1195246486.2924.87.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Eric Paris wrote:

> +#ifdef CONFIG_SECURITY
> +	/*
> +	 * If a hint addr is less than mmap_min_addr change addr to be as
> +	 * low as possible but still greater than mmap_min_addr
> +	 */
> +	if (!(flags & MAP_FIXED) && ((void *)addr != NULL) &&
> +	    (addr < mmap_min_addr))
> +		addr = PAGE_ALIGN(mmap_min_addr);
> +#endif

Please make this a static inline which is optimized away with 
!CONFIG_SECURITY.


> +
>  	error = arch_mmap_check(addr, len, flags);
>  	if (error)
>  		return error;
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 35622c5..ea4d20a 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -829,6 +829,16 @@ unsigned long do_mmap_pgoff(struct file *file,
>  	void *result;
>  	int ret;
>  
> +#ifdef CONFIG_SECURITY
> +	/*
> +	 * If a hint addr is less than mmap_min_addr change addr to be as
> +	 * low as possible, but still greater than mmap_min_addr
> +	 */
> +	if (!(flags & MAP_FIXED) && ((void *)addr != NULL) &&
> +	    (addr < mmap_min_addr))
> +		addr = PAGE_ALIGN(mmap_min_addr);
> +#endif
> +
>  	/* decide whether we should attempt the mapping, and if so what sort of
>  	 * mapping */
>  	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
> 
> 

-- 
James Morris
<jmorris@namei.org>
