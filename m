Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZFXOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZFXOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZFXOFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:05:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47826 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZFXOFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:05:09 -0400
Date: Wed, 24 Jun 2009 07:05:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net,
       Patrick McHardy <kaber@trash.net>, christine.caulfield@googlemail.com,
       Trond.Myklebust@netapp.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, yoshfuji@linux-ipv6.org,
       shemminger@linux-foundation.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-ext4@vger.kernel.org,
       tytso@mit.edu, adilger@sun.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 09/10] cfq-iosched: Uses its own open-coded rcu_barrier.
Message-ID: <20090624140505.GA6779@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090623150330.22490.87327.stgit@localhost> <20090623150439.22490.14657.stgit@localhost> <20090624064236.GE31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624064236.GE31415@kernel.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 08:42:37AM +0200, Jens Axboe wrote:
> On Tue, Jun 23 2009, Jesper Dangaard Brouer wrote:
> > This module cfq-iosched, has discovered the value of waiting for
> > call_rcu() completion, but its has its own open-coded implementation
> > of rcu_barrier(), which I don't think is 'strong' enough.
> > 
> > This patch only leaves a comment for the maintainers to consider.
> 
> We need a stronger primitive and rcu_barrier(), since we also need to
> wait for the rcu calls to even be scheduled. So I don't think the below
> can be improved, it's already fine.

It is indeed important to first prevent new call_rcu() instances from
being invoked, and only then invoke rcu_barrier().

							Thanx, Paul

> > Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> > ---
> > 
> >  block/cfq-iosched.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 833ec18..c15555b 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -2657,6 +2657,12 @@ static void __exit cfq_exit(void)
> >  	/*
> >  	 * this also protects us from entering cfq_slab_kill() with
> >  	 * pending RCU callbacks
> > +	 *
> > +	 * hawk@comx.dk 2009-06-18: Maintainer please consider using
> > +	 *  rcu_barrier() instead of this open-coded wait for
> > +	 *  completion implementation.  I think it provides a better
> > +	 *  guarantee that all CPUs are finished, although
> > +	 *  elv_ioc_count_read() do consider all CPUs.
> >  	 */
> >  	if (elv_ioc_count_read(ioc_count))
> >  		wait_for_completion(&all_gone);
> > 
> 
> -- 
> Jens Axboe
> 
