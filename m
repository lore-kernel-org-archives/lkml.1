Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZBCRYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZBCRYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZBCRX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:23:57 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54193 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZBCRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:23:56 -0500
Date: Tue, 3 Feb 2009 22:53:31 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 1/10] Introducing generic hardware breakpoint
	handler interfaces
Message-ID: <20090203172331.GA8300@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090201135433.GE7021@linux.vnet.ibm.com> <Pine.LNX.4.44L0.0902011246090.27579-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0902011246090.27579-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 01:05:35PM -0500, Alan Stern wrote:
> On Sun, 1 Feb 2009, Paul E. McKenney wrote:
> 
> > > > Yes, indeed. With the current implementation, there's a possibility of
> > > > two instances of update_this_cpu() function executing - one with an
> > > > rcu_read_lock() taken (when called from load_debug_registers) while the
> > > > other without (when invoked through update_all_cpus()).
> > > 
> > > No, this isn't possible unless I have misunderstood the nature of
> > > IPIs.  Isn't is true that calling local_irq_save() will block delivery
> > > of IPIs?
> > 
> > Touche!  ;-)
> > 
> > But in that case, why do you need the synchronize_rcu() following the
> > on_each_cpu() above?  Is this needed to make sure that any concurrent
> > load_debug_registers() call has completed?
> 
> No; it's needed to make sure that any concurrent
> switch_to_thread_hw_breakpoint() call has completed.  That's where the
> important RCU read lock is taken.  The routine is called not just by
> update_this_cpu() (and indirectly by load_debug_registers()) but also
> by __register_user_hw_breakpoint(), __unregister_user_hw_breakpoint(),
> and the task-switch routine.
> 
> It's possible that the IPI from on_each_cpu() could interrupt an
> instance of switch_to_thread_hw_breakpoint() -- thereby causing it to
> run recursively.  After the inner instance returns and the IPI is over,
> the outer instance will realize what has happened and restart itself.  
> synchronize_rcu() insures that update_all_cpus() will wait until the
> outer instance is done.
> 
> In fact, the RCU read lock in load_debug_registers() probably isn't 
> necessary.  But it's cleaner to leave it in; it points out that the 
> routine accesses data structures which are protected by RCU.
> 
> Alan Stern
>

Hi Alan,
	After a better understanding about RCU usage in this patch, I'm
thinking if the list traversals in kernel/hw_breakpoint.c should be
changed into their RCU equivalent i.e. list_for_each_entry_rcu() instead
of list_for_each_entry() and list_del_rcu() instead of list_del() -
given that we are considering the list of thread HW breakpoints
(thread_bps) and kernel breakpoints (cur_kbpdata) which are also
accessed from exception-handler contexts.

I think that with the possibility of parallel execution of
the 'update' sections which would alter the protected data structures
(mentioned above) through functions such as - say insert_bp_in_list(),
balance_kernel_vs_user() and various other routines and the read-side
critical regions which need to be identified after converting the list
traversal routines it would be necessary to wrap the code around them
with rcu_read_(un)lock() routines.

What do you think? Is there something grossly incorrect in this
assessment of locking requirements?

Thanks,
K.Prasad

