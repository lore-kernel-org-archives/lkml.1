Return-Path: <linux-kernel-owner+w=401wt.eu-S1764653AbZEHAn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764653AbZEHAn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764069AbZEHAZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:25:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764077AbZEHAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:25:54 -0400
Date: Thu, 7 May 2009 17:23:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
 around
Message-Id: <20090507172316.20a95642.akpm@linux-foundation.org>
In-Reply-To: <200904301939.51022.knikanth@novell.com>
References: <200904291221.40361.knikanth@novell.com>
	<200904301921.44615.knikanth@novell.com>
	<20090430140559.GA14696@elte.hu>
	<200904301939.51022.knikanth@novell.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 19:39:50 +0530
Nikanth Karthikesan <knikanth@novell.com> wrote:

> 
> Detect and warn on atomic_inc/atomic_dec overflow.
> 
> Add a debug option to detect and warn when the 32-bit atomic_t overflows
> during atomic_inc and atomic_dec.
> 
>
> ...
>
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -4,15 +4,51 @@
>   * Copyright (C) 2005 Silicon Graphics, Inc.
>   *	Christoph Lameter
>   *
> - * Allows to provide arch independent atomic definitions without the need to
> - * edit all arch specific atomic.h files.
>   */
>  
> +#include <linux/kernel.h>
>  #include <asm/types.h>
> +#include <asm/bug.h>

We're going to have real trouble making changes like this to a
low-level header file - sparc64 results below.

> +/**
> + * atomic_inc - increment atomic variable
> + * @v: pointer of type atomic_t
> + *
> + * Atomically increments @v by 1.
> + */
> +static inline void atomic_inc(atomic_t *v)
> +{
> +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> +	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),
> +		KERN_ERR "atomic inc overflow!");
> +#endif
> +	raw_atomic_inc(v);
> +}

Are we allowed to assume that atomic_inc==raw_atomic_inc for all
architectures which use this definition?

Do we know that atomic_read() is defined at this point?


We can avoid the problematic includes via

extern void atomic_inc_screwed_up(atomic_t *v);

static inline void atomic_inc(atomic_t *v)
{
#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
	if (atomic_read(v) > (INT_MAX / 2))
		atomic_inc_screwed_up(v);
#endif
	raw_atomic_inc(v);
}


In file included from /usr/src/devel/arch/sparc/include/asm/atomic_64.h:117,
                 from /usr/src/devel/arch/sparc/include/asm/atomic.h:4,
                 from include/linux/debug_locks.h:5,
                 from include/linux/lockdep.h:19,
                 from include/linux/spinlock_types.h:18,
                 from include/linux/spinlock.h:80,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:54,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/asm-generic/atomic.h:20: error: syntax error before numeric constant
include/asm-generic/atomic.h:21: warning: static declaration of 'atomic_add' follows non-static declaration
/usr/src/devel/arch/sparc/include/asm/atomic_64.h:22: warning: previous declaration of 'atomic_add' was here
include/asm-generic/atomic.h: In function `atomic_add':
include/asm-generic/atomic.h:21: error: number of arguments doesn't match prototype
/usr/src/devel/arch/sparc/include/asm/atomic_64.h:22: error: prototype declaration
include/asm-generic/atomic.h:26: error: implicit declaration of function `raw_atomic_inc'
include/asm-generic/atomic.h:26: error: `v' undeclared (first use in this function)
include/asm-generic/atomic.h:26: error: (Each undeclared identifier is reported only once
include/asm-generic/atomic.h:26: error: for each function it appears in.)
include/asm-generic/atomic.h: At top level:
include/asm-generic/atomic.h:35: error: syntax error before numeric constant
include/asm-generic/atomic.h:36: warning: static declaration of 'atomic_sub' follows non-static declaration
/usr/src/devel/arch/sparc/include/asm/atomic_64.h:24: warning: previous declaration of 'atomic_sub' was here
include/asm-generic/atomic.h: In function `atomic_sub':
include/asm-generic/atomic.h:36: error: number of arguments doesn't match prototype
/usr/src/devel/arch/sparc/include/asm/atomic_64.h:24: error: prototype declaration
include/asm-generic/atomic.h:41: error: implicit declaration of function `raw_atomic_dec'
include/asm-generic/atomic.h:41: error: `v' undeclared (first use in this function)

