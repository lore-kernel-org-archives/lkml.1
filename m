Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYFMO0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYFMO0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYFMOZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:25:55 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51100 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538AbYFMOZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:25:54 -0400
Date: Fri, 13 Jun 2008 18:28:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] workqueues: schedule_on_each_cpu: use flush_work()
Message-ID: <20080613142804.GA9168@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change schedule_on_each_cpu() to use flush_work() instead of flush_workqueue(),
this way we don't wait for other work_struct's which can be queued meanwhile.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~WQ_3_USE_FLUSH_WORK	2008-06-13 17:31:54.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-06-13 17:34:05.000000000 +0400
@@ -653,7 +653,8 @@ int schedule_on_each_cpu(work_func_t fun
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
 		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
 	}
-	flush_workqueue(keventd_wq);
+	for_each_online_cpu(cpu)
+		flush_work(per_cpu_ptr(works, cpu));
 	put_online_cpus();
 	free_percpu(works);
 	return 0;

