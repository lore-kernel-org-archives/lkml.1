Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYFSWEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYFSWEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYFSWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:04:10 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:25418 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYFSWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:04:08 -0400
X-IronPort-AV: E=Sophos;i="4.27,674,1204531200"; 
   d="scan'208";a="81790203"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Eli Cohen <eli@dev.mellanox.co.il>, general@lists.openfabrics.org
Subject: wait_for_completion_timeout() spurious failure under heavy load?
X-Message-Flag: Warning: May contain useful information
Date: Thu, 19 Jun 2008 15:04:07 -0700
Message-ID: <ada63s5w088.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jun 2008 22:04:07.0411 (UTC) FILETIME=[65091C30:01C8D258]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the current implementaton of wait_for_completion_timeout()
has a small problem under very high load for the common pattern:

	if (!wait_for_completion_timeout(&done, timeout))
		/* handle failure */

because the implementation very roughly does (lots of code deleted to
show the basic flow):

	static inline long __sched
	do_wait_for_common(struct completion *x, long timeout, int state)
	{
		if (x->done)
			return timeout;

		do {
			timeout = schedule_timeout(timeout);
	
			if (!timeout)
				return timeout;
	
		} while (!x->done);
	
		return timeout;
	}

so if the system is very busy and x->done is not set when
do_wait_for_common() is entered, it is possible that the first call to
schedule_timeout() returns 0 because the task doing wait_for_completion
doesn't get rescheduled for a long time, even if it is woken up early
enough.  In this case, wait_for_completion_timeout() returns 0 without
even checking x->done again, and the code above falls into its failure
case purely for scheduler reasons, even if the hardware event or
whatever was being waited for happened early enough.

So would it make sense to add an extra test to do_wait_for() in the
timeout case and, say, return 1 if x->done is actually set?  Something
like the patch below?

A quick audit (not exhaustive) of wait_for_completion_timeout() callers
seems to indicate that no one actually cares about the return value in
the success case -- they just test for 0 (timed out) versus non-zero
(wait succeeded).

Thanks,
  Roland

diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..3d04ec1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4405,7 +4405,12 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 			spin_lock_irq(&x->wait.lock);
 			if (!timeout) {
 				__remove_wait_queue(&x->wait, &wait);
-				return timeout;
+				if (x->done) {
+					x->done--;
+					return 1;
+				} else {
+					return 0;
+				}
 			}
 		} while (!x->done);
 		__remove_wait_queue(&x->wait, &wait);
