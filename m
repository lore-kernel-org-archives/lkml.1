Return-Path: <linux-kernel-owner+w=401wt.eu-S936977AbYCSXFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936977AbYCSXFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936013AbYCSVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:31:26 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45627 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750AbYCSVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:31:25 -0400
Date: Wed, 19 Mar 2008 04:49:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20080319034952.GB21347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

[ Note: it touches net/core/sock.c to tweak two socket wakeups there. ]

this tree improves/fixes lat_ctx/lat_pipe/bw_pipe latency/performance on 
SMP systems:

                      .25-rc6            .25-rc6-sched/for-linus
   -------------------------------------------------------------
   lat_ctx 2 :        1.93 us                0.69 us
   lat_pipe  :        4.96 us                2.49 us
   bw_pipe   :     2841.11 MB/sec         3436.61 MB/sec

it also improves the ramp-up phase of sysbench on a quad:

                      .25-rc6            .25-rc6-sched/for-linus
   -------------------------------------------------------------
      1:     ( 836.64 per sec.)         (1216.90 per sec.)
      2:     (2407.02 per sec.)         (2361.12 per sec.)
      4:     (4468.59 per sec.)         (4510.14 per sec.)

( similar improvements were measured on an 8-way and on various
  dual boxes as well - a 16way box was largely unchanged. )

these changes also improved some other workloads as well: mysql, apache 
and others - and it did not impact some others that we handled well 
before (such as kbuild, hackbench and others).

Thanks,

	Ingo

------------------>
Ingo Molnar (8):
      sched: clean up wakeup balancing, move wake_affine()
      sched: clean up wakeup balancing, rename variables
      sched: clean up wakeup balancing, code flow
      sched, net: socket wakeups are sync
      sched: improve affine wakeups
      sched: wakeup-buddy tasks are cache-hot
      sched: retune wake granularity
      sched: tune multi-core idle balancing

 include/linux/sched.h    |    3 +
 include/linux/topology.h |    1 -
 kernel/sched.c           |   11 +++-
 kernel/sched_debug.c     |    1 +
 kernel/sched_fair.c      |  191 ++++++++++++++++++++++++++++------------------
 net/core/sock.c          |    4 +-
 6 files changed, 134 insertions(+), 77 deletions(-)
