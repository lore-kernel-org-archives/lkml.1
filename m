Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZHLPye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZHLPye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZHLPyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:54:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42639 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZHLPyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:54:31 -0400
Date: Wed, 12 Aug 2009 18:51:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com
Subject: Re: [PATCHv2 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090812155154.GA29797@redhat.com>
References: <cover.1249992497.git.mst@redhat.com> <20090811212802.GC26309@redhat.com> <4A82076A.1060805@gmail.com> <20090812090219.GB26847@redhat.com> <4A82BD2F.7080405@gmail.com> <20090812132539.GD29200@redhat.com> <20090812141107.GD6833@linux.vnet.ibm.com> <20090812141559.GA29387@redhat.com> <20090812152639.GA6779@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812152639.GA6779@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 08:26:39AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 12, 2009 at 05:15:59PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Aug 12, 2009 at 07:11:07AM -0700, Paul E. McKenney wrote:
> > > On Wed, Aug 12, 2009 at 04:25:40PM +0300, Michael S. Tsirkin wrote:
> > > > On Wed, Aug 12, 2009 at 09:01:35AM -0400, Gregory Haskins wrote:
> > > > > I think I understand what your comment above meant:  You don't need to
> > > > > do synchronize_rcu() because you can flush the workqueue instead to
> > > > > ensure that all readers have completed.
> > > > 
> > > > Yes.
> > > > 
> > > > >  But if thats true, to me, the
> > > > > rcu_dereference itself is gratuitous,
> > > > 
> > > > Here's a thesis on what rcu_dereference does (besides documentation):
> > > > 
> > > > reader does this
> > > > 
> > > > 	A: sock = n->sock
> > > > 	B: use *sock
> > > > 
> > > > Say writer does this:
> > > > 
> > > > 	C: newsock = allocate socket
> > > > 	D: initialize(newsock)
> > > > 	E: n->sock = newsock
> > > > 	F: flush
> > > > 
> > > > 
> > > > On Alpha, reads could be reordered.  So, on smp, command A could get
> > > > data from point F, and command B - from point D (uninitialized, from
> > > > cache).  IOW, you get fresh pointer but stale data.
> > > > So we need to stick a barrier in there.
> > > > 
> > > > > and that pointer is *not* actually
> > > > > RCU protected (nor does it need to be).
> > > > 
> > > > Heh, if readers are lockless and writer does init/update/sync,
> > > > this to me spells rcu.
> > > 
> > > If you are using call_rcu(), synchronize_rcu(), or one of the
> > > similar primitives, then you absolutely need rcu_read_lock() and
> > > rcu_read_unlock(), or one of the similar pairs of primitives.
> > 
> > Right. I don't use any of these though.
> > 
> > > If you -don't- use rcu_read_lock(), then you are pretty much restricted
> > > to adding data, but never removing it.
> > > 
> > > Make sense?  ;-)
> > 
> > Since I only access data from a workqueue, I replaced synchronize_rcu
> > with workqueue flush. That's why I don't need rcu_read_lock.
> 
> Well, you -do- need -something- that takes on the role of rcu_read_lock(),
> and in your case you in fact actually do.  Your equivalent of
> rcu_read_lock() is the beginning of execution of a workqueue item, and
> the equivalent of rcu_read_unlock() is the end of execution of that same
> workqueue item.  Implicit, but no less real.

Well put. I'll add this to comments in my code.

> If a couple more uses like this show up, I might need to add this to
> Documentation/RCU.  ;-)
> 
> 							Thanx, Paul
