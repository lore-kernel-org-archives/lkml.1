Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbYKLMWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbYKLMWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYKLMWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:22:12 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55508 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYKLMWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:22:11 -0500
Date: Wed, 12 Nov 2008 13:20:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081112122033.GO26778@kernel.dk>
References: <49187D05.9050407@telenet.dn.ua> <x491vxjqmg0.fsf@segfault.boston.devel.redhat.com> <20081111093426.GS26778@kernel.dk> <20081111093540.GT26778@kernel.dk> <20081111115227.GU26778@kernel.dk> <4919B884.5000604@telenet.dn.ua> <20081111180659.GC26778@kernel.dk> <x49vduunjh4.fsf@segfault.boston.devel.redhat.com> <20081111164104.48f4dbd8@tleilax.poochiereds.net> <20081111165931.6f98401b@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111165931.6f98401b@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11 2008, Jeff Layton wrote:
> On Tue, 11 Nov 2008 16:41:04 -0500
> Jeff Layton <jlayton@redhat.com> wrote:
> 
> > On Tue, 11 Nov 2008 14:36:07 -0500
> > Jeff Moyer <jmoyer@redhat.com> wrote:
> > 
> > > Jens Axboe <jens.axboe@oracle.com> writes:
> > > 
> > > > OK, that looks better. Can I talk you into just trying this little
> > > > patch, just to see what kind of performance that yields? Remove the cfq
> > > > patch first. I would have patched nfsd only, but this is just a quick'n
> > > > dirty.
> > > 
> > > I went ahead and gave it a shot.  The updated CFQ patch with no I/O
> > > context sharing does about 40MB/s reading a 1GB file.  Backing that
> > > patch out, and then adding the patch to share io_context's between
> > > kthreads yields 45MB/s.
> > > 
> > 
> > Here's a quick and dirty patch to make all of the nfsd's have the same
> > io_context. Comments appreciated -- I'm not that familiar with the IO
> > scheduling code. If this looks good, I'll clean it up, add some
> > comments and formally send it to Bruce.
> > 
> 
> No sooner than I send it out than I find a bug. We need to eventually
> put the io_context reference we get. This should be more correct:

That sort of thing happens a lot, I can definitely sympathize with you
there :-)

> ----------------[snip]-------------------
> 
> From d0ee67045a12c677883f77791c6f260588c7b41f Mon Sep 17 00:00:00 2001
> From: Jeff Layton <jlayton@redhat.com>
> Date: Tue, 11 Nov 2008 16:54:16 -0500
> Subject: [PATCH] knfsd: make all nfsd threads share an io_context
> 
> This apparently makes the I/O scheduler treat the threads as a group
> which helps throughput when sequential I/O is multiplexed over several
> nfsd's.

That's a lot more nifty than my stupid CLONE_IO flag addition. Both are
only good for test purposes though.

It's a bit difficult to make this really mergeable. I don't know
anything about how nfsd manages its thread pool, but something more
appropriate would be an io context per client mount. That's still not
perfect as you could easily have more than one process doing simultanous
IO on the client side, but it's a lot better.

-- 
Jens Axboe

