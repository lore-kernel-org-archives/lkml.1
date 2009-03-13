Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZCMAZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZCMAZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZCMAZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:25:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:36695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbZCMAZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:25:03 -0400
Date: Fri, 13 Mar 2009 00:24:31 GMT
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
Subject: [tip:core/urgent] futex: unlock before returning -EFAULT
Message-ID: <tip-3d7bdf7880ea243f25cddd847ca65475ed627e5f@git.kernel.org>
Git-Commit-ID: 3d7bdf7880ea243f25cddd847ca65475ed627e5f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 00:24:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d7bdf7880ea243f25cddd847ca65475ed627e5f
Gitweb:     http://git.kernel.org/tip/3d7bdf7880ea243f25cddd847ca65475ed627e5f
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Thu, 12 Mar 2009 00:56:06 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 01:21:00 +0100

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
index a66cd2d..7e0a916 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1570,6 +1570,13 @@ retry_locked:
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
 
