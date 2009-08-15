Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZHOQxy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 15 Aug 2009 12:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbZHOQxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:53:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46800 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZHOQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:53:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
   mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip/core/rcu 5/6] Make rcupreempt_trace.c look at offline CPUs.
Date: Sat, 15 Aug 2009 09:53:50 -0700
Message-Id: <12503552313921-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Given that offline CPUs can now have non-zero counters, we need to
dump counters for offline CPUs as well as for online CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupreempt_trace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
index 7c2665c..1164034 100644
--- a/kernel/rcupreempt_trace.c
+++ b/kernel/rcupreempt_trace.c
@@ -236,12 +236,13 @@ static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
 
 	cnt += snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
 				"CPU last cur F M\n");
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		long *flipctr = rcupreempt_flipctr(cpu);
 		cnt += snprintf(&rcupreempt_trace_buf[cnt],
 				RCUPREEMPT_TRACE_BUF_SIZE - cnt,
-					"%3d %4ld %3ld %d %d\n",
+					"%3d%c %4ld %3ld %d %d\n",
 			       cpu,
+			       cpu_is_offline(cpu) ? '!' : ' ',
 			       flipctr[!f],
 			       flipctr[f],
 			       rcupreempt_flip_flag(cpu),
-- 
1.5.2.5

