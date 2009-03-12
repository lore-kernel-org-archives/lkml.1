Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZCLK1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZCLK1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZCLKZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:25:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:44976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbZCLKZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:25:49 -0400
Date: Thu, 12 Mar 2009 10:24:58 GMT
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312075606.9856.88729.stgit@Aeon>
References: <20090312075606.9856.88729.stgit@Aeon>
Subject: [tip:core/futexes] futex: unlock before returning -EFAULT
Message-ID: <tip-e8f6386c01a5699c115bdad10271a24076364c97@git.kernel.org>
Git-Commit-ID: e8f6386c01a5699c115bdad10271a24076364c97
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 10:25:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8f6386c01a5699c115bdad10271a24076364c97
Gitweb:     http://git.kernel.org/tip/e8f6386c01a5699c115bdad10271a24076364c97
Author:     "Darren Hart" <dvhltc@us.ibm.com>
AuthorDate: Thu, 12 Mar 2009 00:56:06 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 11:20:57 +0100

futex: unlock before returning -EFAULT

Impact: rt-mutex failure case fix

futex_lock_pi can potentially return -EFAULT with the rt_mutex
held.  This seems like the wrong thing to do as userspace should
assume -EFAULT means the lock was not taken.  Even if it could
figure this out, we'd be leaving the pi_state->owner in an
inconsistent state.  This patch unlocks the rt_mutex prior to
returning -EFAULT to userspace.

Build and boot tested on a 4 way Intel x86_64 workstation.
Passes basic pthread_mutex and PI tests out of
ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090312075606.9856.88729.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6579912..c980a55 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1567,6 +1567,13 @@ retry_locked:
 		}
 	}
 
+	/*
+	 * If fixup_pi_state_owner() faulted and was unable to handle the
+	 * fault, unlock it and return the fault to userspace.
+	 */
+	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
+		rt_mutex_unlock(&q.pi_state->pi_mutex);
+
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
