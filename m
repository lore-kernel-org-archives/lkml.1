Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbZE2Ucp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbZE2Ucp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZE2Uch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:32:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbZE2Ucg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:32:36 -0400
Date: Fri, 29 May 2009 13:31:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: rusty@rustcorp.com.au, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] cpuhotplug: introduce try_get_online_cpus()
Message-Id: <20090529133118.1c7b16c2.akpm@linux-foundation.org>
In-Reply-To: <4A1F9CEE.5090305@cn.fujitsu.com>
References: <4A1F9CEE.5090305@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 16:29:34 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> get_online_cpus() is a typically coarsely granular lock.
> It's a source of ABBA deadlock.
> 
> Thanks to the CPU notifiers, Some subsystem's global lock will
> be required after cpu_hotplug.rwlock. Subsystem's global lock
> is coarsely granular lock too, thus a lot's of lock in kernel
> should be required after cpu_hotplug.rwlock(if we need
> cpu_hotplug.rwlock held too)
> 
> Otherwise it may come to a ABBA deadlock like this:
> 
> thread 1                                      |        thread 2
> _cpu_down()                                   |  Lock a-kernel-lock.
>   cpu_hotplug_begin()                         |
>     down_write(&cpu_hotplug.rwlock)           |
>   __raw_notifier_call_chain(CPU_DOWN_PREPARE) |  get_online_cpus()
> ------------------------------------------------------------------------
>     Lock a-kernel-lock.(wait thread2)         |    down_read(&cpu_hotplug.rwlock)
>                                                    (wait thread 1)
> 
> But CPU online/offline are happened very rarely, get_online_cpus()
> returns success quickly in all probability.
> So it's an asinine behavior that get_online_cpus() is not allowed
> to be required after we had held "a-kernel-lock".
> 
> To dispel the ABBA deadlock, this patch introduces
> try_get_online_cpus(). It returns fail very rarely. It gives the
> caller a chance to select an alternative way to finish works,
> instead of sleeping or deadlock.
> 

We really really really don't want to add new trylocks.  They're nasty
things, requiring that callers provide alternative fallback code paths
which are really hard to test.  The original code writer _might_ have
performed runtime testing of the contention path when originally
writing the patch, but after that nobody will tesst that path at all
and there's a good chance that it will become broken over time and
nobody will know about it.

I assume that one advantage of your rwlock conversion patch is that
code paths such as the above are now checked by lockdep, yes?  And this
is how you discovered the bug in some subsystem whcih you didn't tell
us about?

> ---
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 2643d84..98f5c4b 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -104,6 +104,7 @@ extern struct sysdev_class cpu_sysdev_class;
>  
>  extern void get_online_cpus(void);
>  extern void put_online_cpus(void);
> +extern int try_get_online_cpus(void);
>  #define hotcpu_notifier(fn, pri) {				\
>  	static struct notifier_block fn##_nb __cpuinitdata =	\
>  		{ .notifier_call = fn, .priority = pri };	\
> @@ -117,6 +118,7 @@ int cpu_down(unsigned int cpu);
>  
>  #define get_online_cpus()	do { } while (0)
>  #define put_online_cpus()	do { } while (0)
> +#define try_get_online_cpus()	(1)
>  #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
>  /* These aren't inline functions due to a GCC bug. */
>  #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 62198ec..e948f19 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -66,6 +66,15 @@ void put_online_cpus(void)
>  }
>  EXPORT_SYMBOL_GPL(put_online_cpus);
>  
> +int try_get_online_cpus(void)
> +{
> +	might_sleep();
> +	if (cpu_hotplug.active_writer == current)
> +		return 1;
> +	return down_read_trylock(&cpu_hotplug.rwlock);
> +
> +}
> +EXPORT_SYMBOL_GPL(try_get_online_cpus);

It's strange to add a might_sleep() to a function which doesn't sleep.

The patch adds no callers to this function.  This is significant
because it would be quite interesting to find out which subsystem(s)
you've found to have this deadlock.  I do think that we should look at
alternative (non-trylocky) ways of fixing them.

