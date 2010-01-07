Return-Path: <linux-kernel-owner+w=401wt.eu-S932457Ab0AGIes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab0AGIes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677Ab0AGIer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:34:47 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:32947 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab0AGIeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:34:46 -0500
Date: Thu, 7 Jan 2010 14:04:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-ID: <20100107083440.GS3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 16:36:10]:

> On Thu, 7 Jan 2010 12:45:54 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 16:12:11]:
> > > And piles up costs ? I think cgroup guys should pay attention to fork/exit
> > > costs more. Now, it gets slower and slower.
> > > In that point, I never like migrate-at-task-move work in cpuset and memcg.
> > > 
> > > My 1st objection to this patch is this "shared" doesn't mean "shared between
> > > cgroup" but means "shared between processes".
> > > I think it's of no use and no help to users.
> > >
> > 
> > So what in your opinion would help end users? My concern is that as
> > we make progress with memcg, we account only for privately used pages
> > with no hint/data about the real usage (shared within or with other
> > cgroups). 
> 
> The real usage is already shown as
> 
>   [root@bluextal ref-mmotm]# cat /cgroups/memory.stat
>   cache 7706181632 
>   rss 120905728
>   mapped_file 32239616
> 
> This is real. And "sum of rss - rss+mapped" doesn't show anything.
> 
> > How do we decide if one cgroup is really heavy?
> >  
> 
> What "heavy" means ? "Hard to page out ?"
>

Heavy can also indicate, should we OOM kill in this cgroup or kill the
entire cgroup? Should we add or remove resources from this cgroup?
 
> Historically, it's caught by pagein/pageout _speed_.
> "How heavy memory system is ?" can only be measured by "speed".

Not really... A cgroup might be very large with a large number of its
pages shared and frequently used. How do we detect if this cgroup
needs its resources or its taking too many of them.

> If you add latency-stat for memcg, I'm glad to use it.
> 
> Anyway, "How memory reclaim can go successfully" is generic problem rather
> than memcg. Maybe no good answers from VM guys....
> I think you should add codes to global VM rather than cgroup.
> 

No.. this is not for reclaim

> "How pages are shared" doesn't show good hints. I don't hear such parameter
> is used in production's resource monitoring software.
> 

You mean "How many pages are shared" are not good hints, please see my
justification above. With Virtualization (look at KSM for example),
shared pages are going to be increasingly important part of the
accounting.

> 
> > > And implementation is 2nd thing.
> > > 
> > 
> > More details on your concern, please!
> > 
> I already wrote....why do you want to make fork()/exit() slow for a thing
> which is not necessary to be done in atomic ?
> 

So your concern is about iterating through the tasks in cgroup, I can
think of an alternative low cost implementation if possible

> There are many hosts which has thousands of process and a cgrop may contain
> thousands of process in production server.
> In that situation, How the "make kernel" can slow down with following ?
> ==
> while true; do cat /cgroup/memory.shared > /dev/null; done
> ==

This is the worst case usage scenario that would be effected even if
memory.shared were replaced by tasks.

> 
> In a word, the implementation problem is
>  - An operation against a container can cause generic system slow down.
> Then, I don't like heavy task move under cgroup.
> 
> 
> Yes, this can happen in other places (we have to do some improvements).
> But this is not good for a concept of isolation by container, anyway.

Thanks for the review!

-- 
	Balbir
