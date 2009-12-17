Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbZLQBUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbZLQBUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763587AbZLQBUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:00 -0500
Received: from kroah.org ([198.145.64.141]:47800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763546AbZLQBTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:59 2009
Message-Id: <20091217011559.541241545@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Feng Tang <feng.tang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [13/90] hrtimer: Fix /proc/timer_list regression
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit 8629ea2eaba8ca0de2e38ce1b4a825e16255976e upstream.

commit 507e1231 (timer stats: Optimize by adding quick check to avoid
function calls) introduced a regression in /proc/timer_list.

/proc/timer_list shows now
 #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
instead of
 #0: <c27d46b0>, tick_sched_timer, S:01, hrtimer_start, swapper/0

Revert the hrtimer quick check for now. The optimization needs more
thought, but this is neither 2.6.32-rc7 nor stable material.

[ tglx: - Removed unrelated changes from the original patch
  	- Prevent unneccesary call to timer_stats_update_stats
	- massaged the changelog ]

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/hrtimer.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -448,7 +448,7 @@ extern void timer_stats_update_stats(voi
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
-	if (likely(!timer->start_site))
+	if (likely(!timer_stats_active))
 		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
@@ -459,8 +459,6 @@ extern void __timer_stats_hrtimer_set_st
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
-	if (likely(!timer_stats_active))
-		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 


