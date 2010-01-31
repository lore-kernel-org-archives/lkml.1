Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973Ab0AaIbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0AaIbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826Ab0AaIbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:31:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:51257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0AaIbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:31:43 -0500
Date: Sun, 31 Jan 2010 08:30:50 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "perf record: Intercept all events"
Message-ID: <tip-a8e6f734ce9a79d44ebb296f2a341f435227b34e@git.kernel.org>
Git-Commit-ID: a8e6f734ce9a79d44ebb296f2a341f435227b34e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 08:30:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8e6f734ce9a79d44ebb296f2a341f435227b34e
Gitweb:     http://git.kernel.org/tip/a8e6f734ce9a79d44ebb296f2a341f435227b34e
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sat, 30 Jan 2010 20:55:41 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Jan 2010 08:27:52 +0100

Revert "perf record: Intercept all events"

This reverts commit f5a2c3dce03621b55f84496f58adc2d1a87ca16f.

This patch is required for making "perf lock rec" work.
The commit f5a2c3dce0 changes write_event() of builtin-record.c
. And changed write_event() sometimes doesn't stop with perf
lock rec.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
[ that commit also causes perf record to not be Ctrl-C-able,
  and it's concetually wrong to parse the data at record time
  (unconditionally - even when not needed), as we eventually
  want to be able to do zero-copy recording, at least for
  non-archive recordings.  ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9034522..eea5691 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -113,24 +113,16 @@ static void write_output(void *buf, size_t size)
 
 static void write_event(event_t *buf, size_t size)
 {
-	size_t processed_size = buf->header.size;
-	event_t *ev = buf;
-
-	do {
-		/*
-		* Add it to the list of DSOs, so that when we finish this
-		 * record session we can pick the available build-ids.
-		 */
-		if (ev->header.type == PERF_RECORD_MMAP) {
-			struct list_head *head = &dsos__user;
-			if (ev->header.misc == 1)
-				head = &dsos__kernel;
-			__dsos__findnew(head, ev->mmap.filename);
-		}
-
-		ev = ((void *)ev) + ev->header.size;
-		processed_size += ev->header.size;
-	} while (processed_size < size);
+	/*
+	* Add it to the list of DSOs, so that when we finish this
+	 * record session we can pick the available build-ids.
+	 */
+	if (buf->header.type == PERF_RECORD_MMAP) {
+		struct list_head *head = &dsos__user;
+		if (buf->mmap.header.misc == 1)
+			head = &dsos__kernel;
+		__dsos__findnew(head, buf->mmap.filename);
+	}
 
 	write_output(buf, size);
 }
