Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZCLUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZCLUzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZCLUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:55:07 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:43508 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbZCLUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:55:05 -0400
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 16:55:05 EDT
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
To: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc7-rt1
Date: Thu, 12 Mar 2009 21:43:33 +0100
User-Agent: KMail/1.9.9
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122143.33840.tim01@vlsi.informatik.tu-darmstadt.de>
X-PMX: seen v0.51
X-PMX-SPAMCHECK: outgoing mail: not checked
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

It is great to see that the -rt patchset is moving again.

> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc7-rt1.bz2
This should be 
http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc7-rt1.patch.bz2  

As far as i understand this is again for x86. I tried some patches to get the 
ARM platform working as the platform i am working on (phytec i.mx31) is not 
supported by the stable 2.6.26-rt release. The attached patches are for 
reference only as i think some of them are on their way via the pengutronix 
git tree and others are just hacks to get this thing compile. These patches 
enable rt functionality as tested with cyclictest but the kernel is not 
stable, so some pieces are missing.

So my question is, what pieces are missing on the ARM platform to get it working?

Regards
Tim

The following patches are against the 2.6.29-rc4-rt2 in an attempt to get ARM working. 
Subject: [PATCH] add compile fixes to rt patchset for arm

---
 arch/arm/Kconfig                        |   13 +------------
 arch/arm/include/asm/thread_info.h      |    3 ++-
 arch/arm/plat-mxc/include/mach/memory.h |    2 ++
 include/linux/spinlock.h                |    3 ++-
 4 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dbfdf87..ceb2e01 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -838,18 +838,7 @@ config LOCAL_TIMERS
          accounting to be spread across the timer interval, preventing a
          "thundering herd" at every timer tick.

-config PREEMPT
-       bool "Preemptible Kernel (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
-       help
-         This option reduces the latency of the kernel when reacting to
-         real-time or interactive events by allowing a low priority process to
-         be preempted even if it is in kernel mode executing a system call.
-         This allows applications to run more reliably even when the system is
-         under load.
-
-         Say Y here if you are building a kernel for a desktop, embedded
-         or real-time system.  Say N if you are unsure.
+source kernel/Kconfig.preempt

 config HZ
        int
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 68b9ec8..b501541 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -119,7 +119,8 @@ extern void iwmmxt_task_switch(struct thread_info *);
  * We use bit 30 of the preempt_count to indicate that kernel
  * preemption is occurring.  See <asm/hardirq.h>.
  */
-#define PREEMPT_ACTIVE 0x40000000
+#define PREEMPT_ACTIVE         0x10000000
+/*FIXME TIM #define PREEMPT_ACTIVE     0x40000000*/

 /*
  * thread information flags:
diff --git a/arch/arm/plat-mxc/include/mach/memory.h 
b/arch/arm/plat-mxc/include/mach/memory.h
index 0b80839..b43a536 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -19,4 +19,6 @@
 #define PHYS_OFFSET            UL(0x80000000)
 #endif

+#define arch_is_coherent()     1
+
 #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index c11b3a2..6c9b9b9 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -560,7 +560,8 @@ static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 # ifdef CONFIG_DEBUG_SPINLOCK
        BUG_ON(!test_bit(bitnum, addr));
 # endif
-       clear_bit_unlock(bitnum, addr);
+       //FIXME TIM  clear_bit_unlock(bitnum, addr);
+       clear_bit(bitnum,addr);
 #endif
        __release(bitlock);
 }
--
1.5.6.5

-- ---
 arch/arm/kernel/process.c |    2 +-
 include/linux/spinlock.h  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d3ea6fa..8fbf03b 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -167,7 +167,7 @@ void cpu_idle(void)
                        idle();
                leds_event(led_idle_end);
                tick_nohz_restart_sched_tick();
-               preempt_enable_no_resched();
+               __preempt_enable_no_resched();
                schedule();
                preempt_disable();
        }
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 6c9b9b9..130fbdd 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -93,6 +93,7 @@
 #include <linux/bottom_half.h>
 #include <linux/irqflags.h>
 #include <linux/pickop.h>
+#include <asm/memory.h>

 #include <asm/system.h>

@@ -560,8 +561,7 @@ static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 # ifdef CONFIG_DEBUG_SPINLOCK
        BUG_ON(!test_bit(bitnum, addr));
 # endif
-       //FIXME TIM  clear_bit_unlock(bitnum, addr);
-       clear_bit(bitnum,addr);
+       clear_bit_unlock(bitnum, addr);
 #endif
        __release(bitlock);
 }
--
1.5.6.5


''=~('(?{'.('._@@[~'^'^-)./^').'"'.('}@@~-]@_^__'^'))-^~<.;;-}').',$/})')
