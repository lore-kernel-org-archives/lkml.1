Return-Path: <linux-kernel-owner+w=401wt.eu-S936922AbZDCUmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936922AbZDCUmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936923AbZDCUkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:40:32 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43882 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936907AbZDCUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:40:29 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 6/9] RFC: futex: Add FUTEX_HAS_TIMEOUT flag to
	restart.futex.flags
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Fri, 03 Apr 2009 13:40:22 -0700
Message-ID: <20090403204022.9772.35322.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently restart is only used if there is a timeout.  The requeue_pi
functionality requires restarting to futex_lock_pi() on signal after wakeup in
futex_wait_requeue_pi() regardless of if there was a timeout or not.  Using 0
for the timeout value is confusing as that could indicate an expired timer.
The flag makes this explicit.  While the check is not technically needed in
futex_wait_restart(), doing so makes the code consistent with and will avoid
confusion should the need arise to restart wait without a timeout.

Changelog:
V7: -Corrected FLAGS_HAS_TIMEOUT flag detection logic per Eric Dumazet
V6: - Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
---

 kernel/futex.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c2b58d8..04e5431 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1252,6 +1252,7 @@ handle_fault:
  */
 #define FLAGS_SHARED		0x01
 #define FLAGS_CLOCKRT		0x02
+#define FLAGS_HAS_TIMEOUT	0x04
 
 static long futex_wait_restart(struct restart_block *restart);
 
@@ -1486,7 +1487,7 @@ retry_private:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = 0;
+	restart->futex.flags = FLAGS_HAS_TIMEOUT;
 
 	if (fshared)
 		restart->futex.flags |= FLAGS_SHARED;
@@ -1510,13 +1511,16 @@ static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
 	int fshared = 0;
-	ktime_t t;
+	ktime_t t, *tp = NULL;
 
-	t.tv64 = restart->futex.time;
+	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
+		t.tv64 = restart->futex.time;
+		tp = &t;
+	}
 	restart->fn = do_no_restart_syscall;
 	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = 1;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
+	return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
 				restart->futex.bitset,
 				restart->futex.flags & FLAGS_CLOCKRT);
 }

