Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZIUJCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZIUJCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZIUJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:02:07 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:59837 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbZIUJCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:02:06 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [BUG] events process running on wrong cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com>
References: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 11:02:56 +0200
Message-Id: <1253523777.8439.155.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 10:51 +0200, Heiko Carstens wrote:
> Hi,
> 
> with todays git from time to time I get this (s390 defconfig):

Yep, I messed up..

Does your kernel contain the below?


---
commit 3f04e8cd5b24727a2500f8ab8f3de730ba47b02c
Author: Mike Galbraith <efault@gmx.de>
Date:   Sat Sep 19 16:52:35 2009 +0200

    sched: Re-add lost cpu_allowed check to sched_fair.c::select_task_rq_fair()
    
    While doing some testing, I pinned mplayer, only to find it
    following X around like a puppy. Looking at commit c88d591, I found
    a cpu_allowed check that went AWOL.  I plugged it back in where it
    looks like it needs to go, and now when I say "sit, stay!", mplayer
    obeys again.
    
    'c88d591 sched: Merge select_task_rq_fair() and
    sched_balance_self()' accidentally dropped the check, causing
    wake_affine() to pull pinned tasks - put it back.
    
    [ v2: use a cheaper version from Peter ]
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 29b35a7..566e3bb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1339,7 +1339,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS))
+		if (sched_feat(AFFINE_WAKEUPS) &&
+		    cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}


