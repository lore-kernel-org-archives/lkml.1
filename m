Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbXEYDVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbXEYDVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXEYDVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:21:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:34737 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbXEYDVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:21:33 -0400
Message-ID: <4656564D.5030307@windriver.com>
Date: Thu, 24 May 2007 22:21:49 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.21 hang in cancel_rearming_delayed_workqueue()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 03:21:32.0346 (UTC) FILETIME=[CAC591A0:01C79E7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a problem with the calling cancel_rearming_delayed_work if the 
timer was not yet active.

I see this problem when netpoll_cleanup() is called without having done 
any work because it had not processed any packets yet.  The problem 
appears to be a result of the loop check 
while(!cancel_delayed_work(dwork)).    This endlessly loops because 
del_timer_sync() can return 0 or 1 for success which is passed back as a 
result to the final invariant check for the loop.  In this particular 
case zero will always be returned because the timer is not active.

It is possible that the problem exists else where, but I thought I would 
ask if this is expected?

#0  del_timer_sync (timer=0xc7ed90f8) at kernel/timer.c:530
#1  0xc012f08e in cancel_rearming_delayed_workqueue (wq=0xc7fee800,
   dwork=0xc7ed90e8) at include/linux/workqueue.h:201
#2  0xc012f0af in cancel_rearming_delayed_work (dwork=0x20)
   at kernel/workqueue.c:680
#3  0xc0312f78 in netpoll_cleanup (np=0xc880bf40) at net/core/netpoll.c:784

Possible fix.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Index: linux-2.6.21/kernel/workqueue.c
===================================================================
--- linux-2.6.21.orig/kernel/workqueue.c
+++ linux-2.6.21/kernel/workqueue.c
@@ -666,7 +666,7 @@ EXPORT_SYMBOL(flush_scheduled_work);
void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
                                      struct delayed_work *dwork)
{
-       while (!cancel_delayed_work(dwork))
+       while (cancel_delayed_work(dwork) > 0)
               flush_workqueue(wq);
}
EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);




Thanks,
Jason.
