Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbYEOOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbYEOOsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYEOOsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:48:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39040 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbYEOOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:48:37 -0400
Date: Thu, 15 May 2008 07:48:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josh Triplett <josh@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rculist.h: use the rcu API
Message-ID: <20080515144831.GB9023@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <482B5887.9050804@gmail.com> <482B58FA.30000@gmail.com> <20080515055011.GA12809@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515055011.GA12809@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:50:11AM +0400, Alexey Dobriyan wrote:
> On Wed, May 14, 2008 at 11:26:18PM +0200, Franck Bui-Huu wrote:
> > This patch makes almost all list mutation primitives use
> > rcu_assign_pointer().
> >
> > The main point of this being readability improvement.
> 
> Which is not an improvement at all.
> 
> > --- a/include/linux/rculist.h
> > +++ b/include/linux/rculist.h
> > @@ -17,9 +18,8 @@ static inline void __list_add_rcu(struct list_head *new,
> > {
> > 	new->next = next;
> > 	new->prev = prev;
> > -	smp_wmb();
> > +	rcu_assign_pointer(prev->next, new);
> > 	next->prev = new;
> > -	prev->next = new;
> > }
> 
> Nice chunk to demonstrate.
> 
> Before one could write this like:
> 
> 	smp_wmb();			smp_wmb();
> 	next->prev = new;	or	prev->next = new;
> 	prev->next = new;		next->prev = new;
> 
> And both examples aren't buggy.
> 
> After, you can't write:
> 
> 	next->prev = new;
> 	rcu_assign_pointer(prev->next, new);
> 
> Guess why?

Strangely enough, you actually can do this, because RCU readers are
not permitted to follow the prev pointers.  Any RCU readers who try to
follow the prev pointers are subject to failures due to list_del_rcu()'s
assignment:

	entry->prev = LIST_POISON2;

So this change is not in fact relying on undocumented rcu_assign_pointer()
side effects.

							Thanx, Paul

> This barrier is related not only to next assignment, but to the whole
> group of assignments.
> 
> > @@ -108,9 +108,8 @@ static inline void list_replace_rcu(struct list_head 
> > *old,
> > {
> > 	new->next = old->next;
> > 	new->prev = old->prev;
> > -	smp_wmb();
> > +	rcu_assign_pointer(new->prev->next, new);
> > 	new->next->prev = new;
> > -	new->prev->next = new;
> > 	old->prev = LIST_POISON2;
> > }
> 
