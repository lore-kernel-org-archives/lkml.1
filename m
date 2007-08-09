Return-Path: <linux-kernel-owner+w=401wt.eu-S1764799AbXHIUSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764799AbXHIUSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbXHIUSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:18:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41452 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763844AbXHIUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:18:17 -0400
Date: Thu, 9 Aug 2007 21:17:20 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: silly df numbers on 32bit extN
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708092108540.10254@blonde.wat.veritas.com>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBhLnAuemlqbHN0cmFAY2hlbGxvLm5sAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Andrew Morton wrote:
> 
> +lib-make-percpu_counter_add-take-s64.patch

lib-make-percpu_counter_add-take-s64.patch looks sensible, but it doesn't
actually work on 32-bit architectures: several users of percpu_counter_add
are passing -unsignedlong as the amount, which is not promoted to s64 in
the desired way, so "df" on extN filesystems is showing silly numbers.

The hack below (say long instead of s64 or s32) may be good as hotfix for
2.6.23-rc2-mm1, but is probably the worst of solutions.  Perhaps take-s64
should be reverted, perhaps there should be a percpu_counter_sub and the
filesystems use that instead of saying -unsignedlong, perhaps they should
use a cast or a long or an s64.  I don't know, but here's this for now...

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/percpu_counter.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- 2.6.23-rc2-mm1/include/linux/percpu_counter.h	2007-08-09 13:15:35.000000000 +0100
+++ linux/include/linux/percpu_counter.h	2007-08-09 20:34:23.000000000 +0100
@@ -37,7 +37,7 @@ void percpu_counter_set(struct percpu_co
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
-static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
+static inline void percpu_counter_add(struct percpu_counter *fbc, long amount)
 {
 	__percpu_counter_add(fbc, amount, FBC_BATCH);
 }
@@ -96,11 +96,16 @@ static inline void percpu_counter_set(st
 	fbc->count = amount;
 }
 
-#define __percpu_counter_add(fbc, amount, batch) \
-	percpu_counter_add(fbc, amount)
+static inline void
+__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+{
+	preempt_disable();
+	fbc->count += amount;
+	preempt_enable();
+}
 
 static inline void
-percpu_counter_add(struct percpu_counter *fbc, s64 amount)
+percpu_counter_add(struct percpu_counter *fbc, long amount)
 {
 	preempt_disable();
 	fbc->count += amount;
