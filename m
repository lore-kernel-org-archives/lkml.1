Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZAEV6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZAEV6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZAEV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:58:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37743 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbZAEV6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:58:34 -0500
Date: Mon, 5 Jan 2009 13:58:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Klotz <peter.klotz@aon.at>,
       stable@kernel.org, Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re:
Message-ID: <20090105215832.GR6959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de> <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain> <20090105201258.GN6959@linux.vnet.ibm.com> <1231189491.11687.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231189491.11687.22.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:04:51PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-01-05 at 12:12 -0800, Paul E. McKenney wrote:
> > On Mon, Jan 05, 2009 at 10:44:27AM -0800, Linus Torvalds wrote:
> > > On Mon, 5 Jan 2009, Nick Piggin wrote:
> > > > On Mon, Jan 05, 2009 at 09:30:55AM -0800, Linus Torvalds wrote:
> > > > Putting an rcu_dereference there might work, but I think it misses a 
> > > > subtlety of this code.
> > > 
> > > No, _you_ miss the subtlety of something that can change under you.
> > > 
> > > Look at radix_tree_deref_slot(), and realize that without the 
> > > rcu_dereference(), the compiler would actually be allowed to think that it 
> > > can re-load anything from *pslot several times. So without my one-liner 
> > > patch, the compiler can actually do this:
> > > 
> > > 	register = load_from_memory(pslot)
> > > 	if (radix_tree_is_indirect_ptr(register))
> > > 		goto fail:
> > > 	return load_from_memory(pslot);
> > > 
> > >    fail:
> > > 	return RADIX_TREE_RETRY;
> > 
> > My guess is that Nick believes that the value in *pslot cannot change
> > in such as way as to cause radix_tree_is_indirect_ptr()'s return value
> > to change within a given RCU grace period, and that Linus disagrees.
> 
> Nick's belief would indeed be true IFF all modifying ops including all
> uses of radix_tree_replace_slot() are serialized wrt. each other.
> 
> However, since radix_tree_deref_slot() is the counterpart of
> radix_tree_replace_slot(), one would indeed expect rcu_dereference()
> therein, much like Linus suggests.
> 
> While what Nick says is true, the lifetime management of the data
> objects is arranged externally from the radix tree -- I still think we
> need the rcu_dereference() even for that argument, as we want to support
> RCU lifetime management as well.

Makes sense to me!

							Thanx, Paul
