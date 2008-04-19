Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYDSXY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYDSXY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 19:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYDSXYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 19:24:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41313 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYDSXYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 19:24:18 -0400
Date: Sat, 19 Apr 2008 16:24:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, peterz@infradead.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
Message-ID: <20080419232413.GD20138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080411161702.460410000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411161702.460410000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 06:17:02PM +0200, Nadia.Derbey@bull.net wrote:
> 
> 
> Here is finally the ipc ridr-based implementation I was talking about last
> week (see http://lkml.org/lkml/2008/4/4/208).
> I couldn't avoid much of the code duplication, but at least made things
> incremental.
> 
> Does somebody now a test suite that exists for the idr API, that I could
> run on this new api?
> 
> Mike, can you try to run it on your victim: I had such a hard time building
> this patch, that I couldn't re-run the test on my 8-core with this new
> version. So the last results I have are for 2.6.25-rc3-mm1.
> 
> Also, I think a careful review should be done to avoid introducing yet other
> problems :-(
> 
> *WARNING*: this patch contains a fix for idr.c
>            I know, I'm doing things bad, but I only saw the problem this
>            afternoon.
> 
> It should be applied on linux-2.6.25-rc8-mm1, in the following order:
> 
> [ PATCH 01/13 ] : copy_idr_code.patch
> [ PATCH 02/13 ] : change_ridr_struct.patch
> [ PATCH 03/13 ] : ridr_pre_get.patch
> [ PATCH 04/13 ] : ridr_alloc_layer.patch
> [ PATCH 05/13 ] : ridr_free_layer.patch
> [ PATCH 06/13 ] : ridr_sub_alloc.patch
> [ PATCH 07/13 ] : ridr_get_empty_slot.patch
> [ PATCH 08/13 ] : ridr_get_new.patch
> [ PATCH 09/13 ] : ridr_remove.patch
> [ PATCH 10/13 ] : ridr_find.patch
> [ PATCH 11/13 ] : ridr_integrate.patch
> [ PATCH 12/13 ] : ipc_use_ridr.patch
> [ PATCH 13/13 ] : remove_ipc_lock_down.patch

Some comments on the resulting ridr.h.

							Thanx, Paul

> /*
>  * include/linux/ridr.h
>  *
>  * Small id to pointer translation service avoiding fixed sized
>  * tables. RCU-based implmentation of IDRs.
>  */
> 
> #ifndef _RIDR_H_
> #define _RIDR_H_
> 
> #include <linux/idr.h>
> #include <linux/rcupdate.h>
> 
> struct ridr_layer {
> 	unsigned long		 bitmap; /* A zero bit means "space here" */
> 	struct ridr_layer	*ary[1<<IDR_BITS];
> 	int			 count;	 /* When zero, we can release it */
> 	struct rcu_head		 rcu_head;
> };

Added an rcu_head for freeing.

> struct ridr {
> 	int		  layers;
> 	gfp_t		  gfp_mask;
> 	struct ridr_layer *top;

The id_free and id_free_cnt fields seem to have migrated to the per-CPU
ridr_pregets variable.  The lock field seems to have been exported to
the caller, hence the per-CPU variables.

Other strategies include:

1.	Passing the lock into the ridr_pre_get() function, allowing
	it to safely update the id_free list.  This gets painful given
	the wide variety of locks, semaphores, mutexes, &c.

2.	Having ridr_pre_get() return a reference to the memory, which
	has the disadvantage of overallocation and needing to repeatedly
	allocate and free.

3.	Have a separate leaf lock guarding the freelist cache.
	This might be a better approach, since each ridr structure
	seems to require a single lock held on updates in any case.

Possible disadvantages of the current per-CPU-variable strategy include
the need to disable preemption (thus hurting real-time latency),
over-allocation on a per-CPU basis, and needlessly "spattering" free
entries across all CPUs in the (unlikely) case where there is lots
of preemption.  And there doesn't appear to be a way to free the
"spattered" structures.

So I suggest a global lock for the id_free list, given that there is
another global lock held when updating the ridr structure in any case.

> };
> 
> #define RIDR_INIT(mask)						\
> {								\
> 	.layers 	= 0,					\
> 	.gfp_mask 	= (mask),				\
> 	.top		= NULL,					\
> }
> #define DEFINE_RIDR(name, mask)	struct ridr name = RIDR_INIT(mask)
> 
> #define INIT_RIDR(name, mask)						\
> do {									\
> 	(name)->layers		= 0;					\
> 	(name)->gfp_mask 	= (mask);				\
> 	(name)->top		= NULL;					\
> } while (0)
> 
> 
> /**
>  * Ridr synchronization (see radix-tree.h)
>  *
>  * ridr_find() is able to be called locklessly, using RCU. The caller must
>  * ensure calls to this function are made within rcu_read_lock() regions.
>  * Other readers (lock-free or otherwise) and modifications may be running
>  * concurrently.
>  *
>  * It is still required that the caller manage the synchronization and
>  * lifetimes of the items. So if RCU lock-free lookups are used, typically
>  * this would mean that the items have their own locks, or are amenable to
>  * lock-free access; and that the items are freed by RCU (or only freed after
>  * having been deleted from the ridr tree *and* a synchronize_rcu() grace
>  * period).
>  */
> 
> /*
>  * This is what we export.
>  */
> 
> void *ridr_find(struct ridr *idp, int id);
> int ridr_pre_get(gfp_t gfp_mask);
> int ridr_get_new(struct ridr *idp, void *ptr, int *id);
> void ridr_remove(struct ridr *idp, int id);
> 
> void __init ridr_init_cache(void);
> 
> static inline void ridr_pre_get_end(void)
> {
> 	preempt_enable();
> }
> 
> #endif /* _RIDR_H_ */
