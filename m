Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141Ab0AGHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0AGHj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459Ab0AGHjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:39:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51721 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0AGHjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:39:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 16:36:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107071554.GO3059@balbir.in.ibm.com>
References: <20091229182743.GB12533@balbir.in.ibm.com>
	<20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104000752.GC16187@balbir.in.ibm.com>
	<20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104005030.GG16187@balbir.in.ibm.com>
	<20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106070150.GL3059@balbir.in.ibm.com>
	<20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107071554.GO3059@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 12:45:54 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 16:12:11]:
> > And piles up costs ? I think cgroup guys should pay attention to fork/exit
> > costs more. Now, it gets slower and slower.
> > In that point, I never like migrate-at-task-move work in cpuset and memcg.
> > 
> > My 1st objection to this patch is this "shared" doesn't mean "shared between
> > cgroup" but means "shared between processes".
> > I think it's of no use and no help to users.
> >
> 
> So what in your opinion would help end users? My concern is that as
> we make progress with memcg, we account only for privately used pages
> with no hint/data about the real usage (shared within or with other
> cgroups). 

The real usage is already shown as

  [root@bluextal ref-mmotm]# cat /cgroups/memory.stat
  cache 7706181632 
  rss 120905728
  mapped_file 32239616

This is real. And "sum of rss - rss+mapped" doesn't show anything.

> How do we decide if one cgroup is really heavy?
>  

What "heavy" means ? "Hard to page out ?"

Historically, it's caught by pagein/pageout _speed_.
"How heavy memory system is ?" can only be measured by "speed".
If you add latency-stat for memcg, I'm glad to use it.

Anyway, "How memory reclaim can go successfully" is generic problem rather
than memcg. Maybe no good answers from VM guys....
I think you should add codes to global VM rather than cgroup.

"How pages are shared" doesn't show good hints. I don't hear such parameter
is used in production's resource monitoring software.


> > And implementation is 2nd thing.
> > 
> 
> More details on your concern, please!
> 
I already wrote....why do you want to make fork()/exit() slow for a thing
which is not necessary to be done in atomic ?

There are many hosts which has thousands of process and a cgrop may contain
thousands of process in production server.
In that situation, How the "make kernel" can slow down with following ?
==
while true; do cat /cgroup/memory.shared > /dev/null; done
==

In a word, the implementation problem is
 - An operation against a container can cause generic system slow down.
Then, I don't like heavy task move under cgroup.


Yes, this can happen in other places (we have to do some improvements).
But this is not good for a concept of isolation by container, anyway.

Thanks,
-Kame


