Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZFCJuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZFCJuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZFCJti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:49:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:60131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949AbZFCJtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:49:36 -0400
Date: Wed, 3 Jun 2009 09:48:59 GMT
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
Subject: [tip:perfcounters/core] perf report: Handle vDSO symbols properly
Message-ID: <tip-ed966aac335a63083d3125198479447248637d9e@git.kernel.org>
Git-Commit-ID: ed966aac335a63083d3125198479447248637d9e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 09:49:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed966aac335a63083d3125198479447248637d9e
Gitweb:     http://git.kernel.org/tip/ed966aac335a63083d3125198479447248637d9e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 10:39:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 10:39:26 +0200

perf report: Handle vDSO symbols properly

We were not looking up vDSO symbols properly, because they
are in the kallsyms but are user-mode entries.

Pass negative addresses to the kernel dso object, this
way we resolve them properly:

     0.05%  [kernel]: vread_tsc

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
 Documentation/perf_counter/builtin-report.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index a8d3905..0f88d9e 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -728,6 +728,8 @@ more:
 			event->ip.pid,
 			(void *)(long)ip);
 
+		dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
 		if (thread == NULL) {
 			fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
@@ -740,6 +742,8 @@ more:
 
 			dso = kernel_dso;
 
+			dprintf(" ...... dso: %s\n", dso->name);
+
 		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
 
 			show = SHOW_USER;
@@ -749,11 +753,22 @@ more:
 			if (map != NULL) {
 				dso = map->dso;
 				ip -= map->start + map->pgoff;
+			} else {
+				/*
+				 * If this is outside of all known maps,
+				 * and is a negative address, try to look it
+				 * up in the kernel dso, as it might be a
+				 * vsyscall (which executes in user-mode):
+				 */
+				if ((long long)ip < 0)
+					dso = kernel_dso;
 			}
+			dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
 
 		} else {
 			show = SHOW_HV;
 			level = 'H';
+			dprintf(" ...... dso: [hypervisor]\n");
 		}
 
 		if (show & show_mask) {
