Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZFWC7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZFWC7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZFWC7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:59:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:40502 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZFWC7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:59:45 -0400
Subject: Re: [PATCH] mm/init: cpu_hotplug_init() must be initialized before
 SLAB
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sachin Sant <sachinp@in.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
References: <1245717089.4017.18.camel@pasglop>
	 <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 12:59:14 +1000
Message-Id: <1245725954.4017.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 19:29 -0700, Linus Torvalds wrote:
> 
> On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
> 
> > +	/*
> > +	 * This initializes the mutex used by get/put_online_cpus()
> > +	 * which is used by SLAB
> > +	 */
> > +	cpu_hotplug_init();
> 
> Oh fudge it.
> 
> Why not get rid of that stupid thing, rather than have that subtle 
> dependency and a comment for it.
> 
> IOW, does this simpler alternative also work?

You mean static init ? Sure, it should do.

> When given the choice of simplifying and removing code, always do so. 

Yup. Agreed. Thought about it... got shy :-)

> Static initializers are much nicer than having to worry about when 
> something gets initialized, no?

I'll test that asap.

> 		Linus
> 
> ---
>  include/linux/cpu.h |    5 -----
>  init/main.c         |    1 -
>  kernel/cpu.c        |   13 +++++--------
>  3 files changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 2643d84..4d668e0 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -69,7 +69,6 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
>  
>  int cpu_up(unsigned int cpu);
>  void notify_cpu_starting(unsigned int cpu);
> -extern void cpu_hotplug_init(void);
>  extern void cpu_maps_update_begin(void);
>  extern void cpu_maps_update_done(void);
>  
> @@ -84,10 +83,6 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
>  {
>  }
>  
> -static inline void cpu_hotplug_init(void)
> -{
> -}
> -
>  static inline void cpu_maps_update_begin(void)
>  {
>  }
> diff --git a/init/main.c b/init/main.c
> index 09131ec..4870dfe 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -678,7 +678,6 @@ asmlinkage void __init start_kernel(void)
>  #endif
>  	page_cgroup_init();
>  	enable_debug_pagealloc();
> -	cpu_hotplug_init();
>  	kmemtrace_init();
>  	kmemleak_init();
>  	debug_objects_mem_init();
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 395b697..8ce1004 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -34,14 +34,11 @@ static struct {
>  	 * an ongoing cpu hotplug operation.
>  	 */
>  	int refcount;
> -} cpu_hotplug;
> -
> -void __init cpu_hotplug_init(void)
> -{
> -	cpu_hotplug.active_writer = NULL;
> -	mutex_init(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount = 0;
> -}
> +} cpu_hotplug = {
> +	.active_writer = NULL,
> +	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
> +	.refcount = 0,
> +};
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  

