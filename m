Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbXDWXQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbXDWXQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXDWXHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:07:30 -0400
Received: from 61.sub-75-208-107.myvzw.com ([75.208.107.61]:38859 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754475AbXDWXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:07:15 -0400
Message-Id: <20070423215711.971562613@goop.org>
References: <20070423215638.563901986@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 14:56:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/25] xen: xen: deal with negative stolen time
Content-Disposition: inline; filename=xen-signed-time.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stolen time should never be negative; if it ever is, it probably
indicates some other bug.  However, if it does happen, then its better
to just clamp it at zero, rather than trying to account for it as a
huge positive number.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/time.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -77,7 +77,7 @@ static void do_stolen_accounting(void)
 {
 	struct vcpu_runstate_info state;
 	struct vcpu_runstate_info *snap;
-	u64 blocked, runnable, offline, stolen;
+	s64 blocked, runnable, offline, stolen;
 	cputime_t ticks;
 
 	get_runstate_snapshot(&state);
@@ -97,6 +97,10 @@ static void do_stolen_accounting(void)
 	   including any left-overs from last time.  Passing NULL to
 	   account_steal_time accounts the time as stolen. */
 	stolen = runnable + offline + __get_cpu_var(residual_stolen);
+
+	if (stolen < 0)
+		stolen = 0;
+
 	ticks = 0;
 	while(stolen >= NS_PER_TICK) {
 		ticks++;
@@ -109,6 +113,10 @@ static void do_stolen_accounting(void)
 	   including any left-overs from last time.  Passing idle to
 	   account_steal_time accounts the time as idle/wait. */
 	blocked += __get_cpu_var(residual_blocked);
+
+	if (blocked < 0)
+		blocked = 0;
+
 	ticks = 0;
 	while(blocked >= NS_PER_TICK) {
 		ticks++;
@@ -127,7 +135,8 @@ unsigned long long xen_sched_clock(void)
 {
 	struct vcpu_runstate_info state;
 	cycle_t now;
-	unsigned long long ret;
+	u64 ret;
+	s64 offset;
 
 	/*
 	 * Ideally sched_clock should be called on a per-cpu basis
@@ -142,9 +151,13 @@ unsigned long long xen_sched_clock(void)
 
 	WARN_ON(state.state != RUNSTATE_running);
 
+	offset = now - state.state_entry_time;
+	if (offset < 0)
+		offset = 0;
+
 	ret = state.time[RUNSTATE_blocked] +
 		state.time[RUNSTATE_running] +
-		(now - state.state_entry_time);
+		offset;
 
 	preempt_enable();
 

-- 

