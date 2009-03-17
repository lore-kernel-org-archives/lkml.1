Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZCQPUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZCQPUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZCQPTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:19:50 -0400
Received: from web.proformatique.com ([91.194.179.68]:37691 "EHLO
	proformatique.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbZCQPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:19:49 -0400
Date: Tue, 17 Mar 2009 16:18:42 +0100
From: Guillaume Knispel <gknispel@proformatique.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] correct the behavior of printk_timed_ratelimit()
Message-ID: <20090317161842.0059096b@xilun.lan.proformatique.com>
Organization: Proformatique
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
example.  If this caller then don't call printk_timed_ratelimit() until
jiffies == Ja + (1 << 31) + 42 (which can happen as soon as ~ 25 days
later on a 1000 HZ system), printk_timed_ratelimit() will then always
return false to this caller until jiffies loops completely (1 << 31 more
ticks).

The proposed patch makes it only return false if jiffies is in the small
time window starting at the previous call when true was returned and
ending interval_msecs later.  Note that if jiffies loops completely
between two calls to printk_timed_ratelimit(), it will obviously still
wrongly return false, but this is something with a low probability.  If
something completely reliable is needed I guess jiffies_64 must be used
(which the proposed patch does not do).

Cheers,
Guillaume Knispel




Avoid potential situations where printk_timed_ratelimit() can return
false for no good reason during up to (1 << 31) / HZ seconds on 32 bits
computers.  It still can wrongly return false for a duration of up to
interval_msecs if jiffies has been incremented (k * (1 << 32) + e) times
-- with e < msecs_to_jiffies(interval_msecs) -- since the last call
which returned true.

Note that *caller_jiffies now stores jiffies just before the function
returns true, instead of jiffies + msecs_to_jiffies(interval_msecs)
previously.  Also note, if interval_msecs is not constant for a given
caller, that the interval_msecs used is now the one passed for the
current call instead of previously the one used for the last call which
returned true.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>

---
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
