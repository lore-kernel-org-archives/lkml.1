Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0BCRWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:22:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:57991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab0BCRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:22:08 -0500
Date: Wed, 3 Feb 2010 17:21:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, ypolyans@princeton.edu, davem@davemloft.net,
       yjwei@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, ypolyans@princeton.edu, davem@davemloft.net,
       yjwei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <1265120401.24455.306.camel@laptop>
References: <1265120401.24455.306.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer, softirq: Fix hrtimer->softirq trampoline
Message-ID: <tip-b9c3032277f756e73f6c673419dc414155e04e46@git.kernel.org>
Git-Commit-ID: b9c3032277f756e73f6c673419dc414155e04e46
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Feb 2010 17:21:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9c3032277f756e73f6c673419dc414155e04e46
Gitweb:     http://git.kernel.org/tip/b9c3032277f756e73f6c673419dc414155e04e46
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Feb 2010 18:08:52 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 3 Feb 2010 18:17:40 +0100

hrtimer, softirq: Fix hrtimer->softirq trampoline

hrtimers callbacks are always done from hardirq context, either the
jiffy tick interrupt or the hrtimer device interrupt.

[ there is currently one exception that can still call a hrtimer
  callback from softirq, but even in that case this will still
  work correctly. ]

Reported-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yury Polyanskiy <ypolyans@princeton.edu>
Tested-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
LKML-Reference: <1265120401.24455.306.camel@laptop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
