Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXLFCbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXLFCbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXLFCar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:30:47 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42047 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756809AbXLFCap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:30:45 -0500
Message-Id: <20071206021906.632232033@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 00:00:01 -0800
Subject: [PATCH 1/3] stopmachine semaphore to mutex
Message-Id: <20071206021857.826386004@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Content-Disposition: inline; filename=stopmachine_semaphore_to_mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's called stopmachine_mutex now, but it's a semaphore. So make it
a "struct mutex" .

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/stop_machine.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.23/kernel/stop_machine.c
===================================================================
--- linux-2.6.23.orig/kernel/stop_machine.c
+++ linux-2.6.23/kernel/stop_machine.c
@@ -29,7 +29,7 @@ enum stopmachine_state {
 static enum stopmachine_state stopmachine_state;
 static unsigned int stopmachine_num_threads;
 static atomic_t stopmachine_thread_ack;
-static DECLARE_MUTEX(stopmachine_mutex);
+static DEFINE_MUTEX(stopmachine_mutex);
 
 static int stopmachine(void *cpu)
 {
@@ -177,7 +177,7 @@ struct task_struct *__stop_machine_run(i
 	smdata.data = data;
 	init_completion(&smdata.done);
 
-	down(&stopmachine_mutex);
+	mutex_lock(&stopmachine_mutex);
 
 	/* If they don't care which CPU fn runs on, bind to any online one. */
 	if (cpu == NR_CPUS)
@@ -193,7 +193,7 @@ struct task_struct *__stop_machine_run(i
 		wake_up_process(p);
 		wait_for_completion(&smdata.done);
 	}
-	up(&stopmachine_mutex);
+	mutex_unlock(&stopmachine_mutex);
 	return p;
 }
 

-- 
