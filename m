Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXDZTqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXDZTqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXDZTqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:46:20 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17614 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXDZTqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:46:19 -0400
Date: Thu, 26 Apr 2007 21:42:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426194234.GL2017@kernel.dk>
References: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org> <20070426181249.GH2017@kernel.dk> <Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com> <20070426182945.GJ2017@kernel.dk> <Pine.LNX.4.64.0704261134080.3656@schroedinger.engr.sgi.com> <20070426183935.GK2017@kernel.dk> <m1irbjj5ej.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1irbjj5ej.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Eric W. Biederman wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Thu, Apr 26 2007, Christoph Lameter wrote:
> >> On Thu, 26 Apr 2007, Jens Axboe wrote:
> >> 
> >> > On Thu, Apr 26 2007, Christoph Lameter wrote:
> >> > > On Thu, 26 Apr 2007, Jens Axboe wrote:
> >> > > 
> >> > > > The above can be implemented fairly cleanly, and on a need-to-have
> >> > > > basis. It's not something that'll break drivers.
> >> > > 
> >> > > But its also not going to fix the hacks that we have in the kernel 
> >> > > to deal with > PAGE_SIZE i/o.
> >> > 
> >> > No, but that's a _seperate_ issue! Don't keep mixing up the two.
> >> 
> >> Yes I understand that you want it to be a separate issue so we get get 
> >> more rationales for the hacks that we do to avoid the large 
> >> order allocations.
> >
> > Christoph, don't take your frustrations out on me. I've several times in
> > this thread said that I'd LIKE to have > PAGE_SIZE support in the page
> > cache. I WROTE the initial pktcdvd driver that is a primary example of
> > these hacks, I'm very well aware of the pain and bugs involved with
> > that.
> >
> > But don't push large pages as the only solution to larger ios, because
> > that is trivially not true.
> 
> Just taking a quick look at pktcdvd that does appear to be a case where
> we want to express to the rest of the system that our block device has
> a > 2KB block size.
> 
> I think it would be very useful to express to the rest of the system
> that yes indeed this device has a 32K sector size (or whatever the
> real limit is) instead of hiding that fact away.
> 
> Now I'm not a block layer expert and my knowledge of the page cache
> is rusty.  So I can't immediately point to a way we can do this.
> I'll guess that it will require cleaning up some old crufty code that
> no one wants to touch.
> 
> I will point out that while this appears to require support from
> upper levels it also does not require a larger physical page size
> in the page cache.

Yep, if you could just have > PAGE_CACHE_SIZE blocks in the filesystem
easily, the problem would basically be solved for cd and dvd packet
writing.

> Am I correct in assuming that the problem is primarily about getting
> filesystems (and other upper layers) to submit BIOs that take into
> consideration the larger block size of the underlying device, so
> that read/modify write is not needed in the pktcdvd layer?

Yes, that is exactly the problem. Once you have that, pktcdvd is pretty
much reduced to setup and init code, the actual data handling can be
done by sr or ide-cd directly. You could merge it into cdrom.c, it would
not be very different from mt-rainier handling (which basically does RMW
in firmware, so it works for any write, but performance is of course
horrible if you don't do it right).

-- 
Jens Axboe

