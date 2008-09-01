Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYIAO6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYIAO6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYIAO6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:58:46 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36282 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYIAO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:58:45 -0400
Subject: [PATCH] sched_clock: fix NOHZ interaction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <48BABC19.1060509@qumranet.com>
References: <48BABC19.1060509@qumranet.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 16:58:08 +0200
Message-Id: <1220281088.8426.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi, the below fixes it for me..


---
Subject: sched_clock: fix NOHZ interaction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Sep 01 16:44:23 CEST 2008

If HLT stops the TSC, we'll fail to account idle time, thereby inflating the
actual process times. Fix this by re-calibrating the clock against GTOD when 
leaving nohz mode.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/time/tick-sched.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -162,6 +162,8 @@ void tick_nohz_stop_idle(int cpu)
 		ts->idle_lastupdate = now;
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_active = 0;
+
+		sched_clock_idle_wakeup_event(0);
 	}
 }
 
@@ -177,6 +179,7 @@ static ktime_t tick_nohz_start_idle(stru
 	}
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	sched_clock_idle_sleep_event();
 	return now;
 }
 


