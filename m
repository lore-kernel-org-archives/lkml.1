Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbZCTKaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbZCTKaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762071AbZCTK2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762671AbZCTK2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:28:02 -0400
Date: Fri, 20 Mar 2009 10:26:18 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C2F5FF.80002@cn.fujitsu.com>
References: <49C2F5FF.80002@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: don't increase blk_probes_ref if failed to setup blk trace
Message-ID: <tip-64ddedc03c9ecbe97b0700e85c5f11d2f5a4565c@git.kernel.org>
Git-Commit-ID: 64ddedc03c9ecbe97b0700e85c5f11d2f5a4565c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:26:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64ddedc03c9ecbe97b0700e85c5f11d2f5a4565c
Gitweb:     http://git.kernel.org/tip/64ddedc03c9ecbe97b0700e85c5f11d2f5a4565c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 09:48:47 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:20:05 +0100

blktrace: don't increase blk_probes_ref if failed to setup blk trace

do_blk_trace_setup() may return EBUSY, but the current code
doesn't decrease blk_probes_ref in this case.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C2F5FF.80002@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 223b92e..11e7c8d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -468,9 +468,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
-	if (atomic_add_return(1, &blk_probes_ref) == 1)
-		blk_register_tracepoints();
-
 	ret = -EBUSY;
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt) {
@@ -478,6 +475,9 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		goto err;
 	}
 
+	if (atomic_add_return(1, &blk_probes_ref) == 1)
+		blk_register_tracepoints();
+
 	return 0;
 err:
 	if (bt) {
