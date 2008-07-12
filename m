Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYGLPlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYGLPlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 11:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYGLPlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 11:41:44 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42791 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYGLPln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 11:41:43 -0400
Date: Sat, 12 Jul 2008 19:45:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rui.zhang@intel.com, harbour@sfinx.od.ua,
       pavel@ucw.cz, rjw@sisk.pl
Subject: [PATCH] workqueues: schedule_on_each_cpu() can use schedule_work_on()
Message-ID: <20080712154500.GC603@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712153234.GA603@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712153234.GA603@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_on_each_cpu() can use schedule_work_on() to avoid the code
duplication.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~WQ_3_SOEC_QWON	2008-07-12 19:19:23.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-07-12 19:40:57.000000000 +0400
@@ -689,8 +689,7 @@ int schedule_on_each_cpu(work_func_t fun
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
 		INIT_WORK(work, func);
-		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
-		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
+		schedule_work_on(cpu, work);
 	}
 	for_each_online_cpu(cpu)
 		flush_work(per_cpu_ptr(works, cpu));

