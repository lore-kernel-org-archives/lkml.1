Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYH2WHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYH2WHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYH2WHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:07:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55144 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYH2WHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:07:41 -0400
Date: Fri, 29 Aug 2008 15:07:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Remove stop_machine during module load
Message-ID: <20080829220737.GG6725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080829191734.GA28329@basil.nowhere.org> <20080829204457.GF6725@linux.vnet.ibm.com> <20080829212330.GC26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829212330.GC26610@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 11:23:30PM +0200, Andi Kleen wrote:
> Hi Paul,
> 
> Thanks for the excellent review.
> 
> On Fri, Aug 29, 2008 at 01:44:57PM -0700, Paul E. McKenney wrote:
> > 
> > OK, what about the read side?  Not so good for __unlink_module() to yank
> 
> That's independent from my patch isn't it? I don't think I'm changing
> anything here. All of the issues you're pointing out are already
> in the code (except for the missing read_barrier_depends() perhaps)
> 
> I think the lockless users like oops or sysrq-t typically have preemption
> disabled, so they should be ok regarding that. 

Ah -- perhaps I was confusing preventing CPU hotplug with preventing
stop_machine().  So disabling preemption holds off stop_machine()?
Yep, looks that way.

> > the module out from under a reader.  Therefore, all readers must either
> > disable interrupts to block stop_machine() or must hold some sort of
> > mutex that prevents modules from being unloaded.
> > 
> > First, where the heck -is- the read side...
> > 
> > o	each_symbol() needs its list_for_each_entry() to become
> > 	list_for_each_entry_rcu() and needs local_irq_disable()
> 
> Ah that's needed for the Alpha barrier depends semantics,
> right? 

Yep!  And to prevent compiler optimizations that could have the
same effect.

> > 	Yet another approach would be to use call_rcu() to defer the
> > 	various kfree() &c calls later in free_module.
> 
> I think that would be a the better approach.

Or maybe just disable preemption around the remaining readers, preventing
any stop_machine()-based deletions from being carried out during the
searches.

(And here I call myself a fan of real-time response!!!  But I suppose
that stop_machine() is going to be pretty hard on realtime response in
any case, so just don't mess with modules while your real-time
application is running...)

							Thanx, Paul
