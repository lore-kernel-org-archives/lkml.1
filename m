Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbZD1Ht1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbZD1Ht1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZD1HtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:49:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:11219 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530AbZD1HtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BKOBiLHJTlmlhBSY46giB7bkAiPSYJRy7106XW2dzIZ0PCERiP1t8kWL6nyRoJk7v3
         3GYaBkpfdeHtvOkH8P2/lSgCDrqOu3Cebb2K+NFzUAlHgfBioD/QFQrEKMkuiKirKDOx
         4v9KqH/ju0QLoFqoHfyCutdeoVMocE1yy1uu0=
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 15:49:11 +0800
Message-ID: <e82940b20904280049h329dab44u70ef8e77450a79e4@mail.gmail.com>
Subject: [PATCH] sched: make sure sched_child_runs_first is not fairy tale
From: marywangran <marywangran@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFS scheduler become the main scheduler after 2.6.23.everything is
fair,no starvation,no complexity.The new task would not simply be
queued  at the head to quickly preempt current.according to the code
of kernel 2.6.28,if you clear the STAR_DEBIT bit by sysctl -w
kernel.sched_features=orig_value&~STSRT_DEBIT_bit,child task would not
preempt its father always,and this problem is easier to recur if you
use a father task with lower nice value. my test file is:

/*******child_first.c**********/
#include <sched.h>
#include <sys/types.h>
#include <unistd.h>
int main(int argc,char *argv[])
{
        cpu_set_t mask;
        __CPU_ZERO( &mask );
        __CPU_SET(0, &mask );
        sched_setaffinity( 0, sizeof(mask), &mask );
        int v = atoi(argv[1]);
        nice(v);
        int i = 90000;
        while(i-->0)
        {
                v++;
        }
        if(fork() == 0)
        {
                printf("sub\n");
                exit(0);
        }
        printf("main,%d\n",v);
}
just compile it to child_first and do following:

[root@zhaoya ~]#sysctl -w kernel.sched_features=0
[root@zhaoya ~]#./child_first -20
[root@zhaoya ~]#./child_first -xx
...
[root@zhaoya ~]#./child_first 10000...

after all this,believe your eyes.
  because the code judgeing the condition whether the child should
preempt the father is very LOOSE£¡if the nice value of father is very
low and the nr_running is very small,the cfs_rq->min_vruntime is
always equal with the vruntime of father,so {curr->vruntime <=
se->vruntime}.if the nice value if high,the cfs_rq->min_vruntime is
always little than father so {cfs_rq->min_vruntime <= curr->vruntime}
Signed-off-by: Ya Zhao <marywangran@gmail.com>
---
--- linux-2.6.28.1/kernel/sched_fair.c.orig	2009-04-28 22:26:00.000000000 +0800
+++ linux-2.6.28.1/kernel/sched_fair.c	2009-04-28 22:34:49.000000000 +0800
@@ -1628,12 +1628,13 @@ static void task_new_fair(struct rq *rq,

 	/* 'curr' will be NULL if the child belongs to a different group */
 	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr && curr->vruntime < se->vruntime) {
+			curr && (curr->vruntime <= se->vruntime||cfs_rq->min_vruntime <=
curr->vruntime)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
 		 */
-		swap(curr->vruntime, se->vruntime);
+		if( curr->vruntime < se->vruntime )
+			swap(curr->vruntime, se->vruntime);
 		resched_task(rq->curr);
 	}
