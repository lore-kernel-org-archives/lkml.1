Return-Path: <linux-kernel-owner+w=401wt.eu-S1423229AbXDYG1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423229AbXDYG1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423230AbXDYG1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:27:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48901 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423229AbXDYG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:27:48 -0400
Date: Tue, 24 Apr 2007 23:27:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [08/17] Define functions for page cache handling
In-Reply-To: <462E8C1E.6070204@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0704242324520.21125@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070424222306.289124159@sgi.com>
 <462E8C1E.6070204@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Eric Dumazet wrote:

> >  	struct radix_tree_root	page_tree;	/* radix tree of all pages */
> >  	rwlock_t		tree_lock;	/* and rwlock protecting it */
> > +#ifdef CONFIG_LARGE_BLOCKSIZE
> > +	unsigned int		order;		/* Page order of the pages in
> > here */
> > +	unsigned int		shift;		/* Shift of index */
> > +	loff_t			offset_mask;	/* Mask to get to offset bits
> > */
> > +#endif
> >  	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
> >  	struct prio_tree_root	i_mmap;		/* tree of private and shared
> > mappings */
> >  	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings
> > */
> 
> Some comments about this :
> 
> 1) not optimal placement on 64bits arches (it creates one hole before
> i_mmap_writeable)

loff_t is a 64 bit long. We could put shift behind offset_mask.

> 2) sizeof(struct address_space) is an issue, given it is included in every
> inode, even sockets or pipes.

Right. I had an earlier implementation that just used an order field. See 
V2 of this patchset. That did a lot of shifting instead of lookups.
 
> -> 2.1) Do we really need 32 bits for 'order' and 'shift'

No. u8 would be sufficient. If you can stuff in other stuff in between 
then I can switch it.

> -> 2.2) Do we really need a 64bits offset_mask since it's a trivial arithmetic
> from 'shift' (or 'order') ?

It simplifies the generated asm code significantly.

> BTW, I presume splice() is not yet supported ? If yes, each pipe could hold 16
> 'big pages' so we probably can hit some DOS condition sooner...

Not yet. I'd be glad if you could come up with a patch that converts it.

