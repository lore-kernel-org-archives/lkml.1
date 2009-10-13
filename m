Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbZJMNfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbZJMNfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbZJMNfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:35:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:58789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759206AbZJMNfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:35:39 -0400
Date: Tue, 13 Oct 2009 13:34:29 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1255438640.7173.1.camel@marge.simson.net>
References: <1255438640.7173.1.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove expensive old debug code from perf top
Message-ID: <tip-f4f0b418188cc7995375acbb54e87c80f21861bd@git.kernel.org>
Git-Commit-ID: f4f0b418188cc7995375acbb54e87c80f21861bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 13:34:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4f0b418188cc7995375acbb54e87c80f21861bd
Gitweb:     http://git.kernel.org/tip/f4f0b418188cc7995375acbb54e87c80f21861bd
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 13 Oct 2009 14:57:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 15:30:15 +0200

perf tools: Remove expensive old debug code from perf top

Calling gettimeofday() at high frequency is painful for handicapped
boxen. The spot calling gettimeofday() is old unneeded debug code,
so remove it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1255438640.7173.1.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c0f69e8..2d8806b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -870,8 +870,6 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
-struct timeval last_read, this_read;
-
 static void mmap_read_counter(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -879,8 +877,6 @@ static void mmap_read_counter(struct mmap_data *md)
 	unsigned char *data = md->base + page_size;
 	int diff;
 
-	gettimeofday(&this_read, NULL);
-
 	/*
 	 * If we're further behind than half the buffer, there's a chance
 	 * the writer will bite our tail and mess up the samples under us.
@@ -891,14 +887,7 @@ static void mmap_read_counter(struct mmap_data *md)
 	 */
 	diff = head - old;
 	if (diff > md->mask / 2 || diff < 0) {
-		struct timeval iv;
-		unsigned long msecs;
-
-		timersub(&this_read, &last_read, &iv);
-		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
-
-		fprintf(stderr, "WARNING: failed to keep up with mmap data."
-				"  Last read %lu msecs ago.\n", msecs);
+		fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
 
 		/*
 		 * head points to a known good entry, start there.
@@ -906,8 +895,6 @@ static void mmap_read_counter(struct mmap_data *md)
 		old = head;
 	}
 
-	last_read = this_read;
-
 	for (; old != head;) {
 		event_t *event = (event_t *)&data[old & md->mask];
 
