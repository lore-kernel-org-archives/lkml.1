Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYGKN2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYGKN2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYGKN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:28:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYGKN2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:28:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix bacct_add_tsk()'s use of do_div()
To: jlan@sgi.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 14:28:13 +0100
Message-ID: <20080711132812.8441.66366.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bacct_add_tsk()'s use of do_div() on an s64 by making ac_etime a u64
instead and dividing that.

Possibly this should be guarded lest the interval calculation turn up negative,
but the possible negativity of the result of the division is cast away, and it
shouldn't end up negative anyway.

This was introduced by patch f3cef7a99469afc159fec3a61b42dc7ca5b6824f.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/tsacct.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 4ab1b58..30e877f 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -28,14 +28,14 @@
 void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 {
 	struct timespec uptime, ts;
-	s64 ac_etime;
+	u64 ac_etime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
 	ts = timespec_sub(uptime, tsk->start_time);
-	/* rebase elapsed time to usec */
+	/* rebase elapsed time to usec (should never be negative) */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
 	stats->ac_etime = ac_etime;

