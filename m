Return-Path: <linux-kernel-owner+w=401wt.eu-S934253AbYDQQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbYDQQRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765530AbYDQQRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:17:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35552 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763700AbYDQQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:17:12 -0400
Subject: Re: Semphore -> mutex in the device tree
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0804171204460.18040-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804171204460.18040-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 18:17:09 +0200
Message-Id: <1208449029.7115.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 12:11 -0400, Alan Stern wrote:
> On Thu, 17 Apr 2008, Peter Zijlstra wrote:
> 
> > On Thu, 2008-04-17 at 11:22 -0400, Alan Stern wrote:
> > > Peter:
> > > 
> > > The obstacle to converting the semaphore in struct device to a mutex 
> > > has been that its tree-oriented usage pattern isn't compatible with 
> > > lockdep.
> > > 
> > > In order to get around this and at least begin the conversion process,
> > > how about adding a provision for making some classes of mutex invisible
> > > to lockdep?  I know it doesn't solve the fundamental problem, but maybe
> > > it's a step in the right direction.
> > 
> > the device lock has two problems with lockdep:
> > 
> >  1) on suspend it takes more than MAX_LOCK_DEPTH (48) locks
> 
> This isn't true any more.  Not in Greg KH's development tree.
> 
> >  2) tree nesting
> > 
> > 
> > Lets start with the easy one first; would a similar solution to the
> > radix tree locking as found in -rt work?
> > 
> > http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/23-rc1-rt/radix-concurrent-lockdep.patch
> > 
> > That does mean you have to set an effective max depth to the tree, is
> > that a practical issue?
> 
> I don't know.  But I suspect it wouldn't be sufficient to solve the 
> problems associated with tree nesting.

It works for strict top-down locking. The sideways locking you do:

> For example, it's quite likely that some code somewhere needs to hold
> two sibling nodes' locks at the same time.  Provided the parent node is
> already locked, this operation is perfectly safe.  But is lockdep able
> to handle it?

Your siblings are ordered; so a simple mutex_lock_nested() should work
between siblings as long as you never need more than 8 siblings locked
at any one time.

> There are other, more subtle problems too; this is just one example.

Can you think of a situation where the top-down class annotation and the
sideways _nesting() isn't sufficient? If so, please share.

> > The harder part is 1), holding _that_ many locks. Would something
> > obscene like this work for you:
> 
> This is no longer needed, fortunately.  :-)

Ah, good :-) 

