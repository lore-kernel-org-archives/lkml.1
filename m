Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0BOPru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:47:50 -0500
Received: from www.tglx.de ([62.245.132.106]:38851 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab0BOPrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:47:46 -0500
Date: Mon, 15 Feb 2010 16:47:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.33
Message-ID: <alpine.LFD.2.00.1002151646170.2811@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Peter Zijlstra (1):
      hrtimer, softirq: Fix hrtimer->softirq trampoline


 kernel/softirq.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index a09502e..7c1a67e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -500,22 +500,17 @@ EXPORT_SYMBOL(tasklet_kill);
  */
 
 /*
- * The trampoline is called when the hrtimer expires. If this is
- * called from the hrtimer interrupt then we schedule the tasklet as
- * the timer callback function expects to run in softirq context. If
- * it's called in softirq context anyway (i.e. high resolution timers
- * disabled) then the hrtimer callback is called right away.
+ * The trampoline is called when the hrtimer expires. It schedules a tasklet
+ * to run __tasklet_hrtimer_trampoline() which in turn will call the intended
+ * hrtimer callback, but from softirq context.
  */
 static enum hrtimer_restart __hrtimer_tasklet_trampoline(struct hrtimer *timer)
 {
 	struct tasklet_hrtimer *ttimer =
 		container_of(timer, struct tasklet_hrtimer, timer);
 
-	if (hrtimer_is_hres_active(timer)) {
-		tasklet_hi_schedule(&ttimer->tasklet);
-		return HRTIMER_NORESTART;
-	}
-	return ttimer->function(timer);
+	tasklet_hi_schedule(&ttimer->tasklet);
+	return HRTIMER_NORESTART;
 }
 
 /*
