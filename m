Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZCLH5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZCLH5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZCLH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:56:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49003 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbZCLH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:56:11 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 5/6] futex: unlock before returning -EFAULT
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 00:56:06 -0700
Message-ID: <20090312075606.9856.88729.stgit@Aeon>
In-Reply-To: <20090312075349.9856.83687.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_lock_pi can potentially return -EFAULT with the rt_mutex held.  This
seems like the wrong thing to do as userspace should assume -EFAULT means the
lock was not taken.  Even if it could figure this out, we'd be leaving the
pi_state->owner in an inconsistent state.  This patch unlocks the rt_mutex
prior to returning -EFAULT to userspace.

Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
pthread_mutex and PI tests out of ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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
 

