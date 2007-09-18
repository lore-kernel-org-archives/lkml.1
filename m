Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbXIRRaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbXIRRaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbXIRR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:29:47 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23321 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754409AbXIRR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:29:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=hUDO1VXSnCEWjsSP091LmTtqiFH9yNAbVmx73F+AOJQ47RY9u4kocZR95jt+A2Rli+IQT8f5AnyOAaOEE4nCKatfBYOcTSYOpgUIXyrl4GdXp9vda+KAIflZ5peqfQsrTr55Y+/Xb/oGACEl7xCcxL1QBbD0XZxmbyzMRUzigwY=  ;
X-YMail-OSG: iGXI8QUVM1nDAZ6Remnaf5tkTDMHcoWFXGCLJYGJycoKNOTjiuXfK2X2Vy.mGtlIrjzxNRvn3g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 18 Sep 2007 10:10:27 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709161822.47879.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171504150.29993@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709171504150.29993@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709181010.28043.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 08:05, Christoph Lameter wrote:
> On Sun, 16 Sep 2007, Nick Piggin wrote:
> > > > fsblock doesn't need any of those hacks, of course.
> > >
> > > Nor does mine for the low orders that we are considering. For order >
> > > MAX_ORDER this is unavoidable since the page allocator cannot manage
> > > such large pages. It can be used for lower order if there are issues
> > > (that I have not seen yet).
> >
> > Or we can just avoid all doubt (and doesn't have arbitrary limitations
> > according to what you think might be reasonable or how well the
> > system actually behaves).
>
> We can avoid all doubt in this patchset as well by adding support for
> fallback to a vmalloced compound page.

How would you do a vmapped fallback in your patchset? How would
you keep track of pages 2..N if they don't exist in the radix tree?
What if they don't even exist in the kernel's linear mapping? It seems
you would also require more special casing in the fault path and special
casing in the block layer to do this.

It's not a trivial problem you can just brush away by handwaving. Let's
see... you could add another field in struct page to store the vmap
virtual address, and set a new flag to indicate indicate that constituent
page N can be found via vmalloc_to_page(page->vaddr + N*PAGE_SIZE).
Then add more special casing to the block layer and fault path etc. to handle
these new non-contiguous compound pages. I guess you must have thought
about it much harder than the 2 minutes I just did then, so you must have a
much nicer solution...

But even so, you're still trying very hard to avoid touching the filesystems
or buffer layer while advocating instead to squeeze the complexity out into
the vm and block layer. I don't agree that is the right thing to do. Sure it
is _easier_, because we know the VM.

I don't argue that fsblock large block support is trivial. But you are first
asserting that it is too complicated and then trying to address one of the
issues it solves by introducing complexity elsewhere.
