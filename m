Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbZARLCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbZARLCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 06:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762809AbZARLCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 06:02:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52538 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762645AbZARLCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 06:02:39 -0500
Date: Sun, 18 Jan 2009 12:02:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-ID: <20090118110221.GA29602@elte.hu>
References: <1232273454.23100.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232273454.23100.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> diff --git a/include/linux/acct.h b/include/linux/acct.h
> index 882dc72..a20c97c 100644
> --- a/include/linux/acct.h
> +++ b/include/linux/acct.h
> @@ -59,9 +59,13 @@ struct acct
>  	comp_t		ac_majflt;		/* Major Pagefaults */
>  	comp_t		ac_swaps;		/* Number of Swaps */
>  /* m68k had no padding here. */
> -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> +#ifdef __KERNEL__
> +#ifndef CONFIG_M68K
>  	__u16		ac_ahz;			/* AHZ */
> -#endif
> +#endif /* CONFIG_M68K */
> +#else /* __KERNEL__ */
> +	__u16		ac_ahz;			/* AHZ */
> +#endif /* __KERNEL__ */

that looks rather ugly.

Why not just flip it around to:

	#if !defined(__KERNEL__) || !defined(CONFIG_M68K)

? Does headers_check misinterpret that?

>   * To make everything easier to port and manage cross platform
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 343df9e..1202063 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -528,6 +528,7 @@ struct sysinfo {
>  /* Trap pasters of __FUNCTION__ at compile-time */
>  #define __FUNCTION__ (__func__)
>  
> +#ifdef __KERNEL__
>  /* This helps us to avoid #ifdef CONFIG_NUMA */
>  #ifdef CONFIG_NUMA
>  #define NUMA_BUILD 1
> @@ -540,4 +541,8 @@ struct sysinfo {
>  # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
>  #endif
>  
> +#else /* __KERNEL__ */
> +#define NUMA_BUILD 0
> +#endif /* __KERNEL__ */

Does NUMA_BUILD make any sense to user-space at all? Shouldnt we leave it 
undefined?

> --- a/include/linux/pktcdvd.h
> +++ b/include/linux/pktcdvd.h
> @@ -33,11 +33,15 @@
>   * able to sucessfully recover with this option (drive will return good
>   * status as soon as the cdb is validated).
>   */
> +#ifdef __KERNEL__
>  #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
>  #define USE_WCACHING		1
>  #else
>  #define USE_WCACHING		0
>  #endif
> +#else /* __KERNEL__ */
> +#define USE_WCACHING		0
> +#endif /* __KERNEL__ */

does USE_WCACHING make any sense to user-space? Shouldnt we leave it 
undefined?

> diff --git a/include/linux/raw.h b/include/linux/raw.h
> index 62d543e..3898e30 100644
> --- a/include/linux/raw.h
> +++ b/include/linux/raw.h
> @@ -13,6 +13,10 @@ struct raw_config_request
>  	__u64	block_minor;
>  };
>  
> +#ifdef __KERNEL__
>  #define MAX_RAW_MINORS CONFIG_MAX_RAW_DEVS
> +#else /* __KERNEL__ */
> +#define MAX_RAW_MINORS 0
> +#endif /* __KERNEL__ */

ditto.

>  #endif /* __LINUX_RAW_H */
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index f5771a2..d7daa52 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -256,11 +256,15 @@ struct ucred {
>  #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exit for file
>  					   descriptor received through
>  					   SCM_RIGHTS */
> +#ifdef __KERNEL__
>  #if defined(CONFIG_COMPAT)
>  #define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
>  #else
>  #define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
>  #endif
> +#else /* __KERNEL__ */
> +#define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
> +#endif /* __KERNEL__ */

I suspect this flag should always be defined for user-space - the zero 
value only makes sense in the kernel.

> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -138,6 +138,7 @@ typedef		__s64		int64_t;
>   *
>   * blkcnt_t is the type of the inode's block count.
>   */
> +#ifdef __KERNEL__
>  #ifdef CONFIG_LBD
>  typedef u64 sector_t;
>  typedef u64 blkcnt_t;
> @@ -145,6 +146,10 @@ typedef u64 blkcnt_t;
>  typedef unsigned long sector_t;
>  typedef unsigned long blkcnt_t;
>  #endif
> +#else /* __KERNEL__ */
> +typedef unsigned long sector_t;
> +typedef unsigned long blkcnt_t;
> +#endif /* __KERNEL__ */

heh. types.h itself is not headers_check clean.

But this isnt particularly clean: we have now 3 blocks of typedefs while 
there are just 2 variants. It would be cleaner to do something like:

#if !defined(__KERNEL__) || defined(CONFIG_LBD)

i.e. always provide the wider type to user-space.

	ngo
