Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZFSQAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZFSQAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZFSP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:59:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:24192 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZFSP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:59:54 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: balbir@linux.vnet.ibm.com
Cc: Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20090619154114.GE8648@balbir.in.ibm.com>
References: <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
	 <1245119977.6724.40.camel@lts-notebook>
	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
	 <1245164395.15138.40.camel@lts-notebook>
	 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
	 <1245299856.6431.30.camel@lts-notebook>
	 <1245351882.1025.84.camel@lts-notebook>
	 <1245425214.30101.32.camel@lts-notebook>
	 <20090619154114.GE8648@balbir.in.ibm.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 19 Jun 2009 11:59:51 -0400
Message-Id: <1245427191.30101.37.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 21:11 +0530, Balbir Singh wrote:
> * Lee Schermerhorn <Lee.Schermerhorn@hp.com> [2009-06-19 11:26:53]:
> 
> > On Thu, 2009-06-18 at 15:04 -0400, Lee Schermerhorn wrote:
> > > On Thu, 2009-06-18 at 00:37 -0400, Lee Schermerhorn wrote:
> > > > On Wed, 2009-06-17 at 09:45 +0200, Stefan Lankes wrote:
> > > > > > I've placed the last rebased version in :
> > > > > > 
> > > > > > http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.28-rc4-mmotm-
> > > > > > 081110/
> > > > > > 
> > > > > 
> > > > > OK! I will try to reconstruct the problem.
> > > > 
> > > > Stefan:
> > > > 
> > > > Today I rebased the migrate on fault patches to 2.6.30-mmotm-090612...
> > > > [along with my shared policy series atop which they sit in my tree].
> > > > Patches reside in:
> > > > 
> > > > http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.30-mmotm-090612-1220/
> > > > 
> > > 
> > > I have updated the migrate-on-fault tarball in the above location to fix
> > > part of the problems I was seeing.  See below.
> > > 
> > > > 
> > > > I did a quick test.  I'm afraid the patches have suffered some "bit rot"
> > > > vis a vis mainline/mmotm over the past several months.  Two possibly
> > > > related issues:
> > > > 
> > > > 1) lazy migration doesn't seem to work. Looks like
> > > > mbind(<some-policy>+MPOL_MF_MOVE+MPOL_MF_LAZY) is not unmapping the
> > > > pages so, of course, migrate on fault won't work.  I suspect the
> > > > reference count handling has changed since I last tried this.  [Note one
> > > > of the patch conflicts was in the MPOL_MF_LAZY addition to the mbind
> > > > flag definitions in mempolicy.h and I may have botched the resolution
> > > > thereof.]
> > > > 
> > > > 2) When the pages get freed on exit/unmap, they are still PageLocked()
> > > > and free_pages_check()/bad_page() bugs out with bad page state.
> > > > 
> > > > Note:  This is independent of memcg--i.e., happens whether or not memcg
> > > > configured.
> > > > 
> > > <snip>
> > > 
> > > OK.  Found time to look at this.  Turns out I hadn't tested since
> > > trylock_page() was introduced.  I did a one-for-one replacement of the
> > > old API [TestSetPageLocked()], not noticing that the sense of the return
> > > was inverted.  Thus, I was bailing out of the migrate_pages_unmap_only()
> > > loop with the page locked, thinking someone else had locked it and would
> > > take care of it.  Since the page wasn't unmapped from the page table[s],
> > > of course it wouldn't migrate on fault--wouldn't even fault!
> > > 
> > > Fixed this.
> > > 
> > > Now:  lazy migration works w/ or w/o memcg configured, but NOT with the
> > > swap resource controller configured.  I'll look at that as time permits.
> > 
> > Update:  I now can't reproduce the lazy migration failure with the swap
> > resource controller configured.  Perhaps I had booted the wrong kernel
> > for the test reported above.  Now the updated patch series mentioned
> > above seems to be working with both memory and swap resource controllers
> > configured for simple memtoy driven lazy migration.
> 
> Excellent, I presume that you are using the latest mmotm or mainline.
> We've had some swap cache leakage fix go in, but those are not as
> serious (they can potentially cause OOM in a cgroup when the leak
> occurs).

Yes, I'm using the 12jun mmotm atop 2.6.30.   I use the mmotm timestamp
in my kernel versions to show the base I using.  E.g., see the url
above.

Lee

