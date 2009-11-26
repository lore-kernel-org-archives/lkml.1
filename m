Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZKZIpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZKZIpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbZKZIpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:45:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:58823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760026AbZKZIpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:45:14 -0500
Date: Thu, 26 Nov 2009 08:44:42 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
References: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Fix breakpoint removal after modification
Message-ID: <tip-d99be40aff88722ab03ee295e4f6c13a4cca9a3d@git.kernel.org>
Git-Commit-ID: d99be40aff88722ab03ee295e4f6c13a4cca9a3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d99be40aff88722ab03ee295e4f6c13a4cca9a3d
Gitweb:     http://git.kernel.org/tip/d99be40aff88722ab03ee295e4f6c13a4cca9a3d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 26 Nov 2009 05:35:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:29:20 +0100

ksym_tracer: Fix breakpoint removal after modification

The error path of a breakpoint modification is broken in
the ksym tracer. A modified breakpoint hlist node is immediately
released after its removal. Also we leak a breakpoint in this
case.

Fix the path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 11935b5..9f040e4 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -339,14 +339,20 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 					ksym_hbp_handler, true);
 			if (IS_ERR(entry->ksym_hbp))
 				entry->ksym_hbp = NULL;
-			if (!entry->ksym_hbp)
+
+			/* modified without problem */
+			if (entry->ksym_hbp) {
+				ret = 0;
 				goto out;
+			}
+		} else {
+			ret = 0;
 		}
+		/* Error or "symbol:---" case: drop it */
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry);
-		ret = 0;
 		goto out;
 	} else {
 		/* Check for malformed request: (4) */
