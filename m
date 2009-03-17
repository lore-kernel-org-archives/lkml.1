Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZCQQGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZCQQGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZCQQGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:06:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:55420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbZCQQGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:06:10 -0400
Date: Tue, 17 Mar 2009 16:03:23 GMT
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       gknispel@proformatique.com, drepper@redhat.com, tglx@linutronix.de,
       akpm@osdl.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       gknispel@proformatique.com, drepper@redhat.com, tglx@linutronix.de,
       akpm@osdl.org, mingo@elte.hu
In-Reply-To: <20090317161842.0059096b@xilun.lan.proformatique.com>
References: <20090317161842.0059096b@xilun.lan.proformatique.com>
Subject: [tip:core/printk] printk: correct the behavior of printk_timed_ratelimit()
Message-ID: <tip-f2d28a2ebcb525a6ec7e2152106ddb385ef52b73@git.kernel.org>
Git-Commit-ID: f2d28a2ebcb525a6ec7e2152106ddb385ef52b73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 16:03:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2d28a2ebcb525a6ec7e2152106ddb385ef52b73
Gitweb:     http://git.kernel.org/tip/f2d28a2ebcb525a6ec7e2152106ddb385ef52b73
Author:     Guillaume Knispel <gknispel@proformatique.com>
AuthorDate: Tue, 17 Mar 2009 16:18:42 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Mar 2009 16:25:28 +0100

printk: correct the behavior of printk_timed_ratelimit()

Impact: fix jiffies-comparison sign-wrap behavior

The behavior provided by printk_timed_ratelimit() is, in some
situations, probably not what a caller would reasonably expect:

bool printk_timed_ratelimit(unsigned long *caller_jiffies,
			unsigned int interval_msecs)
{
	if (*caller_jiffies == 0 || time_after(jiffies, *caller_jiffies)) {
		*caller_jiffies = jiffies + msecs_to_jiffies(interval_msecs);
		return true;
	}
	return false;
}

On a 32 bit computer, if printk_timed_ratelimit() is initially called at
time jiffies == Ja, *caller_jiffies is set to
Ja + msecs_to_jiffies(interval_msecs): let's say Ja + 42 for this
example.

If this caller then doesn't call printk_timed_ratelimit() until
jiffies == Ja + (1 << 31) + 42 (which can happen as soon as ~ 25 days
later on a 1000 HZ system), printk_timed_ratelimit() will then always
return false to this caller until jiffies loops completely (1 << 31 more
ticks).

Ths change makes it only return false if jiffies is in the small
time window starting at the previous call when true was returned and
ending interval_msecs later.  Note that if jiffies loops completely
between two calls to printk_timed_ratelimit(), it will obviously still
wrongly return false, but this is something with a low probability.

If something completely reliable is needed I guess jiffies_64 must be
used (which this change does not do).

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090317161842.0059096b@xilun.lan.proformatique.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/printk.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index e3602d0..2be7199 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1292,8 +1292,11 @@ EXPORT_SYMBOL(printk_ratelimit);
 bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 			unsigned int interval_msecs)
 {
-	if (*caller_jiffies == 0 || time_after(jiffies, *caller_jiffies)) {
-		*caller_jiffies = jiffies + msecs_to_jiffies(interval_msecs);
+	if (*caller_jiffies == 0
+			|| !time_in_range(jiffies, *caller_jiffies,
+					*caller_jiffies
+					+ msecs_to_jiffies(interval_msecs))) {
+		*caller_jiffies = jiffies;
 		return true;
 	}
 	return false;
