Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbZDCJlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbZDCJlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbZDCJlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:41:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:34813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZDCJlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:41:14 -0400
Date: Fri, 3 Apr 2009 11:41:10 +0200
From: Jan Kara <jack@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090403094110.GB18569@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200904022224.31060.nickpiggin@yahoo.com.au> <20090402113400.GC3010@duck.suse.cz> <200904030251.22197.nickpiggin@yahoo.com.au> <604427e00904021044n73302f4uc39ca09fe96caf57@mail.gmail.com> <604427e00904021552m7ef58163n5392bbe54d902c21@mail.gmail.com> <20090402233908.GA22206@duck.suse.cz> <604427e00904021829j6a9aba65gafcc67df9c842a86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604427e00904021829j6a9aba65gafcc67df9c842a86@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-04-09 18:29:21, Ying Han wrote:
> On Thu, Apr 2, 2009 at 4:39 PM, Jan Kara <jack@suse.cz> wrote:
> > On Thu 02-04-09 15:52:19, Ying Han wrote:
> >> On Thu, Apr 2, 2009 at 10:44 AM, Ying Han <yinghan@google.com> wrote:
> >> > On Thu, Apr 2, 2009 at 8:51 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >> >> On Thursday 02 April 2009 22:34:01 Jan Kara wrote:
> >> >>> On Thu 02-04-09 22:24:29, Nick Piggin wrote:
> >> >>> > On Thursday 02 April 2009 09:36:13 Ying Han wrote:
> >> >>> > > Hi Jan:
> >> >>> > >     I feel that the problem you saw is kind of differnt than mine. As
> >> >>> > > you mentioned that you saw the PageError() message, which i don't see
> >> >>> > > it on my system. I tried you patch(based on 2.6.21) on my system and
> >> >>> > > it runs ok for 2 days, Still, since i don't see the same error message
> >> >>> > > as you saw, i am not convineced this is the root cause at least for
> >> >>> > > our problem. I am still looking into it.
> >> >>> > >     So, are you seeing the PageError() every time the problem happened?
> >> >>> >
> >> >>> > So I asked if you could test with my workaround of taking truncate_mutex
> >> >>> > at the start of ext2_get_blocks, and report back. I never heard of any
> >> >>> > response after that.
> >> >>> >
> >> >>> > To reiterate: I was able to reproduce a problem with ext2 (I was testing
> >> >>> > on brd to get IO rates high enough to reproduce it quite frequently).
> >> >>> > I think I narrowed the problem down to block allocation or inode block
> >> >>> > tree corruption because I was unable to reproduce it with that hack in
> >> >>> > place.
> >> >>>   Nick, what load did you use for reproduction? I'll try to reproduce it
> >> >>> here so that I can debug ext2...
> >> >>
> >> >> OK, I set up the filesystem like this:
> >> >>
> >> >> modprobe rd rd_size=$[3*1024*1024]   #almost fill memory so we reclaim buffers
> >> >> dd if=/dev/zero of=/dev/ram0 bs=4k   #prefill brd so we don't get alloc deadlock
> >> >> mkfs.ext2 -b1024 /dev/ram0           #1K buffers
> >> >>
> >> >> Test is basically unmodified except I use 64MB files, and start 8 of them
> >> >> at once to (8 core system, so improve chances of hitting the bug). Although I
> >> >> do see it with only 1 running it takes longer to trigger.
> >> >>
> >> >> I also run a loop doing 'sync ; echo 3 > /proc/sys/vm/drop_caches' but I don't
> >> >> know if that really helps speed up reproducing it. It is quite random to hit,
> >> >> but I was able to hit it IIRC in under a minute with that setup.
> >> >>
> >> >
> >> > Here is how i reproduce it:
> >> > Filesystem is ext2 with blocksize 4096
> >> > Fill up the ram with 95% anon memory and mlockall ( put enough memory
> >> > pressure which will trigger page reclaim and background writeout)
> >> > Run one thread of the test program
> >> >
> >> > and i will see "bad pages" within few minutes.
> >>
> >> And here is the "top" and stdout while it is getting "bad pages"
> >> top
> >>
> >>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >>  3487 root      20   0 52616  50m  284 R   95  0.3   3:58.85 usemem
> >>  3810 root      20   0  129m  99m  99m D   41  0.6   0:01.87 ftruncate_mmap
> >>   261 root      15  -5     0    0    0 D    4  0.0   0:31.08 kswapd0
> >>   262 root      15  -5     0    0    0 D    3  0.0   0:10.26 kswapd1
> >>
> >> stdout:
> >>
> >> while true; do
> >>     ./ftruncate_mmap;
> >> done
> >> Running 852 bad page
> >> Running 315 bad page
> >> Running 999 bad page
> >> Running 482 bad page
> >> Running 24 bad page
> >  Thanks, for the help. I've debugged the problem to a bug in
> > ext2_get_block(). I've already sent out a patch which should fix the issue
> > (at least it fixes the problem for me).
> >  The fix is also attached if you want to try it.
> 
> hmm, now i do see that get_block() returns ENOSPC by printk the err.
> So did you applied the patch which redirty_page_for_writepage as well
> as this one together?
  No, my patch contained only a fix in ext2_get_block(). When you see
ENOSPC, that's a completely separate issue. You may apply that patch but
with ext2 it would be enough to make the file fit the ram disk. I.e. first
try with dd how big file fits there and then run your tester with at most
as big file so that you don't hit ENOSPC...

> I will start the test with kernel applied both patches and leave it for running.
  OK.

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
