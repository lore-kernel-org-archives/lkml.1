Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235Ab0AGIvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0AGIvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683Ab0AGIvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:51:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55367 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0AGIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:51:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 17:48:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107083440.GS3059@balbir.in.ibm.com>
References: <20091229182743.GB12533@balbir.in.ibm.com>
	<20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104000752.GC16187@balbir.in.ibm.com>
	<20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104005030.GG16187@balbir.in.ibm.com>
	<20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106070150.GL3059@balbir.in.ibm.com>
	<20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107071554.GO3059@balbir.in.ibm.com>
	<20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107083440.GS3059@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 14:04:40 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 16:36:10]:
> 
> > On Thu, 7 Jan 2010 12:45:54 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 16:12:11]:
> > > > And piles up costs ? I think cgroup guys should pay attention to fork/exit
> > > > costs more. Now, it gets slower and slower.
> > > > In that point, I never like migrate-at-task-move work in cpuset and memcg.
> > > > 
> > > > My 1st objection to this patch is this "shared" doesn't mean "shared between
> > > > cgroup" but means "shared between processes".
> > > > I think it's of no use and no help to users.
> > > >
> > > 
> > > So what in your opinion would help end users? My concern is that as
> > > we make progress with memcg, we account only for privately used pages
> > > with no hint/data about the real usage (shared within or with other
> > > cgroups). 
> > 
> > The real usage is already shown as
> > 
> >   [root@bluextal ref-mmotm]# cat /cgroups/memory.stat
> >   cache 7706181632 
> >   rss 120905728
> >   mapped_file 32239616
> > 
> > This is real. And "sum of rss - rss+mapped" doesn't show anything.
> > 
> > > How do we decide if one cgroup is really heavy?
> > >  
> > 
> > What "heavy" means ? "Hard to page out ?"
> >
> 
> Heavy can also indicate, should we OOM kill in this cgroup or kill the
> entire cgroup? Should we add or remove resources from this cgroup?
> 
That's can be shown by usage...

 
> > Historically, it's caught by pagein/pageout _speed_.
> > "How heavy memory system is ?" can only be measured by "speed".
> 
> Not really... A cgroup might be very large with a large number of its
> pages shared and frequently used. How do we detect if this cgroup
> needs its resources or its taking too many of them.
> 
I don't know. If we have good parameter to know "resource is in short" 
in the kernel, please add to global VM before memcg.
as "/dev/mem_notify" proposed in the past. memcg will use similar logic
which is guaranteed by VM guys.


> > "How pages are shared" doesn't show good hints. I don't hear such parameter
> > is used in production's resource monitoring software.
> > 
> 
> You mean "How many pages are shared" are not good hints, please see my
> justification above. With Virtualization (look at KSM for example),
> shared pages are going to be increasingly important part of the
> accounting.
> 

Considering KSM, your cuounting style is tooo bad.

You should add 

 - MEM_CGROUP_STAT_SHARED_BY_KSM
 - MEM_CGROUP_STAT_FOR_TMPFS/SYSV_IPC_SHMEM

counters to memcg rather than scanning. I can help tests.

I have no objections to have above 2 counters. It's informative.

But, memory reclaim can page-out pages even if pages are shared.
So, "how heavy memcg is" is an independent problem from above coutners.

Thanks,
-Kame



