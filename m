Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbXJWUAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbXJWUAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXJWUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:00:33 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:64921 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXJWUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:00:31 -0400
Subject: [RFC PATCH 2/2] base scheduler_tick() on virtual time
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefksy <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 22:02:27 +0200
Message-Id: <1193169748.5922.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the scheduler_tick() dependent on the s390 cpu timer so it gets only called after
a virtual cpu has completed a tick. Together with the virtual sched_clock() this 
should make the scheduler decisions for s390 based on virtual time.

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
 arch/s390/kernel/time.c    |    4 ----
 arch/s390/kernel/vtime.c   |    7 ++++++-
 include/asm-s390/lowcore.h |    8 ++++++--
 include/asm-s390/timer.h   |    4 ++++
 4 files changed, 16 insertions(+), 7 deletions(-)

Index: linux-2.6/include/asm-s390/timer.h
===================================================================
--- linux-2.6.orig/include/asm-s390/timer.h
+++ linux-2.6/include/asm-s390/timer.h
@@ -14,6 +14,10 @@
 
 #include <linux/timer.h>
 
+/* change this if you have some constant time drift */
+#define USECS_PER_JIFFY     ((unsigned long) 1000000/HZ)
+#define CLK_TICKS_PER_JIFFY ((unsigned long) USECS_PER_JIFFY << 12)
+
 #define VTIMER_MAX_SLICE (0x7ffffffffffff000LL)
 
 struct vtimer_list {
Index: linux-2.6/include/asm-s390/lowcore.h
===================================================================
--- linux-2.6.orig/include/asm-s390/lowcore.h
+++ linux-2.6/include/asm-s390/lowcore.h
@@ -83,6 +83,7 @@
 #define __LC_JIFFY_TIMER		0xC80
 #define __LC_CURRENT			0xC90
 #define __LC_INT_CLOCK			0xC98
+#define __LC_VIRT_TICK			0xCA0
 #else /* __s390x__ */
 #define __LC_IRB			0x210
 #define __LC_SYNC_ENTER_TIMER		0x250
@@ -106,6 +107,7 @@
 #define __LC_JIFFY_TIMER		0xDC0
 #define __LC_CURRENT			0xDD8
 #define __LC_INT_CLOCK			0xDE8
+#define __LC_VIRT_TICK			0xDF0
 #endif /* __s390x__ */
 

@@ -282,7 +284,8 @@ struct _lowcore
 	__u32        current_task;	       /* 0xc90 */
 	__u32        softirq_pending;	       /* 0xc94 */
 	__u64        int_clock;                /* 0xc98 */
-        __u8         pad11[0xe00-0xca0];       /* 0xca0 */
+	__u64	     virt_tick;		       /* 0xca0 */
+	__u8         pad11[0xe00-0xca8];       /* 0xca8 */
 
         /* 0xe00 is used as indicator for dump tools */
         /* whether the kernel died with panic() or not */
@@ -374,7 +377,8 @@ struct _lowcore
 	__u64        current_task;	       /* 0xdd8 */
 	__u64        softirq_pending;	       /* 0xde0 */
 	__u64        int_clock;                /* 0xde8 */
-        __u8         pad12[0xe00-0xdf0];       /* 0xdf0 */
+	__u64	     virt_tick;		       /* 0xdf0 */
+	__u8         pad12[0xe00-0xdf8];       /* 0xdf8 */
 
         /* 0xe00 is used as indicator for dump tools */
         /* whether the kernel died with panic() or not */
Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -40,10 +40,6 @@
 #include <asm/timer.h>
 #include <asm/etr.h>
 
-/* change this if you have some constant time drift */
-#define USECS_PER_JIFFY     ((unsigned long) 1000000/HZ)
-#define CLK_TICKS_PER_JIFFY ((unsigned long) USECS_PER_JIFFY << 12)
-
 /* The value of the TOD clock for 1.1.1970. */
 #define TOD_UNIX_EPOCH 0x7d91048bca000000ULL
 
Index: linux-2.6/arch/s390/kernel/vtime.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/vtime.c
+++ linux-2.6/arch/s390/kernel/vtime.c
@@ -85,6 +85,7 @@ void account_tick_vtime(struct task_stru
 		        "=m" (S390_lowcore.last_update_clock) );
 	S390_lowcore.system_timer += timer - S390_lowcore.last_update_timer;
 	S390_lowcore.steal_clock += S390_lowcore.last_update_clock - clock;
+	S390_lowcore.virt_tick += timer - S390_lowcore.last_update_timer;
 
 	cputime = S390_lowcore.user_timer >> 12;
 	rcu_user_flag = cputime != 0;
@@ -107,7 +108,11 @@ void account_tick_vtime(struct task_stru
 	run_local_timers();
 	if (rcu_pending(smp_processor_id()))
 		rcu_check_callbacks(smp_processor_id(), rcu_user_flag);
-	scheduler_tick();
+
+	while (S390_lowcore.virt_tick >= CLK_TICKS_PER_JIFFY) {
+		S390_lowcore.virt_tick -= CLK_TICKS_PER_JIFFY;
+		scheduler_tick();
+	}
  	run_posix_cpu_timers(tsk);
 }
 


