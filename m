Return-Path: <linux-kernel-owner+w=401wt.eu-S1423199AbXDXXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423199AbXDXXBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423204AbXDXXBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:01:15 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:34332 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423199AbXDXXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:01:15 -0400
Message-ID: <462E8C1E.6070204@cosmosbay.com>
Date: Wed, 25 Apr 2007 01:00:46 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: clameter@sgi.com
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [08/17] Define functions for page cache handling
References: <20070424222105.883597089@sgi.com> <20070424222306.289124159@sgi.com>
In-Reply-To: <20070424222306.289124159@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 25 Apr 2007 01:00:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clameter@sgi.com a écrit :

> --- linux-2.6.21-rc7.orig/include/linux/fs.h	2007-04-24 11:31:49.000000000 -0700
> +++ linux-2.6.21-rc7/include/linux/fs.h	2007-04-24 11:37:21.000000000 -0700
> @@ -435,6 +435,11 @@ struct address_space {
>  	struct inode		*host;		/* owner: inode, block_device */
>  	struct radix_tree_root	page_tree;	/* radix tree of all pages */
>  	rwlock_t		tree_lock;	/* and rwlock protecting it */
> +#ifdef CONFIG_LARGE_BLOCKSIZE
> +	unsigned int		order;		/* Page order of the pages in here */
> +	unsigned int		shift;		/* Shift of index */
> +	loff_t			offset_mask;	/* Mask to get to offset bits */
> +#endif
>  	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
>  	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
>  	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */

Some comments about this :

1) not optimal placement on 64bits arches (it creates one hole before 
i_mmap_writeable)

2) sizeof(struct address_space) is an issue, given it is included in every 
inode, even sockets or pipes.

-> 2.1) Do we really need 32 bits for 'order' and 'shift'
-> 2.2) Do we really need a 64bits offset_mask since it's a trivial arithmetic 
from 'shift' (or 'order') ?

BTW, I presume splice() is not yet supported ? If yes, each pipe could hold 16 
  'big pages' so we probably can hit some DOS condition sooner...


