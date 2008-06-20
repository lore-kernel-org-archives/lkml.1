Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYFTIvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYFTIvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYFTIvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:51:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYFTIvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:51:12 -0400
Subject: Re: [BUG] CFS vs cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20080619214945.GA12640@osiris.ibm.com>
References: <20080619161949.GA11062@osiris.ibm.com>
	 <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
	 <1213911149.3223.135.camel@lappy.programming.kicks-ass.net>
	 <20080619214945.GA12640@osiris.ibm.com>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 10:51:03 +0200
Message-Id: <1213951863.10476.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-19 at 23:49 +0200, Heiko Carstens wrote:
> On Thu, Jun 19, 2008 at 11:32:29PM +0200, Peter Zijlstra wrote:
> > On Thu, 2008-06-19 at 20:05 +0200, Peter Zijlstra wrote:
> > > On Thu, 2008-06-19 at 18:19 +0200, Heiko Carstens wrote:
> > 
> > > > The sched_entity that belongs to the cfs_rq:
> > > > 
> > > > >> px *(sched_entity *) 0x759300
> > > > struct sched_entity {
> > > >         load = struct load_weight {
> > > >                 weight = 0x800
> > > >                 inv_weight = 0x1ffc01
> > > >         }
> > > >         run_node = struct rb_node {
> > > >                 rb_parent_color = 0x1
> > > >                 rb_right = (nil)
> > > >                 rb_left = (nil)
> > > >         }
> > > >         group_node = struct list_head {
> > > >                 next = 0x75a3b8
> > > >                 prev = 0x75a3b8
> > > >         }
> > > >         on_rq = 0x1
> > > >         exec_start = 0x189685acb4aa46
> > > >         sum_exec_runtime = 0x188a2b84c
> > > >         vruntime = 0xd036bd29
> > > >         prev_sum_exec_runtime = 0x1672e3f62
> > > >         last_wakeup = 0x0
> > > >         avg_overlap = 0x0
> > > >         parent = (nil)
> > > >         cfs_rq = 0x75a380
> > > >         my_q = 0x759400
> > > > }
> > 
> > If you still have this dump, could you give the output of:
> > 
> > px *(struct cfs_rq *) 0x759400
> > 
> > And possibly walk down the chain getting its curr and then my_q again
> > etc..
> 
> Sure, fortunately just a very short chain:
> 
> >> px *(struct cfs_rq *) 0x759400
> struct cfs_rq {
>         load = struct load_weight {
>                 weight = 0xc31
>                 inv_weight = 0x0
>         }
>         nr_running = 0x1
>         exec_clock = 0x0
>         min_vruntime = 0x4f216b005
>         tasks_timeline = struct rb_root {
>                 rb_node = 0x2fca4d40
>         }
>         rb_leftmost = 0x2fca4d40
>         tasks = struct list_head {
>                 next = 0x2fca4d58
>                 prev = 0x2fca4d58
>         }
>         balance_iterator = 0x2e29e700
>         curr = 0x2ef4f388
>         next = (nil)
>         nr_spread_over = 0x0
>         rq = 0x75a300
>         leaf_cfs_rq_list = struct list_head {
>                 next = 0x75aaa0
>                 prev = 0x2e1eca70
>         }
>         tg = 0x564910
> }

Hmm this one is buggered as well, it has nr_running = 1, and one entry
in the tree, but also a !NULL curr.

Could you please show:

px *container_of(0x2fca4d40, struct sched_entity, run_node)

which one might have to write like:

px *((struct sched_entity *)((char*)0x2fca4d40) - ((unsigned long)&(((struct sched_entity *)0)->run_node)))

/me prays he got the braces right,..

> >> px *(sched_entity *) 0x2ef4f388
> struct sched_entity {
>         load = struct load_weight {
>                 weight = 0x400
>                 inv_weight = 0x400000
>         }
>         run_node = struct rb_node {
>                 rb_parent_color = 0x2f07b399
>                 rb_right = (nil)
>                 rb_left = (nil)
>         }
>         group_node = struct list_head {
>                 next = 0x2ef4f3b0
>                 prev = 0x2ef4f3b0
>         }
>         on_rq = 0x0
>         exec_start = 0x189685c9a77b96
>         sum_exec_runtime = 0x3c51111
>         vruntime = 0x493becf68
>         prev_sum_exec_runtime = 0x3c50997
>         last_wakeup = 0x0
>         avg_overlap = 0x4b67d1
>         parent = 0x763300
>         cfs_rq = 0x763400
>         my_q = (nil)
> }

This one seems un-associated with the rest of the chain, as per its
back-pointers.

Fancy puzzle,..

