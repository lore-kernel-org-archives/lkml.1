Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0BRJ7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:59:06 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50614 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0BRJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:59:01 -0500
Date: Thu, 18 Feb 2010 15:28:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Frost <frost@cs.ucla.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lwoodman@redhat.com" <lwoodman@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
       Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: Re: [RFC PATCH -tip 0/2 v3] pagecache tracepoints proposal
Message-ID: <20100218095850.GR5612@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4B6B7FBF.9090005@bx.jp.nec.com>
 <20100205072858.GC9320@elte.hu>
 <20100208155450.GA17055@localhost>
 <20100218143429.ddea9bb2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100218143429.ddea9bb2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-02-18 14:34:29]:

> On Mon, 8 Feb 2010 23:54:50 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Hi Ingo,
> > 
> > > Note that there's also these older experimental commits in tip:tracing/mm 
> > > that introduce the notion of 'object collections' and adds the ability to 
> > > trace them:
> > > 
> > > 3383e37: tracing, page-allocator: Add a postprocessing script for page-allocator-related ftrace events
> > > c33b359: tracing, page-allocator: Add trace event for page traffic related to the buddy lists
> > > 0d524fb: tracing, mm: Add trace events for anti-fragmentation falling back to other migratetypes
> > > b9a2817: tracing, page-allocator: Add trace events for page allocation and page freeing
> > > 08b6cb8: perf_counter tools: Provide default bfd_demangle() function in case it's not around
> > > eb46710: tracing/mm: rename 'trigger' file to 'dump_range'
> > > 1487a7a: tracing/mm: fix mapcount trace record field
> > > dcac8cd: tracing/mm: add page frame snapshot trace
> > > 
> > > this concept, if refreshed a bit and extended to the page cache, would allow 
> > > the recording/snapshotting of the MM state of all currently present pages in 
> > > the page-cache - a possibly nice addition to the dynamic technique you apply 
> > > in your patches.
> > > 
> > > there's similar "object collections" work underway for 'perf lock' btw., by 
> > > Hitoshi Mitake and Frederic.
> > > 
> > > So there's lots of common ground and lots of interest.
> > 
> > Here is a scratch patch to exercise the "object collections" idea :)
> > 
> > Interestingly, the pagecache walk is pretty fast, while copying out the trace
> > data takes more time:
> > 
> >         # time (echo / > walk-fs)
> >         (; echo / > walk-fs; )  0.01s user 0.11s system 82% cpu 0.145 total
> > 
> >         # time wc /debug/tracing/trace
> >         4570 45893 551282 /debug/tracing/trace
> >         wc /debug/tracing/trace  0.75s user 0.55s system 88% cpu 1.470 total
> > 
> >         # time (cat /debug/tracing/trace > /dev/shm/t)
> >         (; cat /debug/tracing/trace > /dev/shm/t; )  0.04s user 0.49s system 95% cpu 0.548 total
> > 
> >         # time (dd if=/debug/tracing/trace of=/dev/shm/t bs=1M)
> >         0+138 records in
> >         0+138 records out
> >         551282 bytes (551 kB) copied, 0.380454 s, 1.4 MB/s
> >         (; dd if=/debug/tracing/trace of=/dev/shm/t bs=1M; )  0.09s user 0.48s system 96% cpu 0.600 total
> > 
> > The patch is based on tip/tracing/mm. 
> > 
> > Thanks,
> > Fengguang
> > ---
> > tracing: pagecache object collections
> > 
> > This dumps
> > - all cached files of a mounted fs  (the inode-cache)
> > - all cached pages of a cached file (the page-cache)
> > 
> > Usage and Sample output:
> > 
> > # echo / > /debug/tracing/objects/mm/pages/walk-fs
> > # head /debug/tracing/trace
> > 
> > # tracer: nop
> > #
> > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > #              | |       |          |         |
> >              zsh-3078  [000]   526.272587: dump_inode: ino=102223 size=169291 cached=172032 age=9 dirty=6 dev=0:15 file=<TODO>
> >              zsh-3078  [000]   526.274260: dump_pagecache_range: index=0 len=41 flags=10000000000002c count=1 mapcount=0
> >              zsh-3078  [000]   526.274340: dump_pagecache_range: index=41 len=1 flags=10000000000006c count=1 mapcount=0
> >              zsh-3078  [000]   526.274401: dump_inode: ino=8966 size=442 cached=4096 age=49 dirty=0 dev=0:15 file=<TODO>
> >              zsh-3078  [000]   526.274425: dump_pagecache_range: index=0 len=1 flags=10000000000002c count=1 mapcount=0
> >              zsh-3078  [000]   526.274440: dump_inode: ino=8964 size=4096 cached=0 age=49 dirty=0 dev=0:15 file=<TODO>
> > 
> > Here "age" is either age from inode create time, or from last dirty time.
> > 
> > TODO:
> > 
> > correctness
> > - show file path name
> >   XXX: can trace_seq_path() be called directly inside TRACE_EVENT()?
> > - reliably prevent ring buffer overflow,
> >   by replacing cond_resched() with some wait function
> >   (eg. wait until 2+ pages are free in ring buffer)
> > - use stable_page_flags() in recent kernel
> > 
> > output style
> > - use plain tracing output format (no fancy TASK-PID/.../FUNCTION fields)
> > - clear ring buffer before dumping the objects?
> > - output format: key=value pairs ==> header + tabbed values?
> > - add filtering options if necessary
> > 
> 
> Can we dump page's cgroup ? If so, I'm happy.
> Maybe
> ==
>   struct page_cgroup *pc = lookup_page_cgroup(page);
>   struct mem_cgroup *mem = pc->mem_cgroup;
>   shodt mem_cgroup_id = mem->css.css_id;
> 
>   And statistics can be counted per css_id.
>

Good idea, all of this needs to happen with a check to see if memcg is
enabled/disabled at boot as well. pc can be NULL if
CONFIG_CGROUP_MEM_RES_CTLR is not enabled.
 
> And then, some output like
> 
> dump_pagecache_range: index=0 len=1 flags=10000000000002c count=1 mapcount=0 file=XXX memcg=group_A:x,group_B:y
> 
> Is it okay to add a new field after your work finish ?
> 
-- 
	Three Cheers,
	Balbir
