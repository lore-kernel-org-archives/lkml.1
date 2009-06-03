Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZFCTQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZFCTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFCTQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:16:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:41820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbZFCTQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:16:17 -0400
Date: Wed, 3 Jun 2009 19:15:40 GMT
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
Subject: [tip:perfcounters/core] perf report: Add front-entry cache for lookups
Message-ID: <tip-eed4dcd443da7a46131ef37c7a389b444905960e@git.kernel.org>
Git-Commit-ID: eed4dcd443da7a46131ef37c7a389b444905960e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 19:15:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eed4dcd443da7a46131ef37c7a389b444905960e
Gitweb:     http://git.kernel.org/tip/eed4dcd443da7a46131ef37c7a389b444905960e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 19:59:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 20:03:32 +0200

perf report: Add front-entry cache for lookups

Before:

 Performance counter stats for './perf report -i perf.data.big':

     12453988058  instructions

 Performance counter stats for './perf report -i perf.data.big':

     12379566017  instructions

0.60% reduction.

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
 Documentation/perf_counter/builtin-report.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index e837bb9..33b3b15 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -229,6 +229,7 @@ static int thread__set_comm(struct thread *self, const char *comm)
 }
 
 static struct rb_root threads;
+static struct thread *last_match;
 
 static struct thread *threads__findnew(pid_t pid)
 {
@@ -236,12 +237,22 @@ static struct thread *threads__findnew(pid_t pid)
 	struct rb_node *parent = NULL;
 	struct thread *th;
 
+	/*
+	 * Font-end cache - PID lookups come in blocks,
+	 * so most of the time we dont have to look up
+	 * the full rbtree:
+	 */
+	if (last_match && last_match->pid == pid)
+		return last_match;
+
 	while (*p != NULL) {
 		parent = *p;
 		th = rb_entry(parent, struct thread, rb_node);
 
-		if (th->pid == pid)
+		if (th->pid == pid) {
+			last_match = th;
 			return th;
+		}
 
 		if (pid < th->pid)
 			p = &(*p)->rb_left;
@@ -253,7 +264,9 @@ static struct thread *threads__findnew(pid_t pid)
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &threads);
+		last_match = th;
 	}
+
 	return th;
 }
 
