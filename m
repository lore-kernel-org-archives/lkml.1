Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbYCUU5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbYCUU5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYCUU4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:56:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30965 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYCUU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:56:52 -0400
Date: Fri, 21 Mar 2008 13:55:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 2/5] infrastructure to debug (dynamic) objects
Message-Id: <20080321135513.8f1c2a69.randy.dunlap@oracle.com>
In-Reply-To: <20080321200321.650649403@linutronix.de>
References: <20080321200300.310393657@linutronix.de>
	<20080321200321.650649403@linutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 20:26:18 -0000 Thomas Gleixner wrote:

>  Documentation/kernel-parameters.txt |    2 
>  include/linux/debugobjects.h        |   90 +++
>  init/main.c                         |    3 
>  lib/Kconfig.debug                   |   23 
>  lib/Makefile                        |    1 
>  lib/debugobjects.c                  |  890 ++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c                     |   10 
>  mm/slab.c                           |   10 
>  mm/slub.c                           |    3 
>  mm/vmalloc.c                        |    2 
>  10 files changed, 1030 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/lib/Kconfig.debug
> ===================================================================
> --- linux-2.6.orig/lib/Kconfig.debug
> +++ linux-2.6/lib/Kconfig.debug
> @@ -183,6 +183,29 @@ config TIMER_STATS
>  	  (it defaults to deactivated on bootup and will only be activated
>  	  if some application like powertop activates it explicitly).
>  
> +config DEBUG_OBJECTS
> +	bool "Debug object operations"
> +	depends on DEBUG_KERNEL
> +	help
> +	  If you say Y here, additional code will be inserted into the
> +	  kernel to track the life time of various objects and validate

                              lifetime

> +	  the operations on those objects.
> +
> +config DEBUG_OBJECTS_SELFTEST
> +	bool "Debug objects selftest"
> +	depends on DEBUG_OBJECTS
> +	help
> +	  This enables the selftest of the object debug code.
> +
> +config DEBUG_OBJECTS_FREE
> +	bool "Debug objects in freed memory"
> +	depends on DEBUG_OBJECTS
> +	help
> +	  This enables checks whether a k/v free operation frees an area

Please say "kfree/vfree" so that we (I, others) don't have to think
"what the heck is a k/v free operation?".

> +	  which contains an object which has not been deactivated
> +	  properly. This can make kmalloc/kfree-intensive workloads
> +	  much slower.
> +
>  config DEBUG_SLAB
>  	bool "Debug slab memory allocations"
>  	depends on DEBUG_KERNEL && SLAB

> Index: linux-2.6/lib/debugobjects.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/lib/debugobjects.c
> @@ -0,0 +1,890 @@

...

> +/*
> + * We run out of memory. That means we probably have tons of objects

         ran

> + * allocated.
> + */
> +static void debug_objects_oom(void)
> +{
> +	struct debug_bucket *db = obj_hash;
> +	struct hlist_node *node, *tmp;
> +	struct debug_obj *obj;
> +	unsigned long flags;
> +	int i;
> +
> +	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
> +
> +	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
> +		spin_lock_irqsave(&db->lock, flags);
> +		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
> +			hlist_del(&obj->node);
> +			free_object(obj);
> +		}
> +		spin_unlock_irqrestore(&db->lock, flags);
> +	}
> +}

> +/**
> + * debug_object_init_on_stack - debug checks when an object on stack is
> + *				initialized

Unfortunately the first line of kernel-doc notation ("short description")
is limited to one line.  Even if it exceeds 80 columns.  :(

> + * @addr:	address of the object
> + * @descr:	pointer to an object specific debug description structure
> + */
> +void debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
> +{
> +	if (!debug_objects_enabled)
> +		return;
> +
> +	__debug_object_init(addr, descr, 1);
> +}


---
~Randy
