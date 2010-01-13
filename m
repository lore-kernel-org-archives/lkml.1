Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314Ab0AMJwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0AMJwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779Ab0AMJwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:52:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:41744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0AMJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:52:21 -0500
Subject: Re: [PATCH 0/5] lockdep: Add information of file and line to
 lockdep_map
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1262860795-5745-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
	 <1262860795-5745-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 10:52:03 +0100
Message-ID: <1263376323.4244.204.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 19:39 +0900, Hitoshi Mitake wrote:
> There are a lot of lock instances with same names (e.g. port_lock).
> This patch series add __FILE__ and __LINE__ to lockdep_map,
> and these will be used for trace lock events.
> 
> Example use from perf lock map:
> 
> | 0xffffea0004c992b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> | 0xffffea0004b112b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> | 0xffffea0004a3f2b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> | 0xffffea0004cd5228: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
> | 0xffff8800b91e2b28: &sb->s_type->i_lock_key (src: fs/inode.c, line: 166)
> | 0xffff8800bb9d7ae0: key (src: kernel/wait.c, line: 16)
> | 0xffff8800aa07dae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> | 0xffff8800b07fbae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> | 0xffff8800b07f3ae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> | 0xffff8800bf15fae0: &sighand->siglock (src: kernel/fork.c, line: 1490)
> | 0xffff8800b90f7ae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
> | ...
> 
> (This output of perf lock map is produced by my local version,
>  I'll send this later.)
> 
> And sadly, as Peter Zijlstra predicted, this produces certain overhead.
> 
> Before appling this series:
> | % sudo ./perf lock rec perf bench sched messaging
> | # Running sched/messaging benchmark...
> | # 20 sender and receiver processes per group
> | # 10 groups == 400 processes run
> |
> |      Total time: 3.834 [sec]
> After:
>  sudo ./perf lock rec perf bench sched messaging
> | # Running sched/messaging benchmark...
> | # 20 sender and receiver processes per group
> | # 10 groups == 400 processes run
> |
> |      Total time: 5.415 [sec]
> | [ perf record: Woken up 0 times to write data ]
> | [ perf record: Captured and wrote 53.512 MB perf.data (~2337993 samples) ]
> 
> But raw exec of perf bench sched messaging is this:
> | % perf bench sched messaging
> | # Running sched/messaging benchmark...
> | # 20 sender and receiver processes per group
> | # 10 groups == 400 processes run
> |
> |      Total time: 0.498 [sec]
> 
> Tracing lock events already produces amount of overhead.
> I think the overhead produced by this series is not a fatal problem,
> radically optimization is required... 

Right, these patches look OK, for the tracing overhead, you could
possibly hash the file:line into a u64 and reduce the tracepoint size,
that should improve the situation I tihnk, because I seem to remember
the only thing that really matters for speed is the size of things.

