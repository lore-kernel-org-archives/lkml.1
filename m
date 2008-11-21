Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYKUI2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYKUI2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYKUI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:27:59 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52232 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYKUI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:27:58 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 6/7] sched: re-tune balancing -- revert
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2008 14:01:46 +0530
Message-ID: <20081121083146.27075.94032.stgit@drishya.in.ibm.com>
In-Reply-To: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9fcd18c9e63e325dbd2b4c726623f760788d5aa8
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Wed Nov 5 16:52:08 2008 +0100

    Reverting this patch since this affects consolidation
    and power savings. Will rework this tuning in the next
    iteration.

    Impact: improve wakeup affinity on NUMA systems, tweak SMP systems

    Given the fixes+tweaks to the wakeup-buddy code, re-tweak the domain
    balancing defaults on NUMA and SMP systems.

    Turn on SD_WAKE_AFFINE which was off on x86 NUMA - there's no reason
    why we would not want to have wakeup affinity across nodes as well.
    (we already do this in the standard NUMA template.)

    lat_ctx on a NUMA box is particularly happy about this change:

    before:

     |   phoenix:~/l> ./lat_ctx -s 0 2
     |   "size=0k ovr=2.60
     |   2 5.70

    after:

     |   phoenix:~/l> ./lat_ctx -s 0 2
     |   "size=0k ovr=2.65
     |   2 2.07

    a 2.75x speedup.

    pipe-test is similarly happy about it too:

     |  phoenix:~/sched-tests> ./pipe-test
     |   18.26 usecs/loop.
     |   14.70 usecs/loop.
     |   14.38 usecs/loop.
     |   10.55 usecs/loop.              # +WAKE_AFFINE on domain0+domain1
     |   8.63 usecs/loop.
     |   8.59 usecs/loop.
     |   9.03 usecs/loop.
     |   8.94 usecs/loop.
     |   8.96 usecs/loop.
     |   8.63 usecs/loop.

    Also:

     - disable SD_BALANCE_NEWIDLE on NUMA and SMP domains (keep it for siblings)
     - enable SD_WAKE_BALANCE on SMP domains

    Sysbench+postgresql improves all around the board, quite significantly:

               .28-rc3-11474e2c  .28-rc3-11474e2c-tune
    -------------------------------------------------
        1:             571              688    +17.08%
        2:            1236             1206    -2.55%
        4:            2381             2642    +9.89%
        8:            4958             5164    +3.99%
       16:            9580             9574    -0.07%
       32:            7128             8118    +12.20%
       64:            7342             8266    +11.18%
      128:            7342             8064    +8.95%
      256:            7519             7884    +4.62%
      512:            7350             7731    +4.93%
    -------------------------------------------------
      SUM:           55412            59341    +6.62%

    So it's a win both for the runup portion, the peak area and the tail.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 arch/x86/include/asm/topology.h |    7 +++----
 include/linux/topology.h        |    4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4850e4b..90ac771 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -154,7 +154,7 @@ extern unsigned long node_remap_size[];
 
 #endif
 
-/* sched_domains SD_NODE_INIT for NUMA machines */
+/* sched_domains SD_NODE_INIT for NUMAQ machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
 	.min_interval		= 8,			\
 	.max_interval		= 32,			\
@@ -169,9 +169,8 @@ extern unsigned long node_remap_size[];
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SERIALIZE,		\
+				| SD_SERIALIZE		\
+				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 117f1b7..2565f4a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -146,10 +146,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
+				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
 				| BALANCE_FOR_PKG_POWER,\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\

