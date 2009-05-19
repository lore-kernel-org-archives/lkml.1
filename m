Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZESVRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZESVRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZESVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:17:13 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:47828 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbZESVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:17:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFADm6EkpMQW1W/2dsb2JhbACBT85NhAIF
Date: Tue, 19 May 2009 17:17:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
Message-ID: <20090519211704.GA3325@Krystal>
References: <cover.1242763826.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <cover.1242763826.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:14:54 up 80 days, 17:41,  5 users,  load average: 0.20, 0.34,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> hi,
> 
> After disassembling some of the tracepoints, I've noticed that arguments that
> are passed as macros or that perform  dereferences, evaluate prior to the
> tracepoint on/off check. This means that we are needlessly impacting the 
> off case.
> 
> I am proposing to fix this by adding a macro that first checks for on/off and
> then calls 'trace_##name', preserving type checking. Thus, callsites have to 
> move from:
> 
> trace_block_bio_complete(md->queue, bio);
> 
> to:
> 
> tracepoint_call(block_bio_complete,  md->queue, bio);
> 

I knew this limitation in the first place, but decided it was not worth
uglifying the tracepoint call site for it.

The expected use is to pass a pointer or a value as tracepoint argument
and dereference it in the callback attached to it.

Is there any _real_ added value for going through this API change pain ?

Mathieu

> I've tried '__always_inline', but that did not fix this issue. Obviously this
> change will require changes to all the callsites. But, that shouldn't be
> very hard, I've already included the scheduler and block changes with this
> patch. I think its important to minimize code execution in the off case, and
> thus going through all the callsites is well worth it. If we agree on this
> change, I can change the rest in very short order.
> 
> Below I'm also showing the assembly in the 'dec_pending()' function before and
> after this change to show the difference it makes. The arguments to the
> tracepoint are as above, 'md->queue' and 'bio'. Notice the 2 extra instructions,
> before the initial 'je', that could be moved after the 'je'.
> 
> before:
> 
> ffffffff8137b2a3:       83 3d de 90 4b 00 00    cmpl   $0x0,0x4b90de(%rip)        # ffffffff81834388 <__tracepoint_block_bio_complete+0x8>
> ffffffff8137b2aa:       49 8b 45 50             mov    0x50(%r13),%rax
> ffffffff8137b2ae:       48 89 45 d0             mov    %rax,-0x30(%rbp)
> ffffffff8137b2b2:       74 1f                   je     ffffffff8137b2d3 <dec_pending+0x101>
> ffffffff8137b2b4:       48 8b 1d d5 90 4b 00    mov    0x4b90d5(%rip),%rbx        # ffffffff81834390 <__tracepoint_block_bio_complete+0x10>
> ffffffff8137b2bb:       48 85 db                test   %rbx,%rbx
> ffffffff8137b2be:       74 13                   je     ffffffff8137b2d3 <dec_pending+0x101>
> ffffffff8137b2c0:       4c 89 f6                mov    %r14,%rsi
> ffffffff8137b2c3:       48 8b 7d d0             mov    -0x30(%rbp),%rdi
> ffffffff8137b2c7:       ff 13                   callq  *(%rbx)
> ffffffff8137b2c9:       48 83 c3 08             add    $0x8,%rbx
> ffffffff8137b2cd:       48 83 3b 00             cmpq   $0x0,(%rbx)
> ffffffff8137b2d1:       eb eb                   jmp    ffffffff8137b2be <dec_pending+0xec>
> ffffffff8137b2d3:       44 89 fe                mov    %r15d,%esi
> 
> after:
> 
> ffffffff8137b2a3:       83 3d de 90 4b 00 00    cmpl   $0x0,0x4b90de(%rip)        # ffffffff81834388 <__tracepoint_block_bio_complete+0x8>
> ffffffff8137b2aa:       74 27                   je     ffffffff8137b2d3 <dec_pending+0x101>
> ffffffff8137b2ac:       49 8b 45 50             mov    0x50(%r13),%rax
> ffffffff8137b2b0:       48 8b 1d d9 90 4b 00    mov    0x4b90d9(%rip),%rbx        # ffffffff81834390 <__tracepoint_block_bio_complete+0x10>
> ffffffff8137b2b7:       48 89 45 d0             mov    %rax,-0x30(%rbp)
> ffffffff8137b2bb:       48 85 db                test   %rbx,%rbx
> ffffffff8137b2be:       74 13                   je     ffffffff8137b2d3 <dec_pending+0x101>
> ffffffff8137b2c0:       4c 89 f6                mov    %r14,%rsi
> ffffffff8137b2c3:       48 8b 7d d0             mov    -0x30(%rbp),%rdi
> ffffffff8137b2c7:       ff 13                   callq  *(%rbx)
> ffffffff8137b2c9:       48 83 c3 08             add    $0x8,%rbx
> ffffffff8137b2cd:       48 83 3b 00             cmpq   $0x0,(%rbx)
> ffffffff8137b2d1:       eb eb                   jmp    ffffffff8137b2be <dec_pending+0xec>
> ffffffff8137b2d3:       44 89 fe                mov    %r15d,%esi
> 
> 
> thanks,
> 
> -Jason
> 
> 
> 
> Jason Baron (3):
>   -add wrapper so we don't have argument resolution overhead
>   -add scheduler wrapper calls
>   -add block layer trace wrappers
> 
>  block/blk-core.c           |   27 ++++++++++++++-------------
>  block/elevator.c           |    6 +++---
>  drivers/md/dm.c            |    7 ++++---
>  fs/bio.c                   |    2 +-
>  include/linux/tracepoint.h |   20 +++++++++++++++++++-
>  kernel/exit.c              |    6 +++---
>  kernel/fork.c              |    2 +-
>  kernel/kthread.c           |    4 ++--
>  kernel/sched.c             |   10 +++++-----
>  kernel/signal.c            |    2 +-
>  mm/bounce.c                |    2 +-
>  11 files changed, 54 insertions(+), 34 deletions(-)
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
