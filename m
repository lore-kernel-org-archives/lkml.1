Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZFWCoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZFWCoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZFWCoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:44:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42838 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbZFWCoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:44:12 -0400
Date: Mon, 22 Jun 2009 22:43:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090623024337.GC3620@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-3-git-send-email-vgoyal@redhat.com> <20090622084612.GD3728@balbir.in.ibm.com> <20090622124313.GF28770@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622124313.GF28770@gandalf.sssup.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 02:43:13PM +0200, Fabio Checconi wrote:

[..]
> > > +/**
> > > + * bfq_first_active - find the eligible entity with the smallest finish time
> > > + * @st: the service tree to select from.
> > > + *
> > > + * This function searches the first schedulable entity, starting from the
> > > + * root of the tree and going on the left every time on this side there is
> > > + * a subtree with at least one eligible (start <= vtime) entity.  The path
> > > + * on the right is followed only if a) the left subtree contains no eligible
> > > + * entities and b) no eligible entity has been found yet.
> > > + */
> > > +static struct io_entity *bfq_first_active_entity(struct io_service_tree *st)
> > > +{
> > > +	struct io_entity *entry, *first = NULL;
> > > +	struct rb_node *node = st->active.rb_node;
> > > +
> > > +	while (node != NULL) {
> > > +		entry = rb_entry(node, struct io_entity, rb_node);
> > > +left:
> > > +		if (!bfq_gt(entry->start, st->vtime))
> > > +			first = entry;
> > > +
> > > +		BUG_ON(bfq_gt(entry->min_start, st->vtime));
> > > +
> > > +		if (node->rb_left != NULL) {
> > > +			entry = rb_entry(node->rb_left,
> > > +					 struct io_entity, rb_node);
> > > +			if (!bfq_gt(entry->min_start, st->vtime)) {
> > > +				node = node->rb_left;
> > > +				goto left;
> > > +			}
> > > +		}
> > > +		if (first != NULL)
> > > +			break;
> > > +		node = node->rb_right;
> > 
> > Please help me understand this, we sort the tree by finish time, but
> > search by vtime, start_time. The worst case could easily be O(N),
> > right?
> > 
> 
> no, (again, the full answer is in the paper); the nice property of
> min_start is that it partitions the tree in two regions, one with
> eligible entities and one without any of them.  once we know that
> there is one eligible entity (checking the min_start at the root)
> we can find the node i with min(F_i) subject to S_i < V walking down
> a single path from the root to the leftmost eligible entity.  (we
> need to go to the right only if the subtree on the left contains 
> no eligible entities at all.)  since the RB tree is balanced this
> can be done in O(log N).
> 

Hi Fabio,

When I go thorough the paper you mentioned above, they seem to have
sorted the tree based on eligible time (looks like equivalent of start
time) and then keep track of minimum deadline on each node (equivalnet of
finish time).

We seem to be doing reverse in BFQ where we sort tree on finish time
and keep track of minimum start time on each node. Is there any specific
reason behind that?

Thanks
Vivek
