Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZFDMtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZFDMtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZFDMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:49:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbZFDMtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:49:11 -0400
Date: Thu, 4 Jun 2009 12:48:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record/report: Fix PID/COMM handling
Message-ID: <tip-df97992c6e25ffc66c549c8bc59262dc627c6d17@git.kernel.org>
Git-Commit-ID: df97992c6e25ffc66c549c8bc59262dc627c6d17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 12:48:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df97992c6e25ffc66c549c8bc59262dc627c6d17
Gitweb:     http://git.kernel.org/tip/df97992c6e25ffc66c549c8bc59262dc627c6d17
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 13:41:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 13:41:37 +0200

perf record/report: Fix PID/COMM handling

Fix two bugs causing lost comm mappings:

 - initial PID is not 0 but getpid()

 - when we are unable to handle an mmap event, dont assume the event
   itself is broken - try to parse the stream. This way we wont lose
   comm events.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    2 +-
 Documentation/perf_counter/builtin-report.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index efa2eb4..bf59df5 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -430,7 +430,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!system_wide) {
-		open_counters(-1, target_pid != -1 ? target_pid : 0);
+		open_counters(-1, target_pid != -1 ? target_pid : getpid());
 	} else for (i = 0; i < nr_cpus; i++)
 		open_counters(i, target_pid);
 
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 86f23f0..ff6f657 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -852,7 +852,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 
 	if (thread == NULL || map == NULL) {
 		dprintf("problem processing PERF_EVENT_MMAP, skipping event.\n");
-		return -1;
+		return 0;
 	}
 
 	thread__insert_map(thread, map);
