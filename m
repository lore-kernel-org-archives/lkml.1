Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbYEMSDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbYEMSDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYEMSDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:03:44 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20083 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYEMSDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:03:43 -0400
Date: Tue, 13 May 2008 20:03:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew <jackdachef@gmail.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080513180334.GS16217@kernel.dk>
References: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com> <1210514567.7827.62.camel@localhost> <20080513122021.GP16217@kernel.dk> <e85b9d30805130558l502addbcq21996b92fdbfdc5b@mail.gmail.com> <20080513130508.GQ16217@kernel.dk> <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13 2008, Matthew wrote:
> On Tue, May 13, 2008 at 3:05 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > On Tue, May 13 2008, Matthew wrote:
> >  > On Tue, May 13, 2008 at 2:20 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >  > >
> >  > > On Sun, May 11 2008, Kasper Sandberg wrote:
> >  > >  > On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
> >  > >  > > I've been experiencing this for a while also; an almost 50% regression
> >  > >  > > is seen for single-process reads (ie sync) if slice_idle is 1ms or
> >  > >  > > more (eg default of 8) [1], which seems phenomenal.
> >  > >  > >
> >  > >  > > Jens, is this the expected price to pay for optimal busy-spindle
> >  > >  > > scheduling, a design issue, bug or am I missing something totally?
> >  > >  > >
> >  > >  > > Thanks,
> >  > >  > >   Daniel
> >  > [snip]
> >  > ...
> >  > [snip]
> >  > >  >
> [snip]
> 
> ...
> 
> [snip]
> >  > well - back to topic:
> >  >
> >  > for a blktrace one need to enable  CONFIG_BLK_DEV_IO_TRACE , right ?
> >  > blktrace can be obtained from your git-repo ?
> >
> >  Yes on both accounts, or just grab a blktrace snapshot from:
> >
> >  http://brick.kernel.dk/snaps/blktrace-git-latest.tar.gz
> >
> >  if you don't use git.
> >
> >  --
> >  Jens Axboe
> >
> >
> 
> unfortunately that snapshot wouldn't compile for me because of an error,
> I used the in-tree provided snapshot from portage: 0.0.20071210202527
> I hope that's ok, too;

That's fine, it doesn't really matter. But I'd appreciate if you sent me
the compile error in private, so that I can fix it :-)

> attached you'll fine the btrace (2 files) as a tar.bz2 package
> 
> from cfq
> 
> here the corresponding hdparm-output:
> hdparm -t /dev/sdd
> 
> /dev/sdd:
>  Timing buffered disk reads:  152 MB in  3.02 seconds =  50.38 MB/sec
> 
> blktrace /dev/sdd
> Device: /dev/sdd
>   CPU  0:                    0 events,     4136 KiB data
>   CPU  1:                    0 events,       11 KiB data
>   Total:                     0 events (dropped 0),     4146 KiB data
> 
> and the corresponding output of anticipatory and attached the btrace of it:
> 
> hdparm -t /dev/sdd
> 
> /dev/sdd:
>  Timing buffered disk reads:  310 MB in  3.02 seconds = 102.76 MB/sec
> 
> blktrace /dev/sdd
> Device: /dev/sdd
>   CPU  0:                    0 events,     7831 KiB data
>   CPU  1:                    0 events,      132 KiB data
>   Total:                     0 events (dropped 0),     7962 KiB data

They seem to start out the same, but then CFQ gets interrupted by a
timer unplug (which is also odd) and after that the request size drops.
On most devices you don't notice, but some are fairly picky about
request sizes. The end result is that CFQ has an average dispatch
request size of 142kb, where AS is more than double that at 306kb. I'll
need to analyze the data and look at the code a bit more to see WHY this
happens.

-- 
Jens Axboe

