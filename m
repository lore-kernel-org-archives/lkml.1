Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbZG3Qrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbZG3Qrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZG3Qrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:47:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48001 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZG3Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:47:34 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
       Neil Brown <neilb@suse.de>
Subject: Re: Why does __do_page_cache_readahead submit READ, not READA?
References: <20090729161456.GB8059@barkeeper1-xen.linbit>
	<20090729211845.GB4148@kernel.dk> <20090729225501.GH24801@think>
	<20090730060649.GC4148@kernel.dk> <20090730143409.GJ24801@think>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 30 Jul 2009 12:47:21 -0400
In-Reply-To: <20090730143409.GJ24801@think> (Chris Mason's message of "Thu, 30
	Jul 2009 10:34:09 -0400")
Message-ID: <x49fxcedso6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

> On Thu, Jul 30, 2009 at 08:06:49AM +0200, Jens Axboe wrote:
>> On Wed, Jul 29 2009, Chris Mason wrote:
>> > On Wed, Jul 29, 2009 at 11:18:45PM +0200, Jens Axboe wrote:
>> > > On Wed, Jul 29 2009, Lars Ellenberg wrote:
>> > > > I naively assumed, from the "readahead" in the name, that readahead
>> > > > would be submitting READA bios. It does not.
>> > > > 
>> > > > I recently did some statistics on how many READ and READA requests
>> > > > we actually see on the block device level.
>> > > > I was suprised that READA is basically only used for file system
>> > > > internal meta data (and not even for all file systems),
>> > > > but _never_ for file data.
>> > > > 
>> > > > A simple
>> > > > 	dd if=bigfile of=/dev/null bs=4k count=1
>> > > > will absolutely cause readahead of the configured amount, no problem.
>> > > > But on the block device level, these are READ requests, where I'd
>> > > > expected them to be READA requests, based on the name.
>> > > > 
>> > > > This is because __do_page_cache_readahead() calls read_pages(),
>> > > > which in turn is mapping->a_ops->readpages(), or, as fallback,
>> > > > mapping->a_ops->readpage().
>> > > > 
>> > > > On that level, all variants end up submitting as READ.
>> > > > 
>> > > > This may even be intentional.
>> > > > But if so, I'd like to understand that.
>> > > 
>> > > I don't think it's intentional, and if memory serves, we used to use
>> > > READA when submitting read-ahead. Not sure how best to improve the
>> > > situation, since (as you describe), we lose the read-ahead vs normal
>> > > read at that level. I did some experimentation some time ago for
>> > > flagging this, see:
>> > > 
>> > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=16cfe64e3568cda412b3cf6b7b891331946b595e
>> > > 
>> > > which should pass down READA properly.
>> > 
>> > One of the problems in the past was that reada would fail if there
>> > wasn't a free request when we actually wanted it to go ahead and wait.
>> > Or something.  We've switched it around a few times I think.
>> 
>> Yes, we did used to do that, whether it was 2.2 or 2.4 I
>> don't recall :-)
>> 
>> It should be safe to enable know, whether there's a prettier way
>> than the above, I don't know. It works by detecting the read-ahead
>> marker, but it's a bit of a fragile design.
>
> I dug through my old email and found this fun bug w/buffer heads and
> reada.
>
> 1) submit reada ll_rw_block on ext3 directory block
> 2) decide that we really really need to wait on this block
> 3) wait_on_buffer(bh) ; check up to date bit when done
>
> The problem in the bugzilla was that reada was returning EAGAIN or
> EWOULDBLOCK, and the whole filesystem world expects that if we
> wait_on_buffer and don't find the buffer up to date, its time
> set things read only and run around screaming.
>
> The expectations in the code at the time were that the caller needs to
> be aware the request may fail with EAGAIN/EWOULDBLOCK, but the reality
> was that everyone who found that locked buffer also needed to be able to
> check for it.  This one bugzilla had a teeny window where the reada
> buffer head was leaked to the world.
>
> So, I think we can start using it again if it is just a hint to the
> elevator about what to do with the IO, and we never actually turn the
> READA into a transient failure (which I think is mostly true today, there
> weren't many READA tests in the code I could see).

Well, is it a hint to the elevator or to the driver (or both)?  The one
bug I remember regarding READA failing was due to the FAILFAST bit
getting set for READA I/O, and the powerpath driver returning a failure.
Is that the bug to which you are referring?

Cheers,
Jeff
