Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZFWDXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZFWDXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZFWDXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:23:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:45591 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZFWDXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:23:31 -0400
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
Date: Tue, 23 Jun 2009 13:23:14 +1000
Message-Id: <1245727394.4017.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 19:29 -0700, Linus Torvalds wrote:

> Static initializers are much nicer than having to worry about when 
> something gets initialized, no?

Your patch works here and fixes the problem too.

Thanks !

Cheers,
Ben.

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

