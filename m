Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbXA2KWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbXA2KWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXA2KWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:22:46 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:4744 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752485AbXA2KWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:22:46 -0500
Subject: Re: [Fwd: [PATCH 2/7] lock_list: a fine grain locked double linked
	list]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070128172027.GA4913@infradead.org>
References: <1169999597.10987.33.camel@lappy>
	 <20070128172027.GA4913@infradead.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 11:20:40 +0100
Message-Id: <1170066040.6189.128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 17:20 +0000, Christoph Hellwig wrote:
> > Provide a simple fine grain locked double link list.
> > 
> > It is build upon the regular double linked list primitives, spinlocks and RCU.
> > 
> > Locking is peculiar in that edges are locked, this avoid the circular lock
> > dependancy created by the fact that the regular linked lists are circular.
> > 
> > Item deletion requires that both surrounding elements are locked, however since
> > the locking rules dictate that we lock elements in a single direction we have
> > to lock the previous element while it might be deleted under us. Hence the
> > requirement that all elements are RCU freed.
> 
> I think implicitly locked data structures are very bad for code readability
> and debugability.  What's even worse here is that we have a requirement that
> all members are RCU freed.
> 
> Note that we also have another implicitly locked (and refcounted) list
> implementation in klist.[ch] - if we find consensus that we want implicitly
> locked list we should figure out whether we want lock_list or klist semantics
> and stick to one of them.

klist is quite different in that it locks the whole list. The proposed
data structure locks each edge, that is it will allow concurrent
deletion of elements as long as they don't share neighbours.

> What uses do you have planned for this data structure?  In general I think
> we'd be better off to simplify the data structures as in my files_list_lock
> proposal instead of complicating the locking.

Getting rid of the s_files list like you proposed would of course be a
much better solution, and I'll look into that.

Not having the VFS knowledge you do I just smashed the lock and kept
current semantics.

