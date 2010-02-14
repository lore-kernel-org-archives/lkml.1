Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0BNKw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:52:56 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37372 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0BNKwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:52:54 -0500
Date: Sun, 14 Feb 2010 16:22:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Chris Frost <frost@cs.ucla.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20100214105245.GA5612@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4B6B7FBF.9090005@bx.jp.nec.com>
 <20100205072858.GC9320@elte.hu>
 <20100208155450.GA17055@localhost>
 <20100209162101.GA12840@localhost>
 <20100213132952.GG11364@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100213132952.GG11364@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2010-02-13 18:59:52]:

> * Wu Fengguang <fengguang.wu@intel.com> [2010-02-10 00:21:01]:
> 
> > > Here is a scratch patch to exercise the "object collections" idea :)
> > > 
> > > Interestingly, the pagecache walk is pretty fast, while copying out the trace
> > > data takes more time:
> > > 
> > >         # time (echo / > walk-fs)
> > >         (; echo / > walk-fs; )  0.01s user 0.11s system 82% cpu 0.145 total
> > > 
> > >         # time wc /debug/tracing/trace
> > >         4570 45893 551282 /debug/tracing/trace
> > >         wc /debug/tracing/trace  0.75s user 0.55s system 88% cpu 1.470 total
> > 
> > Ah got it: it takes much time to "print" the raw trace data.
> > 
> > > TODO:
> > > 
> > > correctness
> > > - show file path name
> > >   XXX: can trace_seq_path() be called directly inside TRACE_EVENT()?
> > 
> > OK, finished with the file name with d_path(). I choose not to mangle
> > the possible '\n' in file names, and simply show "?" for such files,
> > for the sake of speed.
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
> > # echo /dev > /debug/tracing/objects/mm/pages/walk-fs
> > # tail /debug/tracing/trace
> >              zsh-2528  [000] 10429.172470: dump_inode: ino=889 size=0 cached=0 age=442 dirty=0 dev=0:18 file=/dev/console
> >              zsh-2528  [000] 10429.172472: dump_inode: ino=888 size=0 cached=0 age=442 dirty=7 dev=0:18 file=/dev/null
> >              zsh-2528  [000] 10429.172474: dump_inode: ino=887 size=40 cached=0 age=442 dirty=0 dev=0:18 file=/dev/shm
> >              zsh-2528  [000] 10429.172477: dump_inode: ino=886 size=40 cached=0 age=442 dirty=0 dev=0:18 file=/dev/pts
> >              zsh-2528  [000] 10429.172479: dump_inode: ino=885 size=11 cached=0 age=442 dirty=0 dev=0:18 file=/dev/core
> >              zsh-2528  [000] 10429.172481: dump_inode: ino=884 size=15 cached=0 age=442 dirty=0 dev=0:18 file=/dev/stderr
> >              zsh-2528  [000] 10429.172483: dump_inode: ino=883 size=15 cached=0 age=442 dirty=0 dev=0:18 file=/dev/stdout
> >              zsh-2528  [000] 10429.172486: dump_inode: ino=882 size=15 cached=0 age=442 dirty=0 dev=0:18 file=/dev/stdin
> >              zsh-2528  [000] 10429.172488: dump_inode: ino=881 size=13 cached=0 age=442 dirty=0 dev=0:18 file=/dev/fd
> >              zsh-2528  [000] 10429.172491: dump_inode: ino=872 size=13360 cached=0 age=442 dirty=0 dev=0:18 file=/dev
> > 
> > Here "age" is either age from inode create time, or from last dirty time.
> >
> 
> It would be nice to see mapped/unmapped information as well.
>

OK, I see you got mapcount, thanks!
 
-- 
	Three Cheers,
	Balbir
