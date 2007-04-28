Return-Path: <linux-kernel-owner+w=401wt.eu-S1163481AbXD1S1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163481AbXD1S1D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163482AbXD1S1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:27:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163481AbXD1S07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:26:59 -0400
Date: Sat, 28 Apr 2007 11:26:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070428112640.5b92b995.akpm@linux-foundation.org>
In-Reply-To: <20070428140907.GU19966@holomorphy.com>
References: <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	<20070427002640.22a71d06.akpm@linux-foundation.org>
	<20070427163620.GI32602149@melbourne.sgi.com>
	<20070427173432.GJ32602149@melbourne.sgi.com>
	<20070427121108.9ee05710.akpm@linux-foundation.org>
	<4632A6DF.7080301@yahoo.com.au>
	<1177747448.28223.26.camel@twins>
	<20070428012251.fae10a71.akpm@linux-foundation.org>
	<20070428140907.GU19966@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 07:09:07 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Sat, 28 Apr 2007 10:04:08 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> only 4.4 times faster, and more scalable, since we don't bounce the
> >> upper level locks around.
> 
> On Sat, Apr 28, 2007 at 01:22:51AM -0700, Andrew Morton wrote:
> > I'm not sure what we're looking at here.  radix-tree changes?  Locking
> > changes?  Both?
> > If we have a whole pile of pages to insert then there are obvious gains
> > from not taking the lock once per page (gang insert).  But I expect there
> > will also be gains from not walking down the radix tree once per page too:
> > walk all the way down and populate all the way to the end of the node.
> 
> The gang allocation affair would may also want to make the calls into
> the page allocator batched. For instance, grab enough compound pages to
> build the gang under the lock, since we're going to blow the per-cpu
> lists with so many pages, then break the compound pages up outside the
> zone->lock.

Sure, but...

Allocating a single order-3 (say) page _is_ a form of batching

We don't want compound pages here: just higher-order ones

Higher-order allocations bypass the per-cpu lists

> I think it'd be good to have some corresponding tactics for freeing as
> well.

hm, hadn't thought about that - would need to peek at contiguous pages in
the pagecache and see if we can gang-free them as higher-order pages.

The place to do that is perhaps inside the per-cpu magazines: it's more
general.  Dunno if it would net advantageous though.
