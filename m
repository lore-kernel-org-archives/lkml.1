Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbYH2VU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbYH2VU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYH2VUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:20:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48982 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbYH2VUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:20:48 -0400
Date: Fri, 29 Aug 2008 23:23:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Remove stop_machine during module load
Message-ID: <20080829212330.GC26610@one.firstfloor.org>
References: <20080829191734.GA28329@basil.nowhere.org> <20080829204457.GF6725@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829204457.GF6725@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thanks for the excellent review.

On Fri, Aug 29, 2008 at 01:44:57PM -0700, Paul E. McKenney wrote:
> 
> OK, what about the read side?  Not so good for __unlink_module() to yank

That's independent from my patch isn't it? I don't think I'm changing
anything here. All of the issues you're pointing out are already
in the code (except for the missing read_barrier_depends() perhaps)

I think the lockless users like oops or sysrq-t typically have preemption
disabled, so they should be ok regarding that. 

> the module out from under a reader.  Therefore, all readers must either
> disable interrupts to block stop_machine() or must hold some sort of
> mutex that prevents modules from being unloaded.
> 
> First, where the heck -is- the read side...
> 
> o	each_symbol() needs its list_for_each_entry() to become
> 	list_for_each_entry_rcu() and needs local_irq_disable()

Ah that's needed for the Alpha barrier depends semantics,
right? 

> 	Yet another approach would be to use call_rcu() to defer the
> 	various kfree() &c calls later in free_module.

I think that would be a the better approach.

-Andi

