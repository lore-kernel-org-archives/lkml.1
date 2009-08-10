Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZHJSn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZHJSn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZHJSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:43:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZHJSn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:43:26 -0400
Date: Mon, 10 Aug 2009 18:42:34 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@linux.vnet.ibm.com, eric.dumazet@gmail.com,
       jkacur@redhat.com, peterz@infradead.org, dino@in.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, eric.dumazet@gmail.com,
       johnstul@linux.vnet.ibm.com, rostedt@goodmis.org, peterz@infradead.org,
       dino@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A7CA8C0.7010809@us.ibm.com>
References: <4A7CA8C0.7010809@us.ibm.com>
Subject: [tip:core/urgent] futex: Fix handling of bad requeue syscall pairing
Message-ID: <tip-392741e0a4e17c82e3978b7fcbf04291294dc0a1@git.kernel.org>
Git-Commit-ID: 392741e0a4e17c82e3978b7fcbf04291294dc0a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 18:42:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  392741e0a4e17c82e3978b7fcbf04291294dc0a1
Gitweb:     http://git.kernel.org/tip/392741e0a4e17c82e3978b7fcbf04291294dc0a1
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Fri, 7 Aug 2009 15:20:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 20:38:11 +0200

futex: Fix handling of bad requeue syscall pairing

If futex_requeue(requeue_pi=1) finds a futex_q that was created by a call
other the futex_wait_requeue_pi(), the q.rt_waiter may be null.  If so,
this will result in an oops from the following call graph:

futex_requeue()
  rt_mutex_start_proxy_lock()
    task_blocks_on_rt_mutex()
      waiter->task dereference
        OOPS

We currently WARN_ON() if this is detected, clearly this is inadequate.
If we detect a mispairing in futex_requeue(), bail out, seding -EINVAL to
user-space.

V2: Fix parenthesis warnings.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
LKML-Reference: <4A7CA8C0.7010809@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 8cc3ee1..e18cfbd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1256,8 +1256,15 @@ retry_private:
 		if (!match_futex(&this->key, &key1))
 			continue;
 
-		WARN_ON(!requeue_pi && this->rt_waiter);
-		WARN_ON(requeue_pi && !this->rt_waiter);
+		/*
+		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
+		 * be paired with each other and no other futex ops.
+		 */
+		if ((requeue_pi && !this->rt_waiter) ||
+		    (!requeue_pi && this->rt_waiter)) {
+			ret = -EINVAL;
+			break;
+		}
 
 		/*
 		 * Wake nr_wake waiters.  For requeue_pi, if we acquired the
