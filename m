Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbZCaNV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbZCaNV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZCaNVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:21:18 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38916 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZCaNVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:21:17 -0400
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
From: Chris Mason <chris.mason@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
In-Reply-To: <49D13123.7040007@rtr.ca>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org>
	 <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp>
	 <49D0B687.1030407@oss.ntt.co.jp>
	 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	 <20090330175544.GX5178@kernel.dk>
	 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	 <20090330185414.GZ5178@kernel.dk>
	 <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
	 <20090330201732.GB5178@kernel.dk>  <49D13123.7040007@rtr.ca>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 09:16:16 -0400
Message-Id: <1238505376.8363.26.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.49D217A9.0046:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 16:52 -0400, Mark Lord wrote:
> Jens Axboe wrote:
> > On Mon, Mar 30 2009, Linus Torvalds wrote:
> >>
> >> On Mon, 30 Mar 2009, Jens Axboe wrote:
> >>> Sorry, I just don't see much point to doing it this way instead. So now
> >>> the fs will have to check a queue bit after it has issued the flush, how
> >>> is that any better than having the 'error' returned directly?
> >> No.
> >>
> >> Now the fs SHOULD NEVER CHECK AT ALL.
> >>
> >> Either it did the ordering, or the FS cannot do anything about it. 
> >>
> >> That's the point. EOPNOTSUPP is n ot a useful error message. You can't 
> >> _do_ anything about it.
> > 
> > My point is that some file systems may or may not have different paths
> > or optimizations depending on whether barriers are enabled and working
> > or not. Apparently that's just reiserfs and Chris says we can remove it,
> > so it is probably a moot point.
> ..
> 
> XFS appears to have something along those lines.
> I believe it tries to disable the drive write caches
> if it discovers that it cannot do cache flushes.
> 

If we get EOPNOTSUPP back from a submit_bh/submit_bio, the IO didn't
happen.  So, all the filesystems have code to try again without the
barrier flag, and then stop doing barriers from then on.

I'm not saying this is a good or bad API, just explaining for this one
example how it is being used today ;)

> I'll check next time my MythTV box boots up.
> It has a RAID0 under XFS, and the md raid0 code doesn't
> appear to pass the cache flushes to libata for raid0,
> so XFS complains and tries to turn off the write caches.
> 
>
> And I have a script to damn well turn them back ON again
> after it does so.  Stupid thing tries to override user policy again.
> 

XFS does print a warning about not doing barriers any more, but the
write cache should still be on.  Especially with MD in front of it, the
storage stack is pretty complex, a mounted filesystem would have a hard
time knowing where to start to turn off write caches on each drive in
the stack.

You can test this pretty easily:

dd if=/dev/zero of=foo bs=4k count=10000 oflag=direct

If that runs faster than 1MB/s the write cache is still on.

-chris


