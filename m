Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYIKDa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYIKDa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYIKDaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:30:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:33106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYIKDae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:30:34 -0400
Date: Wed, 10 Sep 2008 20:28:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       peterz@infradead.org
Subject: [PATCH 1/3] hrtimer: make the futex() system call use the per
 process slack value
Message-ID: <20080910202850.07b2ff45@infradead.org>
In-Reply-To: <20080910202803.42b5f251@infradead.org>
References: <20080910202803.42b5f251@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: make the futex() system call use the per process slack value

This patch makes the futex() system call use the per process
slack value; with this users are able to externally control existing
applications to reduce the wakeup rate.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/futex.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4cd5b43..8af1002 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1296,10 +1296,14 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		if (!abs_time)
 			schedule();
 		else {
+			unsigned long slack;
+			slack = current->timer_slack_ns;
+			if (rt_task(current))
+				slack = 0;
 			hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC,
 						HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
-			hrtimer_set_expires(&t.timer, *abs_time);
+			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
 
 			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
 			if (!hrtimer_active(&t.timer))
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
