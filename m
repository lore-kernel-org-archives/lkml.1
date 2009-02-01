Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZBASFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZBASFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 13:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZBASFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 13:05:40 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3948 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752323AbZBASFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 13:05:40 -0500
Date: Sun, 1 Feb 2009 13:05:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <richardj_moore@uk.ibm.com>, <naren@linux.vnet.ibm.com>
Subject: Re: [RFC Patch 1/10] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20090201135433.GE7021@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0902011246090.27579-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Paul E. McKenney wrote:

> > > Yes, indeed. With the current implementation, there's a possibility of
> > > two instances of update_this_cpu() function executing - one with an
> > > rcu_read_lock() taken (when called from load_debug_registers) while the
> > > other without (when invoked through update_all_cpus()).
> > 
> > No, this isn't possible unless I have misunderstood the nature of
> > IPIs.  Isn't is true that calling local_irq_save() will block delivery
> > of IPIs?
> 
> Touche!  ;-)
> 
> But in that case, why do you need the synchronize_rcu() following the
> on_each_cpu() above?  Is this needed to make sure that any concurrent
> load_debug_registers() call has completed?

No; it's needed to make sure that any concurrent
switch_to_thread_hw_breakpoint() call has completed.  That's where the
important RCU read lock is taken.  The routine is called not just by
update_this_cpu() (and indirectly by load_debug_registers()) but also
by __register_user_hw_breakpoint(), __unregister_user_hw_breakpoint(),
and the task-switch routine.

It's possible that the IPI from on_each_cpu() could interrupt an
instance of switch_to_thread_hw_breakpoint() -- thereby causing it to
run recursively.  After the inner instance returns and the IPI is over,
the outer instance will realize what has happened and restart itself.  
synchronize_rcu() insures that update_all_cpus() will wait until the
outer instance is done.

In fact, the RCU read lock in load_debug_registers() probably isn't 
necessary.  But it's cleaner to leave it in; it points out that the 
routine accesses data structures which are protected by RCU.

Alan Stern

