Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087Ab0ATJww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0ATJww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867Ab0ATJwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:52:49 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:56597 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab0ATJwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S7MSE53CIvX3bMWWkrOZ/jooNmcqXu4QCSyBoG80eirIw/DLavYcZkRtJUPYJZEpjM
         AA0MsjZRmh/3AcKhIKZj0UicprF3eN85O6nAVyH3iIFA8YVHidGBbD+kch43paXcSyg2
         lL//DK4gAolY7KN3pho5tbLgT6n+boC/YLElU=
Date: Wed, 20 Jan 2010 17:52:42 +0800
From: anfei <anfei.zhou@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux@arm.linux.org.uk,
       jamie@shareable.org
Subject: Re: cache alias in mmap + write
Message-ID: <20100120095242.GA5672@desktop>
References: <20100120082610.GA5155@desktop> <20100120174630.4071.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120174630.4071.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 06:10:11PM +0900, KOSAKI Motohiro wrote:
> Hello,
> 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 96ac6b0..07056fb 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2196,6 +2196,9 @@ again:
> >  		if (unlikely(status))
> >  			break;
> >  
> > +		if (mapping_writably_mapped(mapping))
> > +			flush_dcache_page(page);
> > +
> >  		pagefault_disable();
> >  		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
> >  		pagefault_enable();
> 
> I'm not sure ARM cache coherency model. but I guess correct patch is here.
> 
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_page(page);
> +
>  		pagefault_disable();
>  		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
>  		pagefault_enable();
> -		flush_dcache_page(page);
> 
> 
> Why do we need to call flush_dcache_page() twice?
> 
The latter flush_dcache_page is used to flush the kernel changes
(iov_iter_copy_from_user_atomic), which makes the userspace to see the
write,  and the one I added is used to flush the userspace changes.
And I think it's better to split this function into two:
	flush_dcache_user_page(page);
	kmap_atomic(page);
	write to  page;
	kunmap_atomic(page);
	flush_dcache_kern_page(page);
But currently there is no such API.
> 
> 
> 
