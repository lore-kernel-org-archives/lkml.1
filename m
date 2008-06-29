Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYF2Oq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYF2Oq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbYF2Oqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:46:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41641 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760410AbYF2Oqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:46:46 -0400
Date: Sun, 29 Jun 2008 18:49:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] workqueues: schedule_on_each_cpu: use flush_work()
Message-ID: <20080629144927.GA4350@tv-sign.ru>
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

--- 26-rc2/kernel/workqueue.c~WQ_3_USE_FLUSH_WORK	2008-06-29 18:20:33.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-06-29 18:34:06.000000000 +0400
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

