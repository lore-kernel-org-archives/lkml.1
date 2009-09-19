Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZISSEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZISSEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZISSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:04:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:46110 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZISSEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:04:53 -0400
Date: Sat, 19 Sep 2009 18:04:19 GMT
From: tip-bot for Ian Schram <ischram@telenet.be>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, ischram@telenet.be, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, ischram@telenet.be, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AB3DEE2.3030600@telenet.be>
References: <4AB3DEE2.3030600@telenet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Fix perf_copy_attr() pointer arithmetic
Message-ID: <tip-cdf8073d6b2c6c5a3cd6ce0e6c1297157f7f99ba@git.kernel.org>
Git-Commit-ID: cdf8073d6b2c6c5a3cd6ce0e6c1297157f7f99ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 18:04:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdf8073d6b2c6c5a3cd6ce0e6c1297157f7f99ba
Gitweb:     http://git.kernel.org/tip/cdf8073d6b2c6c5a3cd6ce0e6c1297157f7f99ba
Author:     Ian Schram <ischram@telenet.be>
AuthorDate: Fri, 18 Sep 2009 21:26:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 19:32:55 +0200

perf_counter: Fix perf_copy_attr() pointer arithmetic

There is still some weird code in per_copy_attr(). Which supposedly
checks that all bytes trailing a struct are zero.

It doesn't seem to get pointer arithmetic right. Since it
increments an iterating pointer by sizeof(unsigned long) rather
than 1.

Signed-off-by: Ian Schram <ischram@telenet.be>
[ v2: clean up the messy PTR_ALIGN logic as well. ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org> # for v2.6.31.x
LKML-Reference: <4AB3DEE2.3030600@telenet.be>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d5899b6..cc768ab 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4208,8 +4208,8 @@ done:
 static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 			  struct perf_counter_attr *attr)
 {
-	int ret;
 	u32 size;
+	int ret;
 
 	if (!access_ok(VERIFY_WRITE, uattr, PERF_ATTR_SIZE_VER0))
 		return -EFAULT;
@@ -4234,19 +4234,19 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 
 	/*
 	 * If we're handed a bigger struct than we know of,
-	 * ensure all the unknown bits are 0.
+	 * ensure all the unknown bits are 0 - i.e. new
+	 * user-space does not rely on any kernel feature
+	 * extensions we dont know about yet.
 	 */
 	if (size > sizeof(*attr)) {
-		unsigned long val;
-		unsigned long __user *addr;
-		unsigned long __user *end;
+		unsigned char __user *addr;
+		unsigned char __user *end;
+		unsigned char val;
 
-		addr = PTR_ALIGN((void __user *)uattr + sizeof(*attr),
-				sizeof(unsigned long));
-		end  = PTR_ALIGN((void __user *)uattr + size,
-				sizeof(unsigned long));
+		addr = (void __user *)uattr + sizeof(*attr);
+		end  = (void __user *)uattr + size;
 
-		for (; addr < end; addr += sizeof(unsigned long)) {
+		for (; addr < end; addr++) {
 			ret = get_user(val, addr);
 			if (ret)
 				return ret;
