Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbZJMM6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbZJMM6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZJMM6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:58:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:53076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759706AbZJMM6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:58:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18h1z1WWMYhRyykac8VJPEHKRmp0RCi2/9aR1ed1p
	2PXrQlqZwJpY9U
Subject: [patch] perf_counter tools: remove expensive old debug code from
 perf top
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 14:57:20 +0200
Message-Id: <1255438640.7173.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: remove expensive old debug code from perf top

Calling gettimeofday() at high frequency is painful for handicapped boxen.
The spot calling gettimeofday() is old unneeded debug code, so remove it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-top.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -870,8 +870,6 @@ static unsigned int mmap_read_head(struc
 	return head;
 }
 
-struct timeval last_read, this_read;
-
 static void mmap_read_counter(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -879,8 +877,6 @@ static void mmap_read_counter(struct mma
 	unsigned char *data = md->base + page_size;
 	int diff;
 
-	gettimeofday(&this_read, NULL);
-
 	/*
 	 * If we're further behind than half the buffer, there's a chance
 	 * the writer will bite our tail and mess up the samples under us.
@@ -891,14 +887,7 @@ static void mmap_read_counter(struct mma
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
@@ -906,8 +895,6 @@ static void mmap_read_counter(struct mma
 		old = head;
 	}
 
-	last_read = this_read;
-
 	for (; old != head;) {
 		event_t *event = (event_t *)&data[old & md->mask];
 


