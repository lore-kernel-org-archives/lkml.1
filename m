Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab0CKOjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:39:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:35321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab0CKOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:39:21 -0500
Date: Thu, 11 Mar 2010 14:38:50 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] x86/mce: Fix RCU lockdep splats
Message-ID: <tip-f56e8a0765cc4374e02f4e3a79e2427b5096b075@git.kernel.org>
Git-Commit-ID: f56e8a0765cc4374e02f4e3a79e2427b5096b075
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:38:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f56e8a0765cc4374e02f4e3a79e2427b5096b075
Gitweb:     http://git.kernel.org/tip/f56e8a0765cc4374e02f4e3a79e2427b5096b075
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 5 Mar 2010 15:03:27 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 13:38:02 +0100

x86/mce: Fix RCU lockdep splats

Create an rcu_dereference_check_mce() that checks for RCU-sched
read side and mce_read_mutex being held on update side.  Replace
uses of rcu_dereference() in arch/x86/kernel/cpu/mcheck/mce.c
with this new macro.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..4442e9e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -46,6 +46,11 @@
 
 #include "mce-internal.h"
 
+#define rcu_dereference_check_mce(p) \
+	rcu_dereference_check((p), \
+			      rcu_read_lock_sched_held() || \
+			      lockdep_is_held(&mce_read_mutex))
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
@@ -158,7 +163,7 @@ void mce_log(struct mce *mce)
 	mce->finished = 0;
 	wmb();
 	for (;;) {
-		entry = rcu_dereference(mcelog.next);
+		entry = rcu_dereference_check_mce(mcelog.next);
 		for (;;) {
 			/*
 			 * When the buffer fills up discard new entries.
@@ -1500,7 +1505,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 		return -ENOMEM;
 
 	mutex_lock(&mce_read_mutex);
-	next = rcu_dereference(mcelog.next);
+	next = rcu_dereference_check_mce(mcelog.next);
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
@@ -1565,7 +1570,7 @@ timeout:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (rcu_dereference_check_mce(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
