Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbZBYUJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbZBYUJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbZBYUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:09:40 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57141 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbZBYUJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:09:40 -0500
Date: Wed, 25 Feb 2009 21:11:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kyle McMartin <kyle@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Make exported headers use strict posix types
Message-ID: <20090225201131.GA26110@uranus.ravnborg.org>
References: <20090225032553.GD6690@bombadil.infradead.org> <49A4F051.3000706@zytor.com> <20090225072202.GI6690@bombadil.infradead.org> <200902251917.49017.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902251917.49017.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 07:17:47PM +0100, Arnd Bergmann wrote:
> A number of standard posix types are used in exported headers, which
> is not allowed if __STRICT_KERNEL_NAMES is defined. In order to
> get rid of the non-__STRICT_KERNEL_NAMES part and to make sane headers
> the default, we have to change them all to safe types.
> 
> There are also still some leftovers in reiserfs_fs.h, elfcore.h
> and coda.h, but these files have not compiled in user space for
> a long time.
> 
> This leaves out the various integer types (u_int32_t, uint32_t, u32,
> uint and the signed and 8/16/64 bit variants thereof), which we may
> want to do in an automated script instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> This is my previous patch, ported to today's git. It's my last day
> before my vacation, so I can't do the usual testing etc. on it.
> Hopefully somebody else can take care of this.

I hesitate to put it in kbuild.git... Any better place?

> diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
> index 07ae8f8..ebdc055 100644
> --- a/include/linux/coda_psdev.h
> +++ b/include/linux/coda_psdev.h
> @@ -6,6 +6,7 @@
>  #define CODA_PSDEV_MAJOR 67
>  #define MAX_CODADEVS  5	   /* how many do we allow */
>  
> +#ifdef __KERNEL__
>  struct kstatfs;
>  
>  /* communication pending/processing queues */
> @@ -89,4 +90,5 @@ struct upc_req {
>  
>  extern struct venus_comm coda_comms[];
>  
> +#endif /* __KERNEL__ */
>  #endif

Does this change really belong in this patchset?

> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 0999271..f6dcc29 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -4,7 +4,7 @@
>  
>  /* GCC 4.1.[01] miscompiles __weak */
>  #if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> -# error Your version of gcc miscompiles the __weak directive
> +// # error Your version of gcc miscompiles the __weak directive
>  #endif
>  
>  #define __used			__attribute__((__used__))

Yes - I can build kernels again. But I think we should skip this change..

> diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
> index 5375fac..43dc97e 100644
> --- a/include/linux/mroute6.h
> +++ b/include/linux/mroute6.h
> @@ -65,7 +65,7 @@ struct mif6ctl {
>  	mifi_t	mif6c_mifi;		/* Index of MIF */
>  	unsigned char mif6c_flags;	/* MIFF_ flags */
>  	unsigned char vifc_threshold;	/* ttl limit */
> -	u_short	 mif6c_pifi;		/* the index of the physical IF */
> +	__u16	 mif6c_pifi;		/* the index of the physical IF */
>  	unsigned int vifc_rate_limit;	/* Rate limiter values (NI) */
>  };
>  
This change looks correct - but I assume this is a separate patch.

Rest looks good.

	Sam
