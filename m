Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZIHWyj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 8 Sep 2009 18:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIHWyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:54:38 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41969 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbZIHWyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:54:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH tip/core/rcu 1/3] rcutorture: Occasionally delay readers enough to make RCU force_quiescent_state
Date: Tue,  8 Sep 2009 15:54:35 -0700
Message-Id: <12524504772607-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090908225349.GA19524@linux.vnet.ibm.com>
References: <20090908225349.GA19524@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

rcutorture already delays readers, but never for long enough to make RCU
force a quiescent state.  Add an occasional delay of 50ms.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutorture.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b33db53..328a825 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -281,14 +281,17 @@ static int rcu_torture_read_lock(void) __acquires(RCU)
 
 static void rcu_read_delay(struct rcu_random_state *rrsp)
 {
-	long delay;
-	const long longdelay = 200;
+	const unsigned long shortdelay_us = 200;
+	const unsigned long longdelay_ms = 50;
 
-	/* We want there to be long-running readers, but not all the time. */
+	/* We want a short delay sometimes to make a reader delay the grace
+	 * period, and we want a long delay occasionally to trigger
+	 * force_quiescent_state. */
 
-	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay);
-	if (!delay)
-		udelay(longdelay);
+	if (!(rcu_random(rrsp) % (nrealreaders * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms);
+	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
+		udelay(shortdelay_us);
 }
 
 static void rcu_torture_read_unlock(int idx) __releases(RCU)
-- 
1.5.2.5

