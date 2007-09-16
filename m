Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbXIPNzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbXIPNzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 09:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXIPNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 09:55:06 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:45870 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbXIPNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 09:55:04 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070915155100.GA21861@v2.random>
	<87tzpvy9cb.fsf@informatik.uni-tuebingen.de>
	<20070915223032.GA6708@v2.random>
Date: Sun, 16 Sep 2007 15:54:56 +0200
In-Reply-To: <20070915223032.GA6708@v2.random> (Andrea Arcangeli's message of
	"Sun, 16 Sep 2007 00:30:32 +0200")
Message-ID: <87d4wi3ebz.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@suse.de> writes:

> On Sat, Sep 15, 2007 at 10:14:44PM +0200, Goswin von Brederlow wrote:
>> - Userspace allocates a lot of memory in those slabs.
>
> If with slabs you mean slab/slub, I can't follow, there has never been
> a single byte of userland memory allocated there since ever the slab
> existed in linux.

This and other comments in your reply show me that you completly
misunderstood what I was talking about.

Look at
http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg

The red dots (pinned) are dentries, page tables, kernel stacks,
whatever kernel stuff, right?

The green dots (movable) are mostly userspace pages being mapped
there, right?

What I was refering too is that because movable objects (green dots)
aren't moved out of a mixed group (the boxes) when some unmovable
object needs space all the groups become mixed over time. That means
the unmovable objects are spread out over all the ram and the buddy
system can't recombine regions when unmovable objects free them. There
will nearly always be some movable objects in the other buddy. The
system of having unmovable and movable groups breaks down and becomes
useless.


I'm assuming here that we want the possibility of larger order pages
for unmovable objects (large continiuos regions for DMA for example)
than the smallest order user space gets (or any movable object). If
mmap() still works on 4k page bounaries then those will fragment all
regions into 4k chunks in the worst case.

Obviously if userspace has a minimum order of 64k chunks then it will
never break any region smaller than 64k chunks and will never cause a
fragmentation catastroph. I know that is verry roughly your aproach
(make order 0 bigger), and I like it, but it has some limits as to how
big you can make it. I don't think my system with 1GB ram would work
so well with 2MB order 0 pages. But I wasn't refering to that but to
the picture.

MfG
        Goswin
