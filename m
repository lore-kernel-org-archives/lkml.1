Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZGIJYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZGIJYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZGIJYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:24:32 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:55598 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZGIJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:24:32 -0400
Date: Thu, 9 Jul 2009 11:24:26 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] timer stats: fix quick check optimization
Message-ID: <20090709092426.GA4943@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit 507e1231 "timer stats: Optimize by adding quick check to avoid
function calls" added one wrong check so that one unnecessary function call
isn't elimated.
time_stats_account_hrtimer() checks if timer->start_pid isn't initialized
in order to find out if timer_stats_update_stats() should be called.
However start_pid is initialized with -1 instead of 0, so that the function
call always happens.
Check timer->start_site like in timer_stats_account_timer() to fix this.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/hrtimer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -448,7 +448,7 @@ extern void timer_stats_update_stats(voi
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
-	if (likely(!timer->start_pid))
+	if (likely(!timer->start_site))
 		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
