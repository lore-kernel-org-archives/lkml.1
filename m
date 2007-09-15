Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXIOUQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXIOUQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 16:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXIOUQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 16:16:11 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:40561 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbXIOUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 16:16:10 -0400
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
Date: Sat, 15 Sep 2007 22:14:44 +0200
In-Reply-To: <20070915155100.GA21861@v2.random> (Andrea Arcangeli's message of
	"Sat, 15 Sep 2007 17:51:01 +0200")
Message-ID: <87tzpvy9cb.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@suse.de> writes:

> On Sat, Sep 15, 2007 at 02:14:42PM +0200, Goswin von Brederlow wrote:
>> I keep coming back to the fact that movable objects should be moved
>> out of the way for unmovable ones. Anything else just allows
>
> That's incidentally exactly what the slab does, no need to reinvent
> the wheel for that, it's an old problem and there's room for
> optimization in the slab partial-reuse logic too. Just boost the order
> 0 page size and use the slab to get the 4k chunks. The sgi/defrag
> design is backwards.

How does that help? Will slabs move objects around to combine two
partially filled slabs into nearly full one? If not consider this:

- You create a slab for 4k objects based on 64k compound pages.
  (first of all that wastes you a page already for the meta infos)
- Something movable allocates a 14 4k page in there making the slab
  partially filled.
- Something unmovable alloactes a 4k page making the slab mixed and
  full.
- Repeat until out of memory.

OR

- Userspace allocates a lot of memory in those slabs.
- Userspace frees one in every 15 4k chunks.
- Userspace forks 1000 times causing an unmovable task structure to
  appear in 1000 slabs. 

MfG
        Goswin
