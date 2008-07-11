Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYGKJJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYGKJJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYGKJJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:09:38 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:5118 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYGKJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:09:37 -0400
Date: Fri, 11 Jul 2008 11:09:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Glauber <jan.glauber@de.ibm.com>,
       Stefan Weinhuber <wein@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] nohz: don't stop idle tick if softirqs are pending.
Message-ID: <20080711090922.GA4660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] nohz: don't stop idle tick if softirqs are pending.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

In case a cpu goes idle but softirqs are pending only an error message is
printed to the console. It may take a very long time until the pending
softirqs will finally be executed. Worst case would be a hanging system.

With this patch the timer tick just continues and the softirqs will be
executed after the next interrupt. Still a delay but better than a
hanging system.

Currently we have at least two device drivers on s390 which under certain
circumstances schedule a tasklet from process context. This is a reason
why we can end up with pending softirqs when going idle. Fixing these
drivers seems to be non-trivial.
However there is no question that the drivers should be fixed.
This patch shouldn't be considered as a bug fix. It just is intended to
keep a system running even if device drivers are buggy.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/time/tick-sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -228,6 +228,7 @@ void tick_nohz_stop_sched_tick(void)
 			       local_softirq_pending());
 			ratelimit++;
 		}
+		goto end;
 	}
 
 	ts->idle_calls++;
