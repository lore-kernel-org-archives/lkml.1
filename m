Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbZDQXlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbZDQXlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZDQXlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:41:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38636 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZDQXlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:41:15 -0400
Date: Fri, 17 Apr 2009 16:41:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/5] RCU: Don't try and predeclare inline funcs as it
	upsets some versions of gcc
Message-ID: <20090417234114.GF6742@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk> <20090415183501.11029.81607.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415183501.11029.81607.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 07:35:01PM +0100, David Howells wrote:
> Don't try and predeclare inline funcs like this:
> 
> 	static inline void wait_migrated_callbacks(void)
> 	...
> 	static void _rcu_barrier(enum rcu_barrier type)
> 	{
> 		...
> 		wait_migrated_callbacks();
> 	}
> 	...
> 	static inline void wait_migrated_callbacks(void)
> 	{
> 		wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
> 	}
> 
> as it upsets some versions of gcc under some circumstances:
> 
> 	kernel/rcupdate.c: In function `_rcu_barrier':
> 	kernel/rcupdate.c:125: sorry, unimplemented: inlining failed in call to 'wait_migrated_callbacks': function body not available
> 	kernel/rcupdate.c:152: sorry, unimplemented: called from here
> 
> This can be dealt with by simply putting the static variables (rcu_migrate_*)
> at the top, and moving the implementation of the function up so that it
> replaces its forward declaration.

Looks good to me!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  kernel/rcupdate.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 2c7b845..a967c9f 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -58,6 +58,10 @@ static DEFINE_MUTEX(rcu_barrier_mutex);
>  static struct completion rcu_barrier_completion;
>  int rcu_scheduler_active __read_mostly;
> 
> +static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
> +static struct rcu_head rcu_migrate_head[3];
> +static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
> +
>  /*
>   * Awaken the corresponding synchronize_rcu() instance now that a
>   * grace period has elapsed.
> @@ -122,7 +126,10 @@ static void rcu_barrier_func(void *type)
>  	}
>  }
> 
> -static inline void wait_migrated_callbacks(void);
> +static inline void wait_migrated_callbacks(void)
> +{
> +	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
> +}
> 
>  /*
>   * Orchestrate the specified type of RCU barrier, waiting for all
> @@ -179,21 +186,12 @@ void rcu_barrier_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> 
> -static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
> -static struct rcu_head rcu_migrate_head[3];
> -static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
> -
>  static void rcu_migrate_callback(struct rcu_head *notused)
>  {
>  	if (atomic_dec_and_test(&rcu_migrate_type_count))
>  		wake_up(&rcu_migrate_wq);
>  }
> 
> -static inline void wait_migrated_callbacks(void)
> -{
> -	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
> -}
> -
>  static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
>  		unsigned long action, void *hcpu)
>  {
> 
