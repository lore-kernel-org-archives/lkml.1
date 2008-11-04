Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYKDVnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYKDVnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYKDVnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:43:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335AbYKDVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:43:44 -0500
Date: Tue, 4 Nov 2008 13:42:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: rientjes@google.com, npiggin@suse.de, peterz@infradead.org,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
Message-Id: <20081104134256.24db6b36.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811041513490.23418@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0810300310180.18283@chino.kir.corp.google.com>
	<20081104130918.bee16cff.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041513490.23418@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 15:20:56 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 4 Nov 2008, Andrew Morton wrote:
> 
> >> +#ifdef CONFIG_CPUSETS
> >> +#if MAX_NUMNODES <= BITS_PER_LONG
> >> +	nodemask_t		dirty_nodes;	/* nodes with dirty pages */
> >> +#else
> >> +	nodemask_t		*dirty_nodes;	/* pointer to mask, if dirty */
> >> +#endif
> >> +#endif
> >>  } __attribute__((aligned(sizeof(long))));
> >
> > eek.  Increasing the size of the address_space (and hence of the inode)
> > is a moderately big deal - there can be millions of these in memory.
> 
> Well this is adding only a single word to the inode structure.

multiplied by millions.

> >> @@ -72,6 +72,8 @@ struct writeback_control {
> >>  	 * so we use a single control to update them
> >>  	 */
> >>  	unsigned no_nrwrite_index_update:1;
> >> +
> >> +	nodemask_t *nodes;		/* Nodemask to writeback */
> >
> > This one doesn't get ifdefs?
> 
> The structure is typically allocated temporarily on the stack.

An ifdef also helps catch the presence of unnecesary code.

> >> +	nodemask_t *nodes = mapping->dirty_nodes;
> >> +	int node = page_to_nid(page);
> >> +
> >> +	if (!nodes) {
> >> +		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);
> >
> > erk, OK, called from __set_page_dirty, needs to be atomic.
> >
> > What are the consequences when this allocation fails?
> 
> Dirty tracking will not occur. All nodes are assumed to be dirty.

It won't oops?

> We discussed this earlier 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/2291.html

Well, if it isn't in the changelog and isn't in code comments, we get
to discuss it again.

A great amount of mailing list discussion is a Huge Honking Big Fat
Hint that the original code was insufficently understandable.
