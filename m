Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbZFVQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbZFVQzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZFVQz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:55:27 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1608 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZFVQz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:55:26 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <4A3FA326.8030802@inria.fr>
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
	 <1245680649.7799.54.camel@lts-notebook>  <4A3FA326.8030802@inria.fr>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 22 Jun 2009 12:55:24 -0400
Message-Id: <1245689724.7799.124.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 17:28 +0200, Brice Goglin wrote:
> Lee Schermerhorn wrote:
> >> I gave this patchset a try and indeed it seems to work fine, thanks a
> >> lot. But the migration performance isn't very good. I am seeing about
> >> 540MB/s when doing mbind+touch_all_pages on large buffers on a
> >> quad-barcelona machines. move_pages gets 640MB/s there. And my own
> >> next-touch implementation were near 800MB/s in the past.
> >>     
> >
> > Interesting.  Do you have any idea where the differences come from?  Are
> > you comparing them on the same kernel versions?  I don't know the
> > details of your implementation, but one possible area is the check for
> > "misplacement".  When migrate-on-fault is enabled, I check all pages
> > with page_mapcount() == 0 for misplacement in the [swap page] fault
> > path.  That, and other filtering to eliminate unnecessary migrations
> > could cause extra overhead.
> >   
> 
> (I'll actually talk about this at the Linux Symposium) I used 2.6.27
> initially, with some 2.6.29 patches to fix the throughput of move_pages
> for large buffers. So move_pages was getting about 600MB/s there. Then
> my own (hacky) next-touch implementation was getting about 800MB/s. The
> main difference with your code is that mine only modifies the current
> process PTE without touching the other processes if the page is shared.

The primary difference should be at unmap time, right?  In the fault
path, I only update the pte of the faulting task.  That's why I require
the [anon] pages to be in the swap cache [or something similar].  I
don't want to be fixing up other tasks' page tables in the context of
the faulting task's fault handler.  If, later, another task touches the
page, it will take a minor fault and find the [possibly migrated] page
in the cache.  Hmmm, I guess all tasks WILL incur the minor fault if
they touch the page after the unmap.  That could be part of the
difference if you compare on the same kernel version.

> So my code basically only supports private pages, it duplicates/migrates
> them on next-touch. I thought it was faster than move_pages because I
> didn't support shared-page migration. But, I found out later that
> move_pages could be further improved up to about 750MB/s (it will be in
> 2.6.31).
> 
> So now, I'd expect both the next-touch migration and move_pages to have
> similar migration throughput, about 750-800MB/s on my quad-barcelona
> machine. Right now, I'm seeing less than that for both, so there might
> be a problem deeper. 

Try booting with cgroup_disable=memory on the command line, if you have
the memory resource controller configured in.  See what that does to
your measurements.

> Actually, looking at COW performance when the new
> page is allocated on a remote numa node, I also see the throughput much
> lower in 2.6.29+ (about 720MB/s) than in 2.6.27 (about 850MB/s). Maybe a
> regression in the low-level page copy routine?

??? I would expect low level page copying to be highly optimized per
arch, and also fairly stable.  Based on recent experience, I'd more
likely suspect the mm housekeeping overheads--e.g., global and per memcg
lru management, ...  We seen a lot of new code in this area in the past
few releases.

Lee

