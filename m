Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZHORIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZHORIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZHORIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:08:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:33755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbZHORIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:08:15 -0400
Date: Sat, 15 Aug 2009 17:07:55 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12503552313921-git-send-email->
References: <12503552313921-git-send-email->
Subject: [tip:core/rcu] rcu: Make rcupreempt_trace.c look at offline CPUs
Message-ID: <tip-b612ba804b8a656333013ad2ee96fb2377df5dbb@git.kernel.org>
Git-Commit-ID: b612ba804b8a656333013ad2ee96fb2377df5dbb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:07:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b612ba804b8a656333013ad2ee96fb2377df5dbb
Gitweb:     http://git.kernel.org/tip/b612ba804b8a656333013ad2ee96fb2377df5dbb
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 15 Aug 2009 09:53:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 19:02:09 +0200

rcu: Make rcupreempt_trace.c look at offline CPUs

Given that offline CPUs can now have non-zero counters, we need
to dump counters for offline CPUs as well as for online CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: josht@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: hugh.dickins@tiscali.co.uk
Cc: benh@kernel.crashing.org
LKML-Reference: <12503552313921-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
