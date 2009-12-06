Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZLFNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZLFNES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 08:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZLFNER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 08:04:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:55721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZLFNEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 08:04:16 -0500
Date: Sun, 6 Dec 2009 13:03:44 GMT
From: tip-bot for Frank Rowand <frank.rowand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, frank.rowand@am.sony.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, frank.rowand@am.sony.com,
       mingo@elte.hu
In-Reply-To: <4B05BBAE.2050005@am.sony.com>
References: <4B05BBAE.2050005@am.sony.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockstat: Fix min, max times in /proc/lock_stats
Message-ID: <tip-109d71c6dd52ec08878c2c67eb4c0bd67fcbc80b@git.kernel.org>
Git-Commit-ID: 109d71c6dd52ec08878c2c67eb4c0bd67fcbc80b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  109d71c6dd52ec08878c2c67eb4c0bd67fcbc80b
Gitweb:     http://git.kernel.org/tip/109d71c6dd52ec08878c2c67eb4c0bd67fcbc80b
Author:     Frank Rowand <frank.rowand@am.sony.com>
AuthorDate: Thu, 19 Nov 2009 13:42:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 13:20:00 +0100

lockstat: Fix min, max times in /proc/lock_stats

Fix min, max times in /proc/lock_stats

(1) When collecting lock hold and wait times, if the current minimum
    time is zero, it will be replaced by the next time.

(2) When aggregating minimum and maximum lock hold and wait times
    accross cpus, the values are added, instead of selecting the
    minimum and maximum.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4B05BBAE.2050005@am.sony.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f5dcd36..7a3ae56 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -168,7 +168,7 @@ static void lock_time_inc(struct lock_time *lt, u64 time)
 	if (time > lt->max)
 		lt->max = time;
 
-	if (time < lt->min || !lt->min)
+	if (time < lt->min || !lt->nr)
 		lt->min = time;
 
 	lt->total += time;
@@ -177,8 +177,15 @@ static void lock_time_inc(struct lock_time *lt, u64 time)
 
 static inline void lock_time_add(struct lock_time *src, struct lock_time *dst)
 {
-	dst->min += src->min;
-	dst->max += src->max;
+	if (!src->nr)
+		return;
+
+	if (src->max > dst->max)
+		dst->max = src->max;
+
+	if (src->min < dst->min || !dst->nr)
+		dst->min = src->min;
+
 	dst->total += src->total;
 	dst->nr += src->nr;
 }
