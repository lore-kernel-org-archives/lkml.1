Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYGLPcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYGLPcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 11:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYGLPb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 11:31:57 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41457 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYGLPb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 11:31:57 -0400
Date: Sat, 12 Jul 2008 19:35:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rui.zhang@intel.com, harbour@sfinx.od.ua,
       pavel@ucw.cz, rjw@sisk.pl
Subject: [PATCH] workqueues: queue_work() can use queue_work_on()
Message-ID: <20080712153516.GB603@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712153234.GA603@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712153234.GA603@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_work() can use queue_work_on() to avoid the code duplication.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~WQ_2_QWON_FACTOR	2008-07-12 19:11:39.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-07-12 19:19:23.000000000 +0400
@@ -159,14 +159,11 @@ static void __queue_work(struct cpu_work
  */
 int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret = 0;
+	int ret;
+
+	ret = queue_work_on(get_cpu(), wq, work);
+	put_cpu();
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, get_cpu()), work);
-		put_cpu();
-		ret = 1;
-	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);

