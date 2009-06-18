Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZFREhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZFREhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 00:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZFREhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 00:37:41 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:10286 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZFREhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 00:37:40 -0400
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
	 <1245119977.6724.40.camel@lts-notebook>
	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
	 <1245164395.15138.40.camel@lts-notebook>
	 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
Content-Type: text/plain
Organization: HP/LKTT
Date: Thu, 18 Jun 2009 00:37:36 -0400
Message-Id: <1245299856.6431.30.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 09:45 +0200, Stefan Lankes wrote:
> > I've placed the last rebased version in :
> > 
> > http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.28-rc4-mmotm-
> > 081110/
> > 
> 
> OK! I will try to reconstruct the problem.

Stefan:

Today I rebased the migrate on fault patches to 2.6.30-mmotm-090612...
[along with my shared policy series atop which they sit in my tree].
Patches reside in:

http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.30-mmotm-090612-1220/


I did a quick test.  I'm afraid the patches have suffered some "bit rot"
vis a vis mainline/mmotm over the past several months.  Two possibly
related issues:

1) lazy migration doesn't seem to work. Looks like
mbind(<some-policy>+MPOL_MF_MOVE+MPOL_MF_LAZY) is not unmapping the
pages so, of course, migrate on fault won't work.  I suspect the
reference count handling has changed since I last tried this.  [Note one
of the patch conflicts was in the MPOL_MF_LAZY addition to the mbind
flag definitions in mempolicy.h and I may have botched the resolution
thereof.]

2) When the pages get freed on exit/unmap, they are still PageLocked()
and free_pages_check()/bad_page() bugs out with bad page state.

Note:  This is independent of memcg--i.e., happens whether or not memcg
configured.

To test this, I created a test cpuset with all nodes/mems/cpus and
enabled migrate_on_fault therein.  I then ran an interactive "memtoy"
session there [shown below].  Memtoy is a program I use for ad hoc
testing of various mm features.  You can find the latest version [almost
always] at:

http://free.linux.hp.com/~lts/Tools/memtoy-latest.tar.gz

You'll need the numactl-devel package to build--an older one with the V1
api, I think.  I need to upgrade it to latest libnuma.  

The same directory [Tools] contains a tarball of simple cpuset scripts
to make, query, modify, "enter" and run commands in cpusets.  There may
be other versions of such scripts around.  If you don't already have
any, feel free to grab them.

Since you've expressed interest in this [as has Kamezawa-san], I'll try
to pay some attention to debugging the patches in my copious spare time.
And, I'd be very interested in anything you discover in your
investigations.

Regards,
Lee

Memtoy-0.19c [for latest MPOL_MF flags defs]:

!!! lines are my annotations:

memtoy pid:  4222
memtoy>mems
mems allowed = 0-3
mems policy = 0-3
memtoy>cpus
cpu affinity mask/ids:  0-7
memtoy>anon a1 8p
memtoy>map a1
memtoy>mbind a1 pref 1
memtoy>touch a1 w
memtoy:  touched 8 pages in  0.000 secs
memtoy>where a1
a 0x00007f51ae757000 0x000000008000 0x000000000000  rw- default a1
page offset    +00 +01 +02 +03 +04 +05 +06 +07
           0:    1   1   1   1   1   1   1   1
memtoy>mbind a1 pref+move 2
memtoy:  migration of a1 [8 pages] took  0.000secs.

memtoy>where a1
a 0x00007f51ae757000 0x000000008000 0x000000000000  rw- default a1
page offset    +00 +01 +02 +03 +04 +05 +06 +07
           0:    2   2   2   2   2   2   2   2

!!! direct migration [still] works!  Try lazy:

memtoy>mbind a1 pref+move+lazy 3
memtoy:  unmap of a1 [8 pages] took  0.000secs.
memtoy>where a1

!!! "where" command uses get_mempolicy() w/ MPOL_ADDR|MPOL_NODE flags to
fetch page location.  Will call get_user_pages() and refault pages.
Should migrate to node 3, but:

a 0x00007f51ae757000 0x000000008000 0x000000000000  rw- default a1
page offset    +00 +01 +02 +03 +04 +05 +06 +07
           0:    2   2   2   2   2   2   2   2
!!! didn't move 
memtoy>exit


On console I see, for each of 8 pages of segment a1:

BUG: Bad page state in process memtoy  pfn:67515f
page:ffffea001699ccc8 flags:0a0000000010001d count:0 mapcount:0
mapping:(null) index:7f51ae75e
Pid: 4222, comm: memtoy Not tainted 2.6.30-mmotm-090612-1220+spol+lpm #6
Call Trace:
 [<ffffffff810a787a>] bad_page+0xaa/0x130
 [<ffffffff810a8719>] free_hot_cold_page+0x199/0x1d0
 [<ffffffff810a8774>] __pagevec_free+0x24/0x30
 [<ffffffff810ac96a>] release_pages+0x1ca/0x210
 [<ffffffff810c8b7d>] free_pages_and_swap_cache+0x8d/0xb0
 [<ffffffff810c0505>] exit_mmap+0x145/0x160
 [<ffffffff81044177>] mmput+0x47/0xa0
 [<ffffffff81048854>] exit_mm+0xf4/0x130
 [<ffffffff81049c58>] do_exit+0x188/0x810
 [<ffffffff81337194>] ? do_page_fault+0x184/0x310
 [<ffffffff8104a31e>] do_group_exit+0x3e/0xa0
 [<ffffffff8104a392>] sys_exit_group+0x12/0x20
 [<ffffffff8100bd2b>] system_call_fastpath+0x16/0x1b


Page flags 0x10001d:  locked, referenced, uptodate, dirty, swapbacked.
'locked' is bad state.


