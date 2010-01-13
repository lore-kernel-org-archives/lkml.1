Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327Ab0AMKJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0AMKJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227Ab0AMKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:09:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42967 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0AMKJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:09:49 -0500
Date: Wed, 13 Jan 2010 11:09:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 0/5] lockdep: Add information of file and line to
 lockdep_map
Message-ID: <20100113100926.GB11386@elte.hu>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
 <1262860795-5745-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1263376323.4244.204.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263376323.4244.204.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-01-07 at 19:39 +0900, Hitoshi Mitake wrote:
> > There are a lot of lock instances with same names (e.g. port_lock).
> > This patch series add __FILE__ and __LINE__ to lockdep_map,
> > and these will be used for trace lock events.
> > 
> > Example use from perf lock map:
> > 
> > | 0xffffea0004c992b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> > | 0xffffea0004b112b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> > | 0xffffea0004a3f2b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> > | 0xffffea0004cd5228: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> > | 0xffff8800b91e2b28: &sb->s_type->i_lock_key (src: fs/inode.c, line: 166)
> > | 0xffff8800bb9d7ae0: key (src: kernel/wait.c, line: 16)
> > | 0xffff8800aa07dae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> > | 0xffff8800b07fbae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> > | 0xffff8800b07f3ae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> > | 0xffff8800bf15fae0: &sighand->siglock (src: kernel/fork.c, line: 1490)
> > | 0xffff8800b90f7ae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> > | ...
> > 
> > (This output of perf lock map is produced by my local version,
> >  I'll send this later.)
> > 
> > And sadly, as Peter Zijlstra predicted, this produces certain overhead.
> > 
> > Before appling this series:
> > | % sudo ./perf lock rec perf bench sched messaging
> > | # Running sched/messaging benchmark...
> > | # 20 sender and receiver processes per group
> > | # 10 groups == 400 processes run
> > |
> > |      Total time: 3.834 [sec]
> > After:
> >  sudo ./perf lock rec perf bench sched messaging
> > | # Running sched/messaging benchmark...
> > | # 20 sender and receiver processes per group
> > | # 10 groups == 400 processes run
> > |
> > |      Total time: 5.415 [sec]
> > | [ perf record: Woken up 0 times to write data ]
> > | [ perf record: Captured and wrote 53.512 MB perf.data (~2337993 samples) ]
> > 
> > But raw exec of perf bench sched messaging is this:
> > | % perf bench sched messaging
> > | # Running sched/messaging benchmark...
> > | # 20 sender and receiver processes per group
> > | # 10 groups == 400 processes run
> > |
> > |      Total time: 0.498 [sec]
> > 
> > Tracing lock events already produces amount of overhead.
> > I think the overhead produced by this series is not a fatal problem,
> > radically optimization is required... 
> 
> Right, these patches look OK, for the tracing overhead, you could possibly 
> hash the file:line into a u64 and reduce the tracepoint size, that should 
> improve the situation I tihnk, because I seem to remember the only thing 
> that really matters for speed is the size of things.

ok, great. I looked into merging these bits into perf/lock and perf/lock into 
tip:master - but the recent upstream raw-spinlock changes interact with the 
new patches.

I also merged latest perf into perf/lock and there's some new build failures:

builtin-lock.c:14:27: error: util/data_map.h: No such file or directory
cc1: warnings being treated as errors
builtin-lock.c: In function 'process_sample_event':
builtin-lock.c:279: error: implicit declaration of function 'threads__findnew'
builtin-lock.c:279: error: nested extern declaration of 'threads__findnew'
builtin-lock.c:279: error: assignment makes pointer from integer without a cast
builtin-lock.c: At top level:
builtin-lock.c:357: error: variable 'file_handler' has initializer but incomplete type
builtin-lock.c:358: error: unknown field 'process_sample_event' specified in initializer
builtin-lock.c:358: error: excess elements in struct initializer
builtin-lock.c:358: error: (near initialization for 'file_handler')
builtin-lock.c:359: error: unknown field 'sample_type_check' specified in initializer
builtin-lock.c:359: error: excess elements in struct initializer
builtin-lock.c:359: error: (near initialization for 'file_handler')
builtin-lock.c: In function 'read_events':
builtin-lock.c:364: error: implicit declaration of function 'register_idle_thread'
builtin-lock.c:364: error: nested extern declaration of 'register_idle_thread'
builtin-lock.c:365: error: implicit declaration of function 'register_perf_file_handler'
builtin-lock.c:365: error: nested extern declaration of 'register_perf_file_handler'
builtin-lock.c:367: error: implicit declaration of function 'mmap_dispatch_perf_file'
builtin-lock.c:367: error: nested extern declaration of 'mmap_dispatch_perf_file'
builtin-lock.c:368: error: 'event__cwdlen' undeclared (first use in this function)
builtin-lock.c:368: error: (Each undeclared identifier is reported only once
builtin-lock.c:368: error: for each function it appears in.)
builtin-lock.c:368: error: 'event__cwd' undeclared (first use in this function)
builtin-lock.c: In function 'cmd_lock':
builtin-lock.c:429: error: too many arguments to function 'symbol__init'
make: *** [builtin-lock.o] Error 1
make: *** Waiting for unfinished jobs....

once those are resolved and we have the merged in patches we can graduate this 
topic into tip:master.

Thanks,

	Ingo
