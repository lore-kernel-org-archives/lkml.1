Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbXEKIdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbXEKIdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXEKIde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:33:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbXEKIdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:33:33 -0400
Date: Fri, 11 May 2007 01:33:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org, jorge@laser.satlink.net, agulbra@nvg.unit.no,
       netdev@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [-mm patch] make csum_and_copy_from_user arch independent (was
 Re: 2.6.21-mm2)
Message-Id: <20070511013317.3c6441f3.akpm@linux-foundation.org>
In-Reply-To: <20070511082738.GA23560@slug>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<20070511082738.GA23560@slug>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 10:27:38 +0200 Frederik Deweerdt <deweerdt@free.fr> wrote:

> On Wed, May 09, 2007 at 01:23:22AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> > 
> 
> ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!
> 
> Linking on ARM fails because albeit a generic csum_and_copy_from_user()
> function is provided in the case ! _HAVE_ARCH_COPY_AND_CSUM_FROM_USER, the
> generic function uses csum_partial_copy_from_user() which is i386 only.
> 
> The following patch uses copy_from_user() followed by csum_partial()
> to make the function platform independent.
> 
> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/include/net/checksum.h b/include/net/checksum.h
> index 1242461..2eebb95 100644
> --- a/include/net/checksum.h
> +++ b/include/net/checksum.h
> @@ -30,13 +30,16 @@ static inline
>  __wsum csum_and_copy_from_user (const void __user *src, void *dst,
>  				      int len, __wsum sum, int *err_ptr)
>  {
> -	if (access_ok(VERIFY_READ, src, len))
> -		return csum_partial_copy_from_user(src, dst, len, sum, err_ptr);
> +	if (access_ok(VERIFY_READ, src, len)) {
> +		if (copy_from_user(dst, src, len))
> +			return -EFAULT;
> +		return csum_partial(dst, len, sum);
> +	}
>  
>  	if (len)
>  		*err_ptr = -EFAULT;
>  
> -	return sum;
> +	return (__force __wsum)-1; /* invalid checksum */
>  }
>  #endif
>  

hm.  Please cc netdev on net patches.
