Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZC3UON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZC3UON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbZC3UNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:13:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760757AbZC3UNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:13:47 -0400
Date: Mon, 30 Mar 2009 12:59:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
In-Reply-To: <49D11A8D.1090600@garzik.org>
Message-ID: <alpine.LFD.2.00.0903301248500.4093@localhost.localdomain>
References: <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <49D11A8D.1090600@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Jeff Garzik wrote:
>
> Indeed -- if the drive tells us it failed the cache flush, it seems
> self-evident that we should be passing that failure back to userspace where
> possible.

That's not what EOPNOTSUPP means!

EOPNOTSUPP doesn't mean "the cache flush failed". It just means "I don't 
support cache flushing".

No failure anywhere. See?

Maybe the operation isn't supported becasue there are no caches? Who the 
hell knows? Nobody. The layer just said "I don't support this". For 
example, maybe it just cannot translate the "flush cache" op into its own 
command set, because the thing doesn't _do_ anything like that.

For a concrete example, look at the "loop" driver. It literally returns 
EOPNOTSUPP if the filesystem doesn't have a "fsync()" thing. Ok, so it 
can't do serialization - does that mean that the caller should fail 
entirely? No. But it means that the caller cannot serialize, so now the 
caller has two choices:

 - not work at all

 - ignore it, and assume that a device without serialization is serialized 
   enough as-is.

Those are the two only choices. The caller knows that it can't flush. What 
would you _suggest_ it do? Just stop, and do nothing at all? I rally don't 
think that's a useful or valid approach.

And notice - at NO TIME did anythign actually fail. It's just that the 
particular protocol didn't support that empty flush op.

(Also note that block/blk-barrier.c really does an empty barrier command. 
If we were to be talking about a real IO with a real payload and the 
"barrier" bit set, that would be different. But we really aren't.)


		Linus
