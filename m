Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZFZPx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZFZPx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbZFZPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:52:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:55626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506AbZFZPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:52:47 -0400
Date: Fri, 26 Jun 2009 15:52:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246014623.31755.195.camel@twins>
References: <1246014623.31755.195.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Complete counter swap
Message-ID: <tip-19d2e755436054dfc2be640bffc32e427c37ac3d@git.kernel.org>
Git-Commit-ID: 19d2e755436054dfc2be640bffc32e427c37ac3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 26 Jun 2009 15:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19d2e755436054dfc2be640bffc32e427c37ac3d
Gitweb:     http://git.kernel.org/tip/19d2e755436054dfc2be640bffc32e427c37ac3d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 26 Jun 2009 13:10:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Jun 2009 17:48:54 +0200

perf_counter: Complete counter swap

Complete the counter swap by indeed switching the times too and
updating the userpage after modifying the counter values.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1246014623.31755.195.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f2f2326..66ab1e9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1048,9 +1048,14 @@ static void __perf_counter_sync_stat(struct perf_counter *counter,
 	value = atomic64_xchg(&counter->count, value);
 	atomic64_set(&next_counter->count, value);
 
+	swap(counter->total_time_enabled, next_counter->total_time_enabled);
+	swap(counter->total_time_running, next_counter->total_time_running);
+
 	/*
-	 * XXX also sync time_enabled and time_running ?
+	 * Since we swizzled the values, update the user visible data too.
 	 */
+	perf_counter_update_userpage(counter);
+	perf_counter_update_userpage(next_counter);
 }
 
 #define list_next_entry(pos, member) \
