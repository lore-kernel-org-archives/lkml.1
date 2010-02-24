Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab0BXUMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:12:33 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59129 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757477Ab0BXUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:12:32 -0500
Date: Wed, 24 Feb 2010 15:12:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH 01/10] rcu: define __rcu address space modifier for
	sparse
Message-ID: <20100224201229.GA21067@Krystal>
References: <20100223180127.GF6700@linux.vnet.ibm.com> <1267041846-10469-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267041846-10469-2-git-send-email-arnd@arndb.de>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:10:15 up 32 days, 22:47,  6 users,  load average: 0.62, 1.18,
	1.44
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann (arnd@arndb.de) wrote:
> This is a first attempt to define an __rcu annotation
> that lets sparse check for correct use of rcu_assign_pointer()
> and rcu_dereference(). Pointers that are annotated __rcu
> must be dereferenced using rcu_dereference or the new
> __rcu_dereference and must be assigned using rcu_assign_pointer
> or the new __rcu_assign_pointer.
> 
> The new macros are used in cases where not using the
> regular accessors is proven to be correct.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/compiler.h |    2 ++
>  include/linux/rcupdate.h |   46 +++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 188fcae..6cc0857 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -10,6 +10,7 @@
>  # define __force	__attribute__((force))
>  # define __nocast	__attribute__((nocast))
>  # define __iomem	__attribute__((noderef, address_space(2)))
> +# define __rcu		__attribute__((noderef, address_space(3)))
>  # define __acquires(x)	__attribute__((context(x,0,1)))
>  # define __releases(x)	__attribute__((context(x,1,0)))
>  # define __acquire(x)	__context__(x,1)
> @@ -25,6 +26,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>  # define __force
>  # define __nocast
>  # define __iomem
> +# define __rcu
>  # define __chk_user_ptr(x) (void)0
>  # define __chk_io_ptr(x) (void)0
>  # define __builtin_warning(x, y...) (1)
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 24440f4..644e28c 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -40,6 +40,7 @@
>  #include <linux/seqlock.h>
>  #include <linux/lockdep.h>
>  #include <linux/completion.h>
> +#include <linux/compiler.h>
>  
>  /**
>   * struct rcu_head - callback structure for use with RCU
> @@ -225,13 +226,31 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   *
>   * Inserts memory barriers on architectures that require them
>   * (currently only the Alpha), and, more importantly, documents
> - * exactly which pointers are protected by RCU.
> + * exactly which pointers are protected by RCU and checks that
> + * the pointer is annotated as __rcu.
>   */
> -
>  #define rcu_dereference(p)     ({ \
> -				typeof(p) _________p1 = ACCESS_ONCE(p); \
> +				typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> +				(void) (((typeof (*p) __rcu *)p) == p); \
>  				smp_read_barrier_depends(); \
> -				(_________p1); \
> +				((typeof(*p) __force __kernel *)(_________p1)); \
> +				})
> +
> +/**
> + * __rcu_dereference - fetch an __rcu pointer outside of a
> + * read-side critical section.
> + *
> + * __rcu_dereference does not contain any barrier but only
> + * converts a __rcu pointer to one that can be dereferenced.
> + * Use this for annotating code that operates on __rcu variables
> + * for checking with sparse in places where you can be sure
> + * that no writers exist, e.g. in a write-side critical section
> + * or in an RCU call.
> + */
> +
> +#define __rcu_dereference(p)     ({ \
> +				(void) (((typeof (*p) __rcu *)p) == p); \
> +				((typeof(*p) __force __kernel *)(p)); \
>  				})
>  
>  /**
> @@ -252,9 +271,26 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>  		if (!__builtin_constant_p(v) || \
>  		    ((v) != NULL)) \
>  			smp_wmb(); \
> -		(p) = (v); \
> +		(p) = (typeof(*v) __force __rcu *)(v); \
>  	})
>  
> +/**
> + * __rcu_assign_pointer - assign a variable to an __rcu pointer
> + * without barriers.
> + * Using this is almost always a bug.
> + */
> +#define __rcu_assign_pointer(p, v) \
> +	({ \
> +		(p) = (typeof(*v) __force __rcu *)(v); \
> +	})
> +
> +/**
> + * RCU_INIT_POINTER - initialize an RCU protected member
> + * in a statically allocated data structure.
> + */
> +#define RCU_INIT_POINTER(p, v) \
> +		p = (typeof(*v) __force __rcu *)(v)

Hrm, I'm not sure about this one. It would be better to something closer to
list.h LIST_HEAD_INIT / LIST_HEAD / INIT_LIST_HEAD.  The first two are for
static declaration/init, while the last one is for runtime init. I fear that
your RCU_INIT_POINTER might be semantically confusing between static and dynamic
initialization usual semantic.

Thanks,

Mathieu

> +
>  /* Infrastructure to implement the synchronize_() primitives. */
>  
>  struct rcu_synchronize {
> -- 
> 1.6.3.3
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
