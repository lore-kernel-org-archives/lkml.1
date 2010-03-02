Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0CBAiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:38:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab0CBAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:38:05 -0500
Date: Mon, 1 Mar 2010 16:37:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, Alex Viskovatoff <viskovatoff@imap.cc>
Subject: Re: [PATCH] ufs: make solaris fsck happy
Message-Id: <20100301163754.889bd7a7.akpm@linux-foundation.org>
In-Reply-To: <20100225184743.GA13772@rain>
References: <20100225184743.GA13772@rain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 21:47:43 +0300
Evgeniy Dushistov <dushistov@mail.ru> wrote:

> --- a/fs/ufs/ufs_fs.h
> +++ b/fs/ufs/ufs_fs.h
> @@ -227,11 +227,16 @@ typedef __u16 __bitwise __fs16;
>   */
>  #define ufs_cbtocylno(bno) \
>  	((bno) * uspi->s_nspf / uspi->s_spc)
> -#define ufs_cbtorpos(bno) \
> +#define ufs_cbtorpos(bno)				      \
> +	((UFS_SB(sb)->s_flags & UFS_CG_SUN) ?		      \
> +	 (((((bno) * uspi->s_nspf % uspi->s_spc) %	      \
> +	    uspi->s_nsect) *				      \
> +	   uspi->s_nrpos) / uspi->s_nsect)		      \
> +	 :						      \
>  	((((bno) * uspi->s_nspf % uspi->s_spc / uspi->s_nsect \
>  	* uspi->s_trackskew + (bno) * uspi->s_nspf % uspi->s_spc \
>  	% uspi->s_nsect * uspi->s_interleave) % uspi->s_nsect \
> -	* uspi->s_nrpos) / uspi->s_npsect)
> +	  * uspi->s_nrpos) / uspi->s_npsect))

yikes, that macro should be killed with a stick before it becomes
self-aware and starts breeding.

Or converted into a C function which humans have a chance of
understanding and maintaining.

