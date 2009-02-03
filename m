Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZBCVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZBCVu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZBCVuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:50:13 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25216 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZBCVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:50:10 -0500
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
In-Reply-To: <Pine.LNX.4.64.0902031659070.5131@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
	 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
	 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>
	 <20090130055639.GA30950@suse.de>
	 <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
	 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>
	 <1233345190.908.36.camel@lts-notebook>
	 <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
	 <1233351412.908.69.camel@lts-notebook>
	 <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
	 <1233677610.15321.129.camel@lts-notebook>
	 <Pine.LNX.4.64.0902031659070.5131@blonde.anvils>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 03 Feb 2009 16:50:24 -0500
Message-Id: <1233697824.15321.231.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 17:10 +0000, Hugh Dickins wrote:
> On Tue, 3 Feb 2009, Lee Schermerhorn wrote:
> > On Sat, 2009-01-31 at 12:35 +0000, Hugh Dickins wrote:
> > > We need a way to communicate not-MAP_NORESERVE to shmem.c, and we don't
> > > just need it in the explicit shmem_zero_setup() case, we also need it
> > > for the (probably rare nowadays) case when mmap() is working on file
> >           ^^^^^^^^^^^^^^^^^^^^^^^^
> > > /dev/zero (drivers/char/mem.c mmap_zero()), rather than using MAP_ANON.
> > 
> > 
> > This reminded me of something I'd seen recently looking
> > at /proc/<pid>/[numa]_maps for <a large commercial database> on
> > Linux/x86_64: 
> >...
> > 2adadf711000-2adadf721000 rwxp 00000000 00:0e 4072                       /dev/zero
> > 2adadf721000-2adadf731000 rwxp 00000000 00:0e 4072                       /dev/zero
> > 2adadf731000-2adadf741000 rwxp 00000000 00:0e 4072                       /dev/zero
> > 
> > <and so on, for another 90 lines until>
> > 
> > 7fffcdd36000-7fffcdd4e000 rwxp 7fffcdd36000 00:00 0                      [stack]
> > ffffffffff600000-ffffffffffe00000 ---p 00000000 00:00 0                  [vdso]
> > 
> > For portability between Linux and various Unix-like systems that don't
> > support MAP_ANON*, perhaps?
> > 
> > Anyway, from the addresses and permissions, these all look potentially
> > mergeable.  The offset is preventing merging, right?  I guess that's one
> > of the downsides of mapping /dev/zero rather than using MAP_ANONYMOUS?
> > 
> > Makes one wonder whether it would be worthwhile [not to mention
> > possible] to rework mmap_zero() to mimic MAP_ANONYMOUS...
> 
> That's certainly an interesting observation, and thank you for sharing
> it with us (hmm, I sound like a self-help group leader or something).
> 
> I don't really have anything to add to what Linus said (and hadn't
> got around to realizing the significance of the "p" there before I
> saw his reply).
> 
> Mmm, it's interesting, but I fear to add more hacks in there just
> for this - I guess we could, but I'd rather not, unless it becomes
> a serious issue.
> 
> Let's just tuck away the knowledge of this case for now.

Right.   And a bit more info to tuck away...

I routinely grab the proc maps and numa_maps from our largish servers
running various "industry standard benchmarks".  Prompted by Linus'
comment that "if it's just a hundred segments, nobody really cares", I
went back and looked a bit further at the maps for a recent run.  

Below are some segment counts for the run.  The benchmark involved 32
"instances" of the application--a technique used to reduce contention on
application internal resources as the user count increases--along with
it's data base task[s].  Each instance spawns a few processes [5-6
average, up to ~14, for this run] that share a few instance-specific
SYSV segments between them.

In each instance, one of those shmem segments exhibits a similar pattern
to the /dev/zero segments from the prior mail.  Many, altho' not all, of
the individual vmas are adjacent with the same permissions:  'r--s'.
E.g., a small snippet:

2ac0e3cf0000-2ac0e40f5000 r--s 00d26000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e40f5000-2ac0e4101000 r--s 0112b000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e4101000-2ac0e4102000 r--s 01137000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e4102000-2ac0e4113000 r--s 01138000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e4113000-2ac0e4114000 r--s 01149000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e4114000-2ac0e4115000 r--s 0114a000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e4115000-2ac0e4116000 r--s 0114b000 00:08 15695938                   /SYSV0000277a (deleted)
2ac0e4116000-2ac0e4117000 r--s 0114c000 00:08 15695938                   /SYSV0000277a (deleted)

I counted 2000-3600+ of these for a couple of tasks.  How they got like
this--one vma per page?--I'm not sure.  Perhaps a sequence of mprotect()
calls or such after attaching the segment.  [I'll try to get an strace
sometime.] Then I counted the occurrences of the patterns:
'^2.*r--s.*/SYSV' in each of the instances as, again, each instance uses
a different shmem segment among its tasks.  For good measure, I counted
the '/dev/zero' segments as well:

              SYSV shm    /dev/zero
instance 00        5771    217
instance 01        6025    183
instance 02        5738    176
instance 03        5798    177
instance 04        5709    182
instance 05        5423    915
instance 06        5513    929
instance 07        5915    180
instance 08        5802    182
instance 09        5690    177
instance 10        5643    177
instance 11        5647    180
instance 12        5656    182
instance 13        5672    181
instance 14        5522    180
instance 15        5497    180
instance 16        5594    179
instance 17        4922    906
instance 18        6956    935
instance 19        5769    181
instance 20        5771    180
instance 21        5712    180
instance 22        5711    184
instance 23        5631    179
instance 24        5586    180
instance 25        5640    180
instance 26        5614    176
instance 27        5523    176
instance 28        5600    179
instance 29        5473    177
instance 30        5581    180
instance 31        5470    180

A total of ~ 180K shmem segments, not counting the /dev/zero mappings.
Good thing we have a lot of memory :).  A couple of those segments per
instance are different shmem segments--just 2 or 3 out of 5k-6k in the
cases that I looked at.

The benchmark seems to run fairly well, so I'm not saying we have a
problem here--with the Linux kernel, anyway.  Just some raw data from a
pseudo-real-world application load.  ['pseudo' because I'm told no real
user would ever set up the app quite this way :)]

Also, this is on a vintage 2.6.16+ kernel [not my choice].  Soon I'll
have data from a much more recent release.

Lee




