Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYDRGdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYDRGdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYDRGc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:32:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45034 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYDRGc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:32:56 -0400
Subject: Re: Semphore -> mutex in the device tree
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0804171425350.19418-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804171425350.19418-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 08:32:52 +0200
Message-Id: <1208500372.7115.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 14:43 -0400, Alan Stern wrote:
> On Thu, 17 Apr 2008, Peter Zijlstra wrote:
> 
> > > > That does mean you have to set an effective max depth to the tree, is
> > > > that a practical issue?
> > > 
> > > I don't know.  But I suspect it wouldn't be sufficient to solve the 
> > > problems associated with tree nesting.
> > 
> > It works for strict top-down locking. The sideways locking you do:
> > 
> > > For example, it's quite likely that some code somewhere needs to hold
> > > two sibling nodes' locks at the same time.  Provided the parent node is
> > > already locked, this operation is perfectly safe.  But is lockdep able
> > > to handle it?
> > 
> > Your siblings are ordered; so a simple mutex_lock_nested() should work
> > between siblings as long as you never need more than 8 siblings locked
> > at any one time.
> 
> I don't fully understand the implications here.  Let A and B be sibling
> device nodes.  Suppose task 0 locks device A with NESTING_PARENT and
> then device B with NESTING_CHILD, while at about the same time task 1
> locks B with NESTING PARENT and then A with NESTING_CHILD.  This is
> perfectly safe provided both tasks acquire the parent lock first, but
> otherwise it isn't.  How would lockdep account for this?

Lockdep only cares about class order; if you always lock NESTING_PARENT
-> NESTING_CHILD it won't complain; but it will not require you to hold
the parent lock (although I can provide you with an annotation to that
effect if you want; lockdep_assert_held(dev->parent->lock) - or
something like that).

So using these annotations you can annotate a real deadlock 'away'.

> And don't say that one task is ignoring the ordering of the siblings.  
> In fact the ordering is a rather weak one (time of registration), there
> might be different orderings that are more relevant (e.g., the numbers
> of the ports into which the siblings are plugged), and it isn't
> particularly easy to tell which of two siblings should come first.  
> Furthermore the order of locking isn't always under our control; there
> _will_ be times when the order has to be "backward".

As long as you're sure there aren't any actual deadlocks; and ensure you
use your annotated classes in the same order:

  tree_level_n -> tree_level_n+1

and

  tree_leve_n_sub_m -> tree_level_n_sub_m+1

(subclasses are from the _nesting() annotation)

lockdep will not complain,

> > > There are other, more subtle problems too; this is just one example.
> > 
> > Can you think of a situation where the top-down class annotation and the
> > sideways _nesting() isn't sufficient? If so, please share.
> 
> I don't understand all the intricacies of lockdep.  In principle
> ordering of siblings gives rise to a total ordering of the entire tree,
> so let's assume we have such a total ordering and that everyone always
> obeys it.
> 
> Even so there is a potential for trouble.  I don't know of any concrete
> examples like this in the kernel, but they might exist.  Suppose a
> driver keeps a private mutex associated with each device it manages.  
> Normally the device's lock would be acquired first and the private
> mutex second.  But there could be places where the driver acquires a
> child device's lock while holding the parent's mutex; this would look
> to lockdep like a violation.

So lockdep cares about classes and the hierarchy of thereof; so given
your example:

   parent_tree_level
     child_tree_level
       device_lock

Its perfectly fine to take a lock from 'parent_tree_level' and then a
lock from 'device_lock', skipping the class in the middle - as long as
you thereafter never acquire a lock from it.

So given a pre-determined class hierarchy, you're not required to take
all locks in that hierarchy; as long as you always go down. If you ever
take a lock so that moves up in the hierarchy you're in trouble.

