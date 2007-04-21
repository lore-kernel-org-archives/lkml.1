Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXDUJ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXDUJ4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXDUJ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:56:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932771AbXDUJ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:56:38 -0400
Date: Sat, 21 Apr 2007 02:55:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 03/10] lib: dampen the percpu_counter FBC_BATCH
Message-Id: <20070421025510.41f97a6a.akpm@linux-foundation.org>
In-Reply-To: <20070420155502.679143273@chello.nl>
References: <20070420155154.898600123@chello.nl>
	<20070420155502.679143273@chello.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 17:51:57 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> With the current logic the percpu_counter's accuracy delta is quadric
> wrt the number of cpus in the system, reduce this to O(n ln n).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/percpu_counter.h |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6-mm/include/linux/percpu_counter.h
> ===================================================================
> --- linux-2.6-mm.orig/include/linux/percpu_counter.h
> +++ linux-2.6-mm/include/linux/percpu_counter.h
> @@ -11,6 +11,7 @@
>  #include <linux/threads.h>
>  #include <linux/percpu.h>
>  #include <linux/types.h>
> +#include <linux/log2.h>
>  
>  #ifdef CONFIG_SMP
>  
> @@ -20,11 +21,7 @@ struct percpu_counter {
>  	s32 *counters;
>  };
>  
> -#if NR_CPUS >= 16
> -#define FBC_BATCH	(NR_CPUS*2)
> -#else
> -#define FBC_BATCH	(NR_CPUS*4)
> -#endif
> +#define FBC_BATCH	(8*ilog2(NR_CPUS))
>  
>  static inline void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
>  {

I worry that this might be too small when there are hundreds of CPUs online.

With 1024 CPUs we go for the lock once per 80 counts.  That's not much. 

If we have 1024 CPUs, each one of which is incrementing this counter at N
Hz, we have 1024/80=12 CPUs all going for the same lock at N Hz.  It could
get bad.

But I don't know what the gain is for this loss.  Your changelog should
have told us.

What problem is this patch solving?
