Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZC3WlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZC3WlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZC3Wk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:40:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45926 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZC3Wk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:40:58 -0400
Message-ID: <49D14A72.7010400@us.ibm.com>
Date: Mon, 30 Mar 2009 15:40:50 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 6/8] RFC: futex: Add FUTEX_HAS_TIMEOUT flag to
 restart.futex.flags
References: <20090330213306.606.9540.stgit@Aeon> <20090330213821.606.93755.stgit@Aeon> <49D13C50.4030601@cosmosbay.com>
In-Reply-To: <49D13C50.4030601@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

Hi Eric,

Thanks for the prompt review...

> Darren Hart a écrit :

>> -	t.tv64 = restart->futex.time;
>> +	if (restart->futex.flags | FLAGS_HAS_TIMEOUT) {
> 
> You probably meant :
> 
> if (restart->futex.flags & FLAGS_HAS_TIMEOUT)

Gah! You are correct.  Corrected patch below.


RFC: futex: Add FUTEX_HAS_TIMEOUT flag to restart.futex.flags

From: Darren Hart <dvhltc@us.ibm.com>

Currently restart is only used if there is a timeout.  The requeue_pi
functionality requires restarting to futex_lock_pi() on signal after
wakeup in futex_wait_requeue_pi() regardless of if there was a timeout
or not.  Using 0 for the timeout value is confusing as that could
indicate an expired timer.  The flag makes this explicit.

Changelog:
V7pre: -Corrected FLAGS_HAS_TIMEOUT flag detection logic per Eric Dumazet
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
index dd05803..07e314c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1254,6 +1254,7 @@ handle_fault:
  */
 #define FLAGS_SHARED		0x01
 #define FLAGS_CLOCKRT		0x02
+#define FLAGS_HAS_TIMEOUT	0x04
 
 static long futex_wait_restart(struct restart_block *restart);
 
@@ -1493,7 +1494,7 @@ retry_private:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = 0;
+	restart->futex.flags = FLAGS_HAS_TIMEOUT;
 
 	if (fshared)
 		restart->futex.flags |= FLAGS_SHARED;
@@ -1517,13 +1518,16 @@ static long futex_wait_restart(struct restart_block *restart)
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

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
