Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZFVOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZFVOYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZFVOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:24:13 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:38659 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZFVOYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:24:12 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <4A3F7A49.6070805@inria.fr>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
	 <1245119977.6724.40.camel@lts-notebook>
	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
	 <1245164395.15138.40.camel@lts-notebook>
	 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
	 <1245299856.6431.30.camel@lts-notebook>  <4A3F7A49.6070805@inria.fr>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 22 Jun 2009 10:24:09 -0400
Message-Id: <1245680649.7799.54.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 14:34 +0200, Brice Goglin wrote:
> Lee Schermerhorn wrote:
> > On Wed, 2009-06-17 at 09:45 +0200, Stefan Lankes wrote:
> >   
> >>> I've placed the last rebased version in :
> >>>
> >>> http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.28-rc4-mmotm-
> >>> 081110/
> >>>
> >>>       
> >> OK! I will try to reconstruct the problem.
> >>     
> >
> > Stefan:
> >
> > Today I rebased the migrate on fault patches to 2.6.30-mmotm-090612...
> > [along with my shared policy series atop which they sit in my tree].
> > Patches reside in:
> >
> > http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.30-mmotm-090612-1220/
> >
> >   
> 
> I gave this patchset a try and indeed it seems to work fine, thanks a
> lot. But the migration performance isn't very good. I am seeing about
> 540MB/s when doing mbind+touch_all_pages on large buffers on a
> quad-barcelona machines. move_pages gets 640MB/s there. And my own
> next-touch implementation were near 800MB/s in the past.

Interesting.  Do you have any idea where the differences come from?  Are
you comparing them on the same kernel versions?  I don't know the
details of your implementation, but one possible area is the check for
"misplacement".  When migrate-on-fault is enabled, I check all pages
with page_mapcount() == 0 for misplacement in the [swap page] fault
path.  That, and other filtering to eliminate unnecessary migrations
could cause extra overhead.

Aside:  currently, my implementation could migrate a page, only to find
that it will be replaced by a new page due to copy-on-write.  I have on
my list to check write access and whether we can reuse the swap page and
avoid the migration if we're going to COW later anyway.  This could
improve performance for write accesses, if the snoop traffic doesn't
overshadow any such improvement.

> 
> I wonder if there is a more general migration performance degradation in
> latest Linus git. move_pages performance was supposed to increase by 15%
> (more than 700MB/s) thanks to commit dfa33d45 but I don't seem to see
> the improvement with git or mmotm. Also migrate_pages seems to have
> decreased but it might be older than 2.6.30. I need to find some time to
> git bisect all this, otherwise it's hard to compare the performance of
> your migrate-on-fault with other older implementations :)

Confession:  I've not measured migration performance directly.  Rather,
I've only observed how applications/benchmarks perform with
migrate-on-fault+automigration enabled.  On the platforms available to
me back when I was actively working on this, I did see improvements in
real and user time due to improved locality, especially under heavy load
when interconnect bandwidth is at a premium.  Of course, system time
increased because of the migration overheads.

> 
> When do you plan to actually submit all your patches for inclusion?

I had/have no immediate plans.  I held off on these series while other
mm features--reclaim scalability, memory control groups, ...--seemed
higher priority, and the churn in mm made it difficult to keep these
patches up to date.  Now that the patches seem to be working again, I
plan to test them on newer platforms with more "interesting" numa
topologies.  If they work well there, and with your interest and
cooperation, perhaps we can try again with some variant or combination
of our approaches.

Regards,
Lee

