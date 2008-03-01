Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYCAKw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYCAKw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 05:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYCAKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 05:52:21 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbYCAKwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 05:52:20 -0500
Date: Sat, 1 Mar 2008 02:51:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 1/2] infrastructure to debug (dynamic) objects
Message-Id: <20080301025134.d9c74110.akpm@linux-foundation.org>
In-Reply-To: <20080301100325.593267564@linutronix.de>
References: <20080301100019.640027768@linutronix.de>
	<20080301100325.593267564@linutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Mar 2008 10:24:56 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> We can see an ever repeating problem pattern with objects of any kind in
> the kernel:
> 
> 1) free of active objects
> 2) reinitialization of active objects
> 
> Both problems can be hard to debug because the crash happens at a
> point where we have no chance to decode the root cause anymore. One
> problem spot are kernel timers, where the detection of the problem
> often happens in interrupt context and usually causes the machine to
> panic.
> 
> While working on a timer related bug report I had to hack in
> specialized code into the timer subsystem to get a reasonable hint for
> the root cause. This debug hack was fine for temporary use, but far
> from a mergeable solution due to the intrusiveness into the timer code
> and the lack of the ability to detect and report the root cause
> instantly and at the same time keeping the system operational so that
> we have a decent chance to get hold of the debug information without
> special debugging aids like serial consoles.
> 
> The problems described above are not restricted to timers, but timers
> tend to expose it usually in a full system crash. Other objects are
> less explosive, but the symptoms caused by such mistakes can be even
> harder to debug.
> 
> Instead of creating specialized debugging code for the timer subsystem
> a generic infrastructure is created which allows developers to verify
> their code and provides an easy to enable debug facility for users in
> case of trouble.
> 
> The debugobjects core code keeps track of operations on static and
> dynamic objects by inserting them into a hashed list and sanity
> checking them on object operations and provides additional checks
> whenever kernel memory is freed.
> 
> The tracked object operations are:
> - initializing an object
> - adding an object to a subsystem list
> - deleting an object from a subsystem list
> 
> Each operation is sanity checked before the operation is executed and
> the subsystem specific code can provide a fixup function which prevents
> the damage of the operation. When the sanity check triggers a warning
> message and a stack trace is printed.
> 
> The list of operations can be extended if the need arises. For now it's
> limited to the requirements of the first user (timers).
> 
> The core code enqueues the objects into hash buckets. The hash index
> is generated from the address of the object to simplify the lookup for
> the check on k/vfree. Each bucket has it's own spinlock to avoid
> contention on a global lock.
> 
> The debug code can be compiled in without being active. The runtime
> overhead is minimal and could be optimized by asm alternatives. A
> kernel command line option enables the debugging code.
> 

hm.

The enabled-via-command-line thing is a bit sad.  I guess runtime
switchability would be hard.

The proof of this pudding is "how many subsystems use it".  If things like
the fault-injection framework are a guide, the answer is "zero unless
Thomas does it".  Call me an experienced cynic.

> +enum debug_obj_op {
> +	ODEBUG_INIT,
> +	ODEBUG_ADD,
> +	ODEBUG_DEL,
> +	ODEBUG_FREE,
> +	ODEBUG_TEST,
> +};

Interface nit: five different API calls would be preferable to one call
with a mode argument.

> +enum {
> +	ODEBUG_TYPE_UNKNOWN,
> +	ODEBUG_MAX_TYPES
> +};

The need for each client to patch this table is regrettable.
	
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -11,6 +11,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/prio_tree.h>
>  #include <linux/debug_locks.h>
> +#include <linux/debugobjects.h>
>  #include <linux/mm_types.h>
>  
>  struct mempolicy;

I suspect this wasn't supposed to be here.

> Index: linux-2.6/lib/debugobjects.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/lib/debugobjects.c
> @@ -0,0 +1,256 @@
> +/*
> + * Generic infrastructure for debugging of objects.
> + *
> + * Started by Thomas Gleixner
> + *
> + * Copyright (C) 2008, Thomas Gleixner <tglx@linutronix.de>
> + *
> + *
> + * For licencing details see kernel-base/COPYING
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/debugobjects.h>
> +#include <linux/seq_file.h>
> +
> +#define ODEBUG_HASH_SIZE	4096

power-of-2 is said to be a very poor size for a hash table.

> +#define ODEBUG_HASH_MASK	(ODEBUG_HASH_SIZE - 1)
> +
> +struct odebug {
> +	struct list_head list;

hlist?

> +	spinlock_t lock;
> +};
> +
> +static struct odebug obj_hash[ODEBUG_HASH_SIZE];
> +
> +static int debug_objects_selftest __read_mostly;
> +static int debug_objects_maxchain __read_mostly;
> +static int debug_objects_fixups __read_mostly;
> +static int debug_objects_enabled __read_mostly;
> +
> +static int __init enable_object_debug(char *str)
> +{
> +	debug_objects_enabled = 1;
> +	return 0;
> +}
> +
> +early_param("debug_objects", enable_object_debug);

I can never remember whether these things need to return 0 or 1 on success.

<looks at debug_kernel(), quiet_kernel() and loglevel().  Shudders.
Moves on.>


