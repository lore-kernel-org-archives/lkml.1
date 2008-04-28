Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbYD1JVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbYD1JVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762508AbYD1JVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:21:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:48000 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762211AbYD1JVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:21:13 -0400
Message-ID: <481588A2.3090706@windriver.com>
Date: Mon, 28 Apr 2008 17:19:46 +0900
From: Andrew Liu <shengping.liu@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: Remove redundant function invocation
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 09:21:12.0214 (UTC) FILETIME=[33695B60:01C8A911]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue: Remove redundant function invocation
       
    timer_stats_timer_set_start_info is invoked twice,
    additionally, the invocation of this function can be moved to
    where it is only called when a delay is really required.
   
    Signed-off-by: Andrew Liu <shengping.liu@windriver.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 00ff4d0..9b50a4d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -195,10 +195,10 @@ static void delayed_work_timer_fn(unsigned long 
__data)
int queue_delayed_work(struct workqueue_struct *wq,
                       struct delayed_work *dwork, unsigned long delay)
{
-       timer_stats_timer_set_start_info(&dwork->timer);
       if (delay == 0)
               return queue_work(wq, &dwork->work);

+       timer_stats_timer_set_start_info(&dwork->timer);
       return queue_delayed_work_on(-1, wq, dwork, delay);
}
EXPORT_SYMBOL_GPL(queue_delayed_work);
@@ -219,11 +219,12 @@ int queue_delayed_work_on(int cpu, struct 
workqueue_struct *wq,
       struct timer_list *timer = &dwork->timer;
       struct work_struct *work = &dwork->work;

-       timer_stats_timer_set_start_info(&dwork->timer);
       if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
               BUG_ON(timer_pending(timer));
               BUG_ON(!list_empty(&work->entry));

+               timer_stats_timer_set_start_info(&dwork->timer);
+                     /* This stores cwq for the moment, for the 
timer_fn */
               set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
               timer->expires = jiffies + delay;
@@ -564,7 +565,6 @@ EXPORT_SYMBOL(schedule_work);
int schedule_delayed_work(struct delayed_work *dwork,
                                       unsigned long delay)
{
-       timer_stats_timer_set_start_info(&dwork->timer);
       return queue_delayed_work(keventd_wq, dwork, delay);
}
EXPORT_SYMBOL(schedule_delayed_work);
@@ -581,7 +581,6 @@ EXPORT_SYMBOL(schedule_delayed_work);
int schedule_delayed_work_on(int cpu,
                       struct delayed_work *dwork, unsigned long delay)
{
-       timer_stats_timer_set_start_info(&dwork->timer);
       return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
}
EXPORT_SYMBOL(schedule_delayed_work_on);

