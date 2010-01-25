Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564Ab0AYNdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0AYNdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405Ab0AYNdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:33:15 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:50314 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0AYNdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ewe4DjFZvHI0Qe4mdYUtA+f1+mgVmvPzdPWY5SYi4je8YNhV5pI68zoQArRAPX4/J6
         J9dKJmRlKsGsTtzE613iz74vbKPAdhmVHxITSqJWQL4C0cJ5mVhwhCsWG+erNauLUeQN
         sjrTToIjS6MpFltGf2Vfl7CXKGn5PPiH4rZdg=
Date: Mon, 25 Jan 2010 21:33:08 +0800
From: anfei <anfei.zhou@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux@arm.linux.org.uk,
       Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] Flush dcache before writing into page to avoid alias
Message-ID: <20100125133308.GA26799@desktop>
References: <979dd0561001202107v4ddc1eb7xa59a7c16c452f7a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <979dd0561001202107v4ddc1eb7xa59a7c16c452f7a2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Jan 21, 2010 at 01:07:57PM +0800, anfei zhou wrote:
> The cache alias problem will happen if the changes of user shared mapping
> is not flushed before copying, then user and kernel mapping may be mapped
> into two different cache line, it is impossible to guarantee the coherence
> after iov_iter_copy_from_user_atomic.  So the right steps should be:
> 	flush_dcache_page(page);
> 	kmap_atomic(page);
> 	write to page;
> 	kunmap_atomic(page);
> 	flush_dcache_page(page);
> More precisely, we might create two new APIs flush_dcache_user_page and
> flush_dcache_kern_page to replace the two flush_dcache_page accordingly.
> 
> Here is a snippet tested on omap2430 with VIPT cache, and I think it is
> not ARM-specific:
> 	int val = 0x11111111;
> 	fd = open("abc", O_RDWR);
> 	addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> 	*(addr+0) = 0x44444444;
> 	tmp = *(addr+0);
> 	*(addr+1) = 0x77777777;
> 	write(fd, &val, sizeof(int));
> 	close(fd);
> The results are not always 0x11111111 0x77777777 at the beginning as expected.
> 
Is this a real bug or not necessary to support?

Thanks,
Anfei.

> Signed-off-by: Anfei <anfei.zhou@gmail.com>
> ---
>  fs/fuse/file.c |    3 +++
>  mm/filemap.c   |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index c18913a..a9f5e13 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -828,6 +828,9 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
>  		if (!page)
>  			break;
> 
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_page(page);
> +
>  		pagefault_disable();
>  		tmp = iov_iter_copy_from_user_atomic(page, ii, offset, bytes);
>  		pagefault_enable();
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 96ac6b0..07056fb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2196,6 +2196,9 @@ again:
>  		if (unlikely(status))
>  			break;
> 
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_page(page);
> +
>  		pagefault_disable();
>  		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
>  		pagefault_enable();
> -- 
> 1.6.3.1
