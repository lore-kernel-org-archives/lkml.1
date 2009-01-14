Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbZANQUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbZANQUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbZANQU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:20:27 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:37973
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756969AbZANQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:20:26 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT git pull] fixes for rt/sched
To: rostedt@home.goodmis.org
Cc: gregory.haskins@gmail.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2009 11:23:31 -0500
Message-ID: <20090114162226.13517.44371.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfe6498c6a03e574bc9384cc95d73dfd20a13f05:
  Steven Rostedt (1):
        rt sched: add rt overload stats

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git rt/sched

Gregory Haskins (1):
      rt/sched: ensure interrupts are disabled during post-schedule() processing

 kernel/sched_rt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

---------------

rt/sched: ensure interrupts are disabled during post-schedule() processing

Impact: Fix run-time opps at boot up.

post-schedule() is required to run with interrupts disabled, but we
currently rely on the caller to have left them disabled for us.  This
has apparently changed recently such that interrupts are now on and
we thus crash.  Fix this once and for all by using the irqsave/restore
variants of spin_lock(rq). 

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/sched_rt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 856f6fb..0cd6b07 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1348,14 +1348,16 @@ static int needs_post_schedule_rt(struct rq *rq)
 
 static void post_schedule_rt(struct rq *rq)
 {
+	unsigned long flags;
+
 	/*
 	 * This is only called if needs_post_schedule_rt() indicates that
 	 * we need to push tasks away
 	 */
-	spin_lock(&rq->lock);
+	spin_lock_irqsave(&rq->lock, flags);
 	push_rt_tasks(rq);
 	schedstat_inc(rq, rto_schedule_tail);
-	spin_unlock(&rq->lock);
+	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*

