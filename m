Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYLPVPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYLPVPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYLPVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:15:23 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:41795 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYLPVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:15:22 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 16:15:21 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ENgi8P7FHzmbghvHybOE1JZCYKLDHP+PTnwJIf1pxFqZDzpQ5oPuHAiIO+Of89PX4p
         YO6g40HZz3ynSmGSfS74KBuyRnKFplx6U1glCsmvsqrZ6Sht/epegVT9PGaM9edR1Rxi
         QZndVoIr/msA3fV3KUv3L6pZpk0vVQBunXtf4=
Message-ID: <494818EA.7080807@gmail.com>
Date: Tue, 16 Dec 2008 22:08:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace in
 ring_buffer_time_stamp()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: prevent a trace recursion

After some tests with function graph tracer under x86-32, I saw some recursions
caused by ring_buffer_time_stamp() that calls preempt_enable_no_notrace() which
calls preempt_schedule() which is traced itself.

This patch re-enables preemption without rescheduling.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 822fcd4..a775e46 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -109,7 +109,7 @@ u64 ring_buffer_time_stamp(int cpu)
 	preempt_disable_notrace();
 	/* shift to debug/test normalization and TIME_EXTENTS */
 	time = sched_clock() << DEBUG_SHIFT;
-	preempt_enable_notrace();
+	preempt_enable_no_resched_notrace();
 
 	return time;
 }
-- 
1.6.0.4

