Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYA1FeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYA1FeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYA1FdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:33:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbYA1FdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:33:18 -0500
Date: Sun, 27 Jan 2008 21:33:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] linux/types.h: always export 64bit aligned defines
Message-Id: <20080127213319.01026b19.akpm@linux-foundation.org>
In-Reply-To: <200801260423.21860.vapier@gentoo.org>
References: <200801260423.21860.vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008 04:23:21 -0500 Mike Frysinger <vapier@gentoo.org> wrote:

> Some kernel headers exported to userspace rely on these 64bit aligned defines.
> However, they are hidden behind __KERNEL_STRICT_NAMES at the moment which
> means most of the time, they're never actually available.  These these defines
> dont actually conflict with normal userspace / C library types, there's no
> reason to hide them behind the __KERNEL_STRICT_NAMES define.
> 

Maybe we shouldn't be using these helper macros in exported-to-userspace
headers.  Do you know which headers are affected?  Did you consider jsut
expanding the macros in situ for thse cases?


> ---
>  include/linux/types.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index f4f8d19..b80a263 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -125,11 +125,6 @@ typedef		__u64		u_int64_t;
>  typedef		__s64		int64_t;
>  #endif
>  
> -/* this is a special 64bit data type that is 8-byte aligned */
> -#define aligned_u64 unsigned long long __attribute__((aligned(8)))
> -#define aligned_be64 __be64 __attribute__((aligned(8)))
> -#define aligned_le64 __le64 __attribute__((aligned(8)))
> -
>  /**
>   * The type used for indexing onto a disc or disc partition.
>   *
> @@ -161,6 +156,11 @@ typedef unsigned long blkcnt_t;
>  
>  #endif /* __KERNEL_STRICT_NAMES */
>  
> +/* this is a special 64bit data type that is 8-byte aligned */
> +#define aligned_u64 unsigned long long __attribute__((aligned(8)))
> +#define aligned_be64 __be64 __attribute__((aligned(8)))
> +#define aligned_le64 __le64 __attribute__((aligned(8)))
> +
>  /*
>   * Below are truly Linux-specific types that should never collide with
>   * any application/library that wants linux/types.h.

Seems relatively harmless.

But I'd have thought that if we're going to do this, we should create a
standard naming convention for types which the kernel exports to userspace.
Say, kern_*.

In which case the change becomes:

#define kern_aligned_u64 unsigned long long __attribute__((aligned(8)))
#define kern_aligned_be64 __be64 __attribute__((aligned(8)))
#define kern_aligned_le64 __le64 __attribute__((aligned(8)))

(exported to userspace)

and, inside __KERNEL__:

#define aligned_u64 kern_aligned_u64

etc.  And, of course, all those bit of kernel headers which are presently
using aligned_u64 in exposed-to-userspace places should be switched to
kern_aligned_u4.


What thinkest thou?

If _that_ is all sane then we should do it all in a singe header file, say
kern_types_for_userspace.h.  include/linux/types.h would then do:

#include <linux/kern_types_for_userspace.h>

#ifdef __KERNEL__
#define aligned_u64 kern_aligned_u64
etc...

(all approximate, you-get-what-I-mean)

Duno if it'd be worth the effort, but it is The Right Thing To Do.

