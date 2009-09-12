Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZILH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZILH4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZILH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:56:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:39038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZILH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:56:21 -0400
Date: Sat, 12 Sep 2009 07:55:41 GMT
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, josh@joshtriplett.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
       josh@joshtriplett.org, mingo@elte.hu
In-Reply-To: <12524504772607-git-send-email->
References: <12524504772607-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcutorture: Occasionally delay readers enough to make RCU force_quiescent_state
Message-ID: <tip-f4a82a059aea43947d4f37dba9da1782d11caece@git.kernel.org>
Git-Commit-ID: f4a82a059aea43947d4f37dba9da1782d11caece
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:55:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4a82a059aea43947d4f37dba9da1782d11caece
Gitweb:     http://git.kernel.org/tip/f4a82a059aea43947d4f37dba9da1782d11caece
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Tue, 8 Sep 2009 15:54:35 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 12 Sep 2009 09:47:07 +0200

rcutorture: Occasionally delay readers enough to make RCU force_quiescent_state

rcutorture already delays readers, but never for long enough to
make RCU force a quiescent state.  Add an occasional delay of
50ms.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
LKML-Reference: <12524504772607-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
