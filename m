Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbXISCOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbXISCOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 22:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXISCO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 22:14:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbXISCO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 22:14:26 -0400
Date: Tue, 18 Sep 2007 19:14:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ethan Solomita <solo@google.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/6] cpuset write dirty map
Message-Id: <20070918191405.d9b43470.akpm@linux-foundation.org>
In-Reply-To: <46F072A5.8060008@google.com>
References: <469D3342.3080405@google.com>
	<46E741B1.4030100@google.com>
	<46E742A2.9040006@google.com>
	<20070914161536.3ec5c533.akpm@linux-foundation.org>
	<46F072A5.8060008@google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:51:49 -0700 Ethan Solomita <solo@google.com> wrote:

> > 
> >> +void cpuset_update_dirty_nodes(struct address_space *mapping,
> >> +			struct page *page)
> >> +{
> >> +	nodemask_t *nodes = mapping->dirty_nodes;
> >> +	int node = page_to_nid(page);
> >> +
> >> +	if (!nodes) {
> >> +		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);
> > 
> > Does it have to be atomic?  atomic is weak and can fail.
> > 
> > If some callers can do GFP_KERNEL and some can only do GFP_ATOMIC then we
> > should at least pass the gfp_t into this function so it can do the stronger
> > allocation when possible.
> 
> 	I was going to say that sanity would be improved by just allocing the
> nodemask at inode alloc time. A failure here could be a problem because
> below cpuset_intersects_dirty_nodes() assumes that a NULL nodemask
> pointer means that there are no dirty nodes, thus preventing dirty pages
> from getting written to disk. i.e. This must never fail.
> 
> 	Given that we allocate it always at the beginning, I'm leaning towards
> just allocating it within mapping no matter its size. It will make the
> code much much simpler, and save me writing all the comments we've been
> discussing. 8-)
> 
> 	How disastrous would this be? Is the need to support a 1024 node system
> with 1,000,000 open mostly-read-only files thus needing to spend 120MB
> of extra memory on my nodemasks a real scenario and a showstopper?

None of this is very nice.  Yes, it would be good to save all that memory
and yes, I_DIRTY_PAGES inodes are very much the uncommon case.

But if a failed GFP_ATOMIC allocation results in data loss then that's a
showstopper.

How hard would it be to handle the allocation failure in a more friendly
manner?  Say, if the allocation failed then point mapping->dirty_nodes at
some global all-ones nodemask, and then special-case that nodemask in the
freeing code?

> > 
> > 
> >> +		if (!nodes)
> >> +			return;
> >> +
> >> +		*nodes = NODE_MASK_NONE;
> >> +		mapping->dirty_nodes = nodes;
> >> +	}
> >> +
> >> +	if (!node_isset(node, *nodes))
> >> +		node_set(node, *nodes);
> >> +}
> >> +
> >> +void cpuset_clear_dirty_nodes(struct address_space *mapping)
> >> +{
> >> +	nodemask_t *nodes = mapping->dirty_nodes;
> >> +
> >> +	if (nodes) {
> >> +		mapping->dirty_nodes = NULL;
> >> +		kfree(nodes);
> >> +	}
> >> +}
> > 
> > Can this race with cpuset_update_dirty_nodes()?  And with itself?  If not,
> > a comment which describes the locking requirements would be good.
> 
> 	I'll add a comment. Such a race should not be possible. It is called
> only from clear_inode() which is used when the inode is being freed
> "with extreme prejudice" (from its comments). I can add a check that
> i_state I_FREEING is set. Would that do?

Sounds sane.


