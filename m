Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbXFAFpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbXFAFpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXFAFpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:45:34 -0400
Received: from brick.kernel.dk ([80.160.20.94]:11873 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbXFAFpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:45:33 -0400
Date: Fri, 1 Jun 2007 07:44:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] sendfile removal (nfsd update)
Message-ID: <20070601054424.GJ32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531105543.GA25676@infradead.org> <20070531110550.GR32105@kernel.dk> <18014.48878.442628.260297@notabene.brown> <20070531122723.GT32105@kernel.dk> <18015.34830.401191.916084@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18015.34830.401191.916084@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01 2007, Neil Brown wrote:
> 
> Ok, here is a patch that makes nfsd use splice instead of sendfile.
> It appears to both compile and work.
> 
> Some observations:
>   - __splice_from_pipe wants a "struct file*" and I wanted to pass a
>     "struct svcrqst *".  Maybe it should take a void * ?
>   - It also wants a *ppos which I had no use for.. It that really
>     need?  Cannot &file->f_pos be used?

See:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=c73a9509ef7877d31e0c97c684ee8b7ed13ecbbe;hp=07f0e716250d4a3a550b2f39bd0a7e4e6566b3c2

I'll rebase the conversion on top of this one, loop will need the same
change.

>   - I copied do_splice_to from splice.c as it wasn't exported, and
>     then found I couldn't compile because rw_verify_area wasn't
>     exported. As nfsd doesn't need that (we never export
>     mandatory-locking files) I just remove it and some other cruft
>     that I didn't need.... Not sure if that was the best approach.
>   - I needed to export alloc_pipe_info.  Maybe there should be a 
>     get_current_pipe instead which does the alloc if needed.
>   - I would much rather have something like free_pipe_info exported
>     than open code it in do_splice_read (which is based heavily on
>     do_splice_direct).

I need the same thing for loop. I think I'll add do_splice_foo() to
fs/splice.c in a way that loop can use instead of do_splice_direct(),
then nfsd should be able to do the same.

Thanks for this Neil!

-- 
Jens Axboe

