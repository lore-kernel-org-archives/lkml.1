Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZE0VZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZE0VZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZE0VZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:25:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:37805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZE0VZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:25:44 -0400
Date: Wed, 27 May 2009 21:25:08 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] pref_counter: tools: report: Robustify in case of weird events
Message-ID: <tip-55717314c4e3a5180a54228a2f97e50f3496de4c@git.kernel.org>
Git-Commit-ID: 55717314c4e3a5180a54228a2f97e50f3496de4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 21:25:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55717314c4e3a5180a54228a2f97e50f3496de4c
Gitweb:     http://git.kernel.org/tip/55717314c4e3a5180a54228a2f97e50f3496de4c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 22:13:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 22:19:58 +0200

pref_counter: tools: report: Robustify in case of weird events

This error condition:

  aldebaran:~/linux/linux/Documentation/perf_counter> perf report
  dso__load_sym: cannot get elf header.
  failed to open: /etc/ld.so.cache
  problem processing PERF_EVENT_MMAP, bailing out

caused the profile to be very short - as the error was at the beginning
of the file and we bailed out completely.

Be more permissive and consider the event broken instead.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 6df95c2..5993c12 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -1117,9 +1117,9 @@ more:
 		}
 
 		if (thread == NULL) {
-			fprintf(stderr, "problem processing %d event, bailing out\n",
+			fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
-			goto done;
+			goto broken_event;
 		}
 
 		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
@@ -1149,8 +1149,8 @@ more:
 
 			if (hist_entry__add(thread, map, dso, sym, ip, level)) {
 				fprintf(stderr,
-		"problem incrementing symbol count, bailing out\n");
-				goto done;
+		"problem incrementing symbol count, skipping event\n");
+				goto broken_event;
 			}
 		}
 		total++;
@@ -1169,8 +1169,8 @@ more:
 				event->mmap.filename);
 		}
 		if (thread == NULL || map == NULL) {
-			fprintf(stderr, "problem processing PERF_EVENT_MMAP, bailing out\n");
-			goto done;
+			fprintf(stderr, "problem processing PERF_EVENT_MMAP, skipping event.\n");
+			goto broken_event;
 		}
 		thread__insert_map(thread, map);
 		total_mmap++;
@@ -1187,8 +1187,8 @@ more:
 		}
 		if (thread == NULL ||
 		    thread__set_comm(thread, event->comm.comm)) {
-			fprintf(stderr, "problem processing PERF_EVENT_COMM, bailing out\n");
-			goto done;
+			fprintf(stderr, "problem processing PERF_EVENT_COMM, skipping event.\n");
+			goto broken_event;
 		}
 		total_comm++;
 		break;
@@ -1221,7 +1221,6 @@ broken_event:
 		goto more;
 
 	rc = EXIT_SUCCESS;
-done:
 	close(input);
 
 	if (dump_trace) {
