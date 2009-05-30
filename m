Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZE3FAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZE3FAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 01:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZE3FAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 01:00:24 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:58557 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZE3FAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 01:00:23 -0400
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: swetland@google.com,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] nohz: Fix ondemand governor not always ramping up on 100% load.
Date: Fri, 29 May 2009 22:00:19 -0700
Message-Id: <1243659619-9675-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems that perform the context switch with interrupts enabled
(e.g. ARM) get_cpu_idle_time_us could get stuck returning the last
idle time when the cpu is busy. If an interrupt occurs while
switching to the idle thread, and this interrupt wakes up a thread,
need-resched will be set on the idle thread, but since we have not
finished switching to the idle thread tick_nohz_stop_sched_tick will
be called. (idle_cpu is true since the head of the runqueue is the
idle thread, but need_resched returns false since we are still
running in the context of the old thread)

Fix this by not calling tick_nohz_start_idle when returning from an
interrupt while the idle thread is in its schedule phase.
(!ts->inidle)

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..4012da6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -222,7 +222,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
-	now = tick_nohz_start_idle(ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
@@ -242,6 +241,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (!inidle && !ts->inidle)
 		goto end;
 
+	now = tick_nohz_start_idle(ts);
 	ts->inidle = 1;
 
 	if (need_resched())
-- 
1.6.1

