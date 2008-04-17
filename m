Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbYDQSnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbYDQSnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYDQSnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:43:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41697 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751316AbYDQSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:43:04 -0400
Date: Thu, 17 Apr 2008 14:43:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Semphore -> mutex in the device tree
In-Reply-To: <1208449029.7115.34.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0804171425350.19418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Peter Zijlstra wrote:

> > > That does mean you have to set an effective max depth to the tree, is
> > > that a practical issue?
> > 
> > I don't know.  But I suspect it wouldn't be sufficient to solve the 
> > problems associated with tree nesting.
> 
> It works for strict top-down locking. The sideways locking you do:
> 
> > For example, it's quite likely that some code somewhere needs to hold
> > two sibling nodes' locks at the same time.  Provided the parent node is
> > already locked, this operation is perfectly safe.  But is lockdep able
> > to handle it?
> 
> Your siblings are ordered; so a simple mutex_lock_nested() should work
> between siblings as long as you never need more than 8 siblings locked
> at any one time.

I don't fully understand the implications here.  Let A and B be sibling
device nodes.  Suppose task 0 locks device A with NESTING_PARENT and
then device B with NESTING_CHILD, while at about the same time task 1
locks B with NESTING PARENT and then A with NESTING_CHILD.  This is
perfectly safe provided both tasks acquire the parent lock first, but
otherwise it isn't.  How would lockdep account for this?

And don't say that one task is ignoring the ordering of the siblings.  
In fact the ordering is a rather weak one (time of registration), there
might be different orderings that are more relevant (e.g., the numbers
of the ports into which the siblings are plugged), and it isn't
particularly easy to tell which of two siblings should come first.  
Furthermore the order of locking isn't always under our control; there
_will_ be times when the order has to be "backward".

> > There are other, more subtle problems too; this is just one example.
> 
> Can you think of a situation where the top-down class annotation and the
> sideways _nesting() isn't sufficient? If so, please share.

I don't understand all the intricacies of lockdep.  In principle
ordering of siblings gives rise to a total ordering of the entire tree,
so let's assume we have such a total ordering and that everyone always
obeys it.

Even so there is a potential for trouble.  I don't know of any concrete
examples like this in the kernel, but they might exist.  Suppose a
driver keeps a private mutex associated with each device it manages.  
Normally the device's lock would be acquired first and the private
mutex second.  But there could be places where the driver acquires a
child device's lock while holding the parent's mutex; this would look
to lockdep like a violation.

Alan Stern

