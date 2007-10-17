Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbXJQRA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbXJQRA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762484AbXJQRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:00:06 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18833 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760128AbXJQRAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:00:04 -0400
Date: Wed, 17 Oct 2007 18:59:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017165949.GF15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Ingo Molnar wrote:
> > 
> > Jens, just got this crash on a testbox:
> 
> The code in question is:
> 
>      mov    %edx,0xc(%esp)
>      mov    (%ebx),%edi
>      mov    %edi,%edx
>      sub    %eax,%edx
>      mov    %edx,%eax
>      sar    $0x5,%eax
>      shl    $0xc,%eax
>      add    0x8(%ebx),%eax
>      cmp    %eax,0xc(%esp)
>      je     +126
>      mov    0x10(%esi),%eax	<----- Oops
>      lea    0x10(%esi),%edx
>      test   $0x1,%al
>      jne    +76
>      mov    %edi,(%esi)
>      mov    %ebp,0xc(%esi)
>      mov    0x8(%ebx),%eax
>      mov    %eax,0x4(%esi)
> 
> 
> and it looks like %esi is overflowing from one page to the next one, ie:
> 
> 	BUG: unable to handle kernel paging request at virtual address 7ca76000
> 	ESI: 7ca75ff0
> 
> and you caught this thanks to page-alloc debugging again.
> 
> I think I can match that up with the source code: that's "sg_next()". It's 
> doing:
> 
>         sg++;
> 
>         if (unlikely(sg_is_chain(sg)))
>                 sg = sg_chain_ptr(sg);
> 
>         return sg;
> 
> and the oopsing instruction is that load of "sg->page" in the assembly 
> code:
> 
> 	mov    0x10(%esi),%eax		# %eax = sg->page
> 	lea    0x10(%esi),%edx		# %edx = sg+1;
> 	test   $0x1,%al			# if (unlikely(sg_is_chain()))
> 	jne    +76
> 
> Jens?

Yep, that's what I came up with as well - I asked Ingo for a dump in
private, but ended up just using ksymoops to decode the line.

The way blk_rq_map_sg() operates is that it ends up doing a

        next_sg = sg_next(sg);

even though sg may be the last entry. Perhaps this is crapping out,
although if sg is a valid address, then sg + 1 should be as well.
next_sg may end up being crap, in fact it will, but we'll never use that
unless there are more entries to fill. And if there is, then both sg and
next_sg were valid.

So nothing in for-linus should fix it, I'll try and come up with an
alternate way to assign next_sg so it's always valid.

-- 
Jens Axboe

