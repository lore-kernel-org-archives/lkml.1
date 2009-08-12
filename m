Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZHLOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZHLOLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZHLOLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:11:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41568 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZHLOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:11:19 -0400
Date: Wed, 12 Aug 2009 07:11:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com
Subject: Re: [PATCHv2 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090812141107.GD6833@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1249992497.git.mst@redhat.com> <20090811212802.GC26309@redhat.com> <4A82076A.1060805@gmail.com> <20090812090219.GB26847@redhat.com> <4A82BD2F.7080405@gmail.com> <20090812132539.GD29200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812132539.GD29200@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 04:25:40PM +0300, Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 09:01:35AM -0400, Gregory Haskins wrote:
> > I think I understand what your comment above meant:  You don't need to
> > do synchronize_rcu() because you can flush the workqueue instead to
> > ensure that all readers have completed.
> 
> Yes.
> 
> >  But if thats true, to me, the
> > rcu_dereference itself is gratuitous,
> 
> Here's a thesis on what rcu_dereference does (besides documentation):
> 
> reader does this
> 
> 	A: sock = n->sock
> 	B: use *sock
> 
> Say writer does this:
> 
> 	C: newsock = allocate socket
> 	D: initialize(newsock)
> 	E: n->sock = newsock
> 	F: flush
> 
> 
> On Alpha, reads could be reordered.  So, on smp, command A could get
> data from point F, and command B - from point D (uninitialized, from
> cache).  IOW, you get fresh pointer but stale data.
> So we need to stick a barrier in there.
> 
> > and that pointer is *not* actually
> > RCU protected (nor does it need to be).
> 
> Heh, if readers are lockless and writer does init/update/sync,
> this to me spells rcu.

If you are using call_rcu(), synchronize_rcu(), or one of the
similar primitives, then you absolutely need rcu_read_lock() and
rcu_read_unlock(), or one of the similar pairs of primitives.

If you -don't- use rcu_read_lock(), then you are pretty much restricted
to adding data, but never removing it.

Make sense?  ;-)

							Thanx, Paul
