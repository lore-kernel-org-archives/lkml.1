Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYD2I45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYD2I45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYD2I4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:56:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:36098 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbYD2I4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:56:47 -0400
Message-ID: <4816D438.3040301@windriver.com>
Date: Tue, 29 Apr 2008 16:54:32 +0900
From: Andrew Liu <shengping.liu@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: Remove redundant function invocation
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 08:56:12.0129 (UTC) FILETIME=[DFB44D10:01C8A9D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue: Remove redundant function invocation

timer_stats_timer_set_start_info is invoked twice,
additionally, the invocation of this function can be
moved to  where it is only called when a delay is
really required.

Signed-off-by: Andrew Liu <shengping.liu@windriver.com>
---

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 00ff4d0..14a7674 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -195,7 +195,6 @@ static void delayed_work_timer_fn(unsigned long __data)
  int queue_delayed_work(struct workqueue_struct *wq,
                         struct delayed_work *dwork, unsigned long delay)
  {
-       timer_stats_timer_set_start_info(&dwork->timer);
         if (delay == 0)
                 return queue_work(wq, &dwork->work);

@@ -219,11 +218,12 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct 
*wq,
         struct timer_list *timer = &dwork->timer;
         struct work_struct *work = &dwork->work;

-       timer_stats_timer_set_start_info(&dwork->timer);
         if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
                 BUG_ON(timer_pending(timer));
                 BUG_ON(!list_empty(&work->entry));

+               timer_stats_timer_set_start_info(&dwork->timer);
+
                 /* This stores cwq for the moment, for the timer_fn */
                 set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
                 timer->expires = jiffies + delay;
@@ -564,7 +564,6 @@ EXPORT_SYMBOL(schedule_work);
  int schedule_delayed_work(struct delayed_work *dwork,
                                         unsigned long delay)
  {
-       timer_stats_timer_set_start_info(&dwork->timer);
         return queue_delayed_work(keventd_wq, dwork, delay);
  }
  EXPORT_SYMBOL(schedule_delayed_work);
@@ -581,7 +580,6 @@ EXPORT_SYMBOL(schedule_delayed_work);
  int schedule_delayed_work_on(int cpu,
                         struct delayed_work *dwork, unsigned long delay)
  {
-       timer_stats_timer_set_start_info(&dwork->timer);
         return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
  }
  EXPORT_SYMBOL(schedule_delayed_work_on);

