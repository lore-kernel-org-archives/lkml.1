Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZE0IGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZE0IGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZE0IGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:06:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55492 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbZE0IGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:06:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Subject: Re: [PATCH v3] zone_reclaim is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090525114135.GD29447@sgi.com>
References: <20090524214554.084F.A69D9226@jp.fujitsu.com> <20090525114135.GD29447@sgi.com>
Message-Id: <20090527164549.68B4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 May 2009 17:06:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, May 24, 2009 at 10:44:29PM +0900, KOSAKI Motohiro wrote:
> ...
> > > Your root cause analysis is suspect.  You found a knob to turn which
> > > suddenly improved performance for one specific un-tuned server workload.
> ...
> > The fact is, workload dependency charactetistics of zone reclaim is
> > widely known from very ago.
> > Even Documentaion/sysctl/vm.txt said, 
> > 
> > > It may be beneficial to switch off zone reclaim if the system is
> > > used for a file server and all of memory should be used for caching files
> > > from disk. In that case the caching effect is more important than
> > > data locality.
> > 
> > Nobody except you oppose this.
> 
> I don't disagree with that statement.  I agree this is a workload specific
> tuneable that for the case where you want to use the system for nothing
> other than file serving, you need to turn it off.  It has been this way
> for ages.  I am saying let's not change that default behavior.
> 
> > > How did you determine better by default?  I think we already established
> > > that apache is a server workload and not a desktop workload.  Earlier
> > > you were arguing that we need this turned off to improve the desktop
> > > environment.  You have not established this improves desktop performance.
> > > Actually, you have not established it improves apache performance or
> > > server performance.  You have documented it improves memory utilization,
> > > but that is not always the same as faster.
> > 
> > The fact is, low-end machine performace depend on cache hitting ratio widely.
> > improving memory utilization mean improving cache hitting ratio.
> > 
> > Plus, I already explained about desktop use case. multiple worst case scenario 
> > can happend on it easily.
> > 
> > if big process consume memory rather than node size, zone-reclaim
> > decrease performance largely.
> 
> It may improve performance as well.  I agree we can come up with
> theoretical cases that show both.  I am asking for documented cases where
> it does.  Your original post indicated an apache regression.  In that
> case apache was being used under server type loads.  If you have a machine
> with this condition, you should probably be considered the exception.
> 
> > zone reclaim decrease page-cache hitting ratio. some desktop don't have
> > much memory. cache missies does'nt only increase latency, but also
> > increase unnecessary I/O. desktop don't have rich I/O bandwidth rather than
> > server or hpc. it makes bad I/O affect.
> 
> If low I/O performance should be turning it off, then shouldn't that
> case be coded into the default as opposed to changing the default to
> match your specific opinion?
> 
> > However, your past explanation is really wrong and bogus.
> > I wrote
> > 
> > > If this imbalance is an x86_64 only problem, then we could do something
> > > simple like the following untested patch.  This leaves the default
> > > for everyone except x86_64.
> > 
> > and I wrote it isn't true. after that, you haven't provide addisional
> > explanation.
> 
> I don't recall seeing your response.  Sorry, but this has been, and will
> remain, low priority for me.  If the default gets changed, we will detect
> the performance regression very early after we start testing this bad
> of a change on a low memory machine and then we will put a tweak into
> place at the next distro release to turn this off following boot.
> 
> > Nobody ack CODE-ONLY-PATCH. _You_ have to explain _why_ you think 
> > your approach is better.
> 
> Because it doesn't throw out a lot of history based upon your opinion of
> one server type test found under lab conditions on a poorly tuned machine.

Robin, sorry, if this is all of your intention, I can't agree it. firstly,
poorly tuned machine is not wrong at all. valume zone server (low-end sever)
and deskrop people never change kernel parameter. default parameter shold
be optimal. because they are majority user. Yanmin did test proper condition.
secondly, a lot history is not good enough reason in this case. in past days,
larger distance remote node machine is verrrrrrrrrrry few. it was very expensive.
but Core i7 is cheap. There are Ci7 user much x1000 times than high-end
hpc machine user.

your last patch is one of considerable thing. but it has one weakness.
in general "ifdef x86" is wrong idea. almost minor architecture don't
have sufficient tester. the difference against x86 often makes bug.
Then, unnecessary difference is hated by much people.

So, I think we have two selectable choice.

1. remove zone_reclaim default setting completely (this patch)
2. Only PowerPC and IA64 have default zone_reclaim_mode settings,
   other architecture always use zone_reclaim_mode=0.

it mean larger distance remote node machine are only in ia64 and power
as a matter of practice. (nobody sale high-end linux on parisc nor sparc)

Changing "as a matter of practice" to "formally" is not caused your worried
risk.



Here is your turn. comments?


