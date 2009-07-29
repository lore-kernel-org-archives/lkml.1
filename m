Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZG2CFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZG2CFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZG2CFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:05:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZG2CFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:05:20 -0400
Date: Wed, 29 Jul 2009 04:01:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] introduce tracehook_finish_jctl() helper
Message-ID: <20090729020139.GA7381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(textually depends on signals-tracehook_notify_jctl-change.patch)

Introduce the empty inline tracehook_finish_jctl() helper called by
do_signal_stop() after wakeup.

Currently we lack the ability to report this state change.

Also fix the comment, it should be placed before schedule().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/tracehook.h |    9 +++++++++
 kernel/signal.c           |    2 ++
 2 files changed, 11 insertions(+)

--- __UTRACE/include/linux/tracehook.h~2_FINISH_JCTL	2009-07-29 03:10:10.000000000 +0200
+++ __UTRACE/include/linux/tracehook.h	2009-07-29 03:51:42.000000000 +0200
@@ -521,6 +521,15 @@ static inline int tracehook_notify_jctl(
 	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
 }
 
+/**
+ * tracehook_finish_jctl - report about return from job control stop
+ *
+ * This is called by do_signal_stop() after wakeup.
+ */
+static inline void tracehook_finish_jctl(void)
+{
+}
+
 #define DEATH_REAP			-1
 #define DEATH_DELAYED_GROUP_LEADER	-2
 
--- __UTRACE/kernel/signal.c~2_FINISH_JCTL	2009-07-29 03:17:49.000000000 +0200
+++ __UTRACE/kernel/signal.c	2009-07-29 03:57:07.000000000 +0200
@@ -1735,12 +1735,12 @@ static int do_signal_stop(int signr)
 		read_unlock(&tasklist_lock);
 	}
 
+	/* Now we don't run again until woken by SIGCONT or SIGKILL */
 	do {
 		schedule();
 	} while (try_to_freeze());
-	/*
-	 * Now we don't run again until continued.
-	 */
+
+	tracehook_finish_jctl();
 	current->exit_code = 0;
 
 	return 1;

