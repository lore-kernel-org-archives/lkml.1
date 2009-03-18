Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZCRJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZCRJUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbZCRJTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:19:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:57630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbZCRJTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:19:15 -0400
Date: Wed, 18 Mar 2009 09:18:47 GMT
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:tracing/tasks] tracing: fix trace_find_cmdline()
Message-ID: <tip-50d88758a3f9787cbdbdbc030560b815721eab4b@git.kernel.org>
Git-Commit-ID: 50d88758a3f9787cbdbdbc030560b815721eab4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 09:18:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50d88758a3f9787cbdbdbc030560b815721eab4b
Gitweb:     http://git.kernel.org/tip/50d88758a3f9787cbdbdbc030560b815721eab4b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 18 Mar 2009 08:58:44 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 10:10:17 +0100

tracing: fix trace_find_cmdline()

Impact: prevent stale command line output

In case there is no valid command line mapping for a pid
trace_find_cmdline() returns without updating the comm buffer. The
trace dump keeps the previous entry which results in confusing trace
output:

     <idle>-0     [000]   280.702056 ....
     <idle>-23456 [000]   280.702080 ....

Update the comm buffer with "<...>" when no mapping is found.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ca673c4..06c69a2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -787,12 +787,11 @@ void trace_find_cmdline(int pid, char comm[])
 
 	__raw_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
-	if (map == NO_CMDLINE_MAP)
-		goto out;
-
-	strcpy(comm, saved_cmdlines[map]);
+	if (map != NO_CMDLINE_MAP)
+		strcpy(comm, saved_cmdlines[map]);
+	else
+		strcpy(comm, "<...>");
 
- out:
 	__raw_spin_unlock(&trace_cmdline_lock);
 }
 
