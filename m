Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbYD0RvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbYD0RvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbYD0Ruw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:50:52 -0400
Received: from www.tglx.de ([62.245.132.106]:57634 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbYD0Ruv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:50:51 -0400
Date: Sun, 27 Apr 2008 19:50:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT pull] hrtimer fixes
Message-ID: <alpine.LFD.1.10.0804271947000.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer fixes from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

This fixes a long standing hrtimer reprogramming bug.

Thanks,
	tglx
---
Bodo Stroesser (1):
      hrtimer: timeout too long when using HRTIMER_CB_SOFTIRQ

 kernel/hrtimer.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f78777a..e379ef0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1080,8 +1080,19 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
 			 * If the timer was rearmed on another CPU, reprogram
 			 * the event device.
 			 */
-			if (timer->base->first == &timer->node)
-				hrtimer_reprogram(timer, timer->base);
+			struct hrtimer_clock_base *base = timer->base;
+
+			if (base->first == &timer->node &&
+			    hrtimer_reprogram(timer, base)) {
+				/*
+				 * Timer is expired. Thus move it from tree to
+				 * pending list again.
+				 */
+				__remove_hrtimer(timer, base,
+						 HRTIMER_STATE_PENDING, 0);
+				list_add_tail(&timer->cb_entry,
+					      &base->cpu_base->cb_pending);
+			}
 		}
 	}
 	spin_unlock_irq(&cpu_base->lock);
