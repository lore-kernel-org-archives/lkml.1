Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZFDHei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZFDHei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZFDHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:34:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:52249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZFDHe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:34:29 -0400
Date: Thu, 4 Jun 2009 07:33:49 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com, efault@gmx.de,
       peterz@infradead.org, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       peterz@infradead.org, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Fix rbtree bug
Message-ID: <tip-a4c43beaff0fe6c83aa2505dce8ffe65db8e0a33@git.kernel.org>
Git-Commit-ID: a4c43beaff0fe6c83aa2505dce8ffe65db8e0a33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 07:33:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4c43beaff0fe6c83aa2505dce8ffe65db8e0a33
Gitweb:     http://git.kernel.org/tip/a4c43beaff0fe6c83aa2505dce8ffe65db8e0a33
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 3 Jun 2009 23:02:33 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 09:27:21 +0200

perf report: Fix rbtree bug

Ingo Molnar reported:

> FYI, i just got this crash (segfault) in perf report after
> collecting a long profile from Xorg:
>
> Starting program: /home/mingo/tip/Documentation/perf_counter/perf report
> [Thread debugging using libthread_db enabled]
> Detaching after fork from child process 20008.
> [New Thread 0x7f92fd62a6f0 (LWP 20005)]
>
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000041031a in __rb_erase_color (node=0x142c090, parent=0x0,
> root=0x881918)
>     at util/rbtree.c:143
> 143			if (parent->rb_left == node)

It was a problem introduced in this cset:

 perf report: Fix comm sorting - 8229289b607682f90b946ad2c319526303c17700

This patch should fix it.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 6003cc3..86f23f0 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -699,17 +699,18 @@ static void output__resort(void)
 {
 	struct rb_node *next;
 	struct hist_entry *n;
+	struct rb_root *tree = &hist;
 
 	if (sort__need_collapse)
-		next = rb_first(&collapse_hists);
-	else
-		next = rb_first(&hist);
+		tree = &collapse_hists;
+
+	next = rb_first(tree);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &hist);
+		rb_erase(&n->rb_node, tree);
 		output__insert_entry(n);
 	}
 }
