Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZBQPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZBQPqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZBQPpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:45:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbZBQPpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:45:45 -0500
Date: Tue, 17 Feb 2009 07:44:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
In-Reply-To: <1234859071.4744.10.camel@laptop>
Message-ID: <alpine.LFD.2.00.0902170736380.21686@localhost.localdomain>
References: <20090216163847.431174825@chello.nl>  <20090216164114.521787803@chello.nl>  <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain> <1234859071.4744.10.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Feb 2009, Peter Zijlstra wrote:
> 
> Ah, no, I don't actually. I remove the kmalloc+call_rcu stuff in 2, not
> the newly cfd mini rcu thing.

I'm not talking about the "mini-rcu", I'm talking about the _existing_ rcu 
code that you play games with, just before you then remove it.

See here:

 - patch 1/4:

	@@ -25,8 +40,11 @@ struct call_function_data {
	        struct call_single_data csd;
	        spinlock_t lock;
	        unsigned int refs;
	-       struct rcu_head rcu_head;
	-       unsigned long cpumask_bits[];
	+       union {
	+               struct rcu_head rcu_head;
	+               struct list_head free_list;
	+       };
	+       struct cpumask cpumask;
	 };

 - patch 2/4:

	 struct call_function_data {
	        struct call_single_data csd;
	        spinlock_t lock;
	        unsigned int refs;
	-       union {
	-               struct rcu_head rcu_head;
	-               struct list_head free_list;
	-       };
	+       struct list_head free_list;
	        struct cpumask cpumask;
	 };

ie that ugly/complex/subtle union of rcu_head that you added in 1/4 you 
then remove immediately in 2/4. Making the patches just harder to read. 

Just remove it. I'd say fold 1+2 into one patch, instead of playing games 
with that thing. Just make the patch remove the kmalloc.

Or at least get rid of the _games_ you play with that union. Now it just 
makes the patch unreadable.

		Linus
