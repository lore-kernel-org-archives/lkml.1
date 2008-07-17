Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYGQHbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYGQHbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYGQHaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684AbYGQHaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 10/23] tracehook: tracehook_signal_handler
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Windows: sometimes you fill a vacuum and it still sucks.
Message-Id: <20080717073001.9D88F1541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines tracehook_signal_handler() as a hook for the arch signal
handling code to call.  It gives ptrace the opportunity to stop for a
pseudo-single-step trap immediately after signal handler setup is done.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index e113e09..2d1426f 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -289,4 +289,27 @@ static inline void tracehook_finish_release_task(struct task_struct *task)
 	ptrace_release_task(task);
 }
 
+/**
+ * tracehook_signal_handler - signal handler setup is complete
+ * @sig:		number of signal being delivered
+ * @info:		siginfo_t of signal being delivered
+ * @ka:			sigaction setting that chose the handler
+ * @regs:		user register state
+ * @stepping:		nonzero if debugger single-step or block-step in use
+ *
+ * Called by the arch code after a signal handler has been set up.
+ * Register and stack state reflects the user handler about to run.
+ * Signal mask changes have already been made.
+ *
+ * Called without locks, shortly before returning to user mode
+ * (or handling more signals).
+ */
+static inline void tracehook_signal_handler(int sig, siginfo_t *info,
+					    const struct k_sigaction *ka,
+					    struct pt_regs *regs, int stepping)
+{
+	if (stepping)
+		ptrace_notify(SIGTRAP);
+}
+
 #endif	/* <linux/tracehook.h> */
