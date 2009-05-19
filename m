Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZESVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZESVE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZESVEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:04:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZESVEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:04:20 -0400
Date: Tue, 19 May 2009 17:03:46 -0400
Message-Id: <cover.1242763826.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: [PATCH 0/3] tracepoints: delay argument evaluation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

After disassembling some of the tracepoints, I've noticed that arguments that
are passed as macros or that perform  dereferences, evaluate prior to the
tracepoint on/off check. This means that we are needlessly impacting the 
off case.

I am proposing to fix this by adding a macro that first checks for on/off and
then calls 'trace_##name', preserving type checking. Thus, callsites have to 
move from:

trace_block_bio_complete(md->queue, bio);

to:

tracepoint_call(block_bio_complete,  md->queue, bio);

I've tried '__always_inline', but that did not fix this issue. Obviously this
change will require changes to all the callsites. But, that shouldn't be
very hard, I've already included the scheduler and block changes with this
patch. I think its important to minimize code execution in the off case, and
thus going through all the callsites is well worth it. If we agree on this
change, I can change the rest in very short order.

Below I'm also showing the assembly in the 'dec_pending()' function before and
after this change to show the difference it makes. The arguments to the
tracepoint are as above, 'md->queue' and 'bio'. Notice the 2 extra instructions,
before the initial 'je', that could be moved after the 'je'.

before:

ffffffff8137b2a3:       83 3d de 90 4b 00 00    cmpl   $0x0,0x4b90de(%rip)        # ffffffff81834388 <__tracepoint_block_bio_complete+0x8>
ffffffff8137b2aa:       49 8b 45 50             mov    0x50(%r13),%rax
ffffffff8137b2ae:       48 89 45 d0             mov    %rax,-0x30(%rbp)
ffffffff8137b2b2:       74 1f                   je     ffffffff8137b2d3 <dec_pending+0x101>
ffffffff8137b2b4:       48 8b 1d d5 90 4b 00    mov    0x4b90d5(%rip),%rbx        # ffffffff81834390 <__tracepoint_block_bio_complete+0x10>
ffffffff8137b2bb:       48 85 db                test   %rbx,%rbx
ffffffff8137b2be:       74 13                   je     ffffffff8137b2d3 <dec_pending+0x101>
ffffffff8137b2c0:       4c 89 f6                mov    %r14,%rsi
ffffffff8137b2c3:       48 8b 7d d0             mov    -0x30(%rbp),%rdi
ffffffff8137b2c7:       ff 13                   callq  *(%rbx)
ffffffff8137b2c9:       48 83 c3 08             add    $0x8,%rbx
ffffffff8137b2cd:       48 83 3b 00             cmpq   $0x0,(%rbx)
ffffffff8137b2d1:       eb eb                   jmp    ffffffff8137b2be <dec_pending+0xec>
ffffffff8137b2d3:       44 89 fe                mov    %r15d,%esi

after:

ffffffff8137b2a3:       83 3d de 90 4b 00 00    cmpl   $0x0,0x4b90de(%rip)        # ffffffff81834388 <__tracepoint_block_bio_complete+0x8>
ffffffff8137b2aa:       74 27                   je     ffffffff8137b2d3 <dec_pending+0x101>
ffffffff8137b2ac:       49 8b 45 50             mov    0x50(%r13),%rax
ffffffff8137b2b0:       48 8b 1d d9 90 4b 00    mov    0x4b90d9(%rip),%rbx        # ffffffff81834390 <__tracepoint_block_bio_complete+0x10>
ffffffff8137b2b7:       48 89 45 d0             mov    %rax,-0x30(%rbp)
ffffffff8137b2bb:       48 85 db                test   %rbx,%rbx
ffffffff8137b2be:       74 13                   je     ffffffff8137b2d3 <dec_pending+0x101>
ffffffff8137b2c0:       4c 89 f6                mov    %r14,%rsi
ffffffff8137b2c3:       48 8b 7d d0             mov    -0x30(%rbp),%rdi
ffffffff8137b2c7:       ff 13                   callq  *(%rbx)
ffffffff8137b2c9:       48 83 c3 08             add    $0x8,%rbx
ffffffff8137b2cd:       48 83 3b 00             cmpq   $0x0,(%rbx)
ffffffff8137b2d1:       eb eb                   jmp    ffffffff8137b2be <dec_pending+0xec>
ffffffff8137b2d3:       44 89 fe                mov    %r15d,%esi


thanks,

-Jason



Jason Baron (3):
  -add wrapper so we don't have argument resolution overhead
  -add scheduler wrapper calls
  -add block layer trace wrappers

 block/blk-core.c           |   27 ++++++++++++++-------------
 block/elevator.c           |    6 +++---
 drivers/md/dm.c            |    7 ++++---
 fs/bio.c                   |    2 +-
 include/linux/tracepoint.h |   20 +++++++++++++++++++-
 kernel/exit.c              |    6 +++---
 kernel/fork.c              |    2 +-
 kernel/kthread.c           |    4 ++--
 kernel/sched.c             |   10 +++++-----
 kernel/signal.c            |    2 +-
 mm/bounce.c                |    2 +-
 11 files changed, 54 insertions(+), 34 deletions(-)

