Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYGLP3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYGLP3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 11:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGLP3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 11:29:33 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40129 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYGLP3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 11:29:32 -0400
Date: Sat, 12 Jul 2008 19:32:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rui.zhang@intel.com, harbour@sfinx.od.ua,
       pavel@ucw.cz, rjw@sisk.pl
Subject: [PATCH] pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
Message-ID: <20080712153234.GA603@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11, Andrew Morton wrote:
>
> +queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
> +{
> +	int ret = 0;
> +
> +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> +		BUG_ON(!list_empty(&work->entry));
> +		preempt_disable();
> +		__queue_work(wq_per_cpu(wq, cpu), work);
> +		preempt_enable();

The comment above __queue_work() is wrong, we don't need to disable
preemtion.

What it actually means is: the caller of __queue_work() must ensure
we can't race with CPU_DEAD, but preempt_disable() can't help for
queue_work_on(). CPU can die even before preempt_disable().

Remove preempt_disable() and update the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~WQ_1_QWON_CLEANUP	2008-07-12 19:04:48.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-07-12 19:11:39.000000000 +0400
@@ -137,7 +137,6 @@ static void insert_work(struct cpu_workq
 	wake_up(&cwq->more_work);
 }
 
-/* Preempt must be disabled. */
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
@@ -180,7 +179,8 @@ EXPORT_SYMBOL_GPL(queue_work);
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
- * We queue the work to a specific CPU
+ * We queue the work to a specific CPU, the caller must ensure it
+ * can't go away.
  */
 int
 queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
@@ -189,9 +189,7 @@ queue_work_on(int cpu, struct workqueue_
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		preempt_disable();
 		__queue_work(wq_per_cpu(wq, cpu), work);
-		preempt_enable();
 		ret = 1;
 	}
 	return ret;

