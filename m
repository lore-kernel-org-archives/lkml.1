Return-Path: <linux-kernel-owner+w=401wt.eu-S965072AbXBVA21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072AbXBVA21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965073AbXBVA21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:28:27 -0500
Received: from www.osadl.org ([213.239.205.134]:33841 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965072AbXBVA20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:28:26 -0500
Subject: [PATCH] Fix posix-cpu-timer breakage caused by stale p->last_ran
	value
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Ken Chen <kenneth.w.chen@intel.com>, balducci@units.it,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20070221104747.3cb0da32.akpm@linux-foundation.org>
References: <20070221104747.3cb0da32.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 01:33:29 +0100
Message-Id: <1172104409.25076.165.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Problem description at:
http://bugzilla.kernel.org/show_bug.cgi?id=8048

Commit b18ec80396834497933d77b81ec0918519f4e2a7 
    [PATCH] sched: improve migration accuracy
optimized the scheduler time calculations, but broke posix-cpu-timers.

The problem is that the p->last_ran value is not updated after a context
switch. So a subsequent call to current_sched_time() calculates with a
stale p->last_ran value, i.e. accounts the full time, which the task was
scheduled away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3566,7 +3566,7 @@ switch_tasks:
 
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
-		next->timestamp = now;
+		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;



