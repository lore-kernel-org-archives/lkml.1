Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbZGABgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbZGABgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763906AbZGABge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:36:34 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:43475
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763047AbZGABgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:36:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=D8OLx+2e5EmeoLI0Bd56F6SD1ZH6PplYYsEhMpq7HYL7KKQftgcPscU/Buw0lGqx;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <B99DC9EB-9502-4E31-B829-6EB7EFC6212C@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: CFS Scheduler : Period : for NCPUs : Code Suggestion Change
Date: Tue, 30 Jun 2009 18:36:33 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79e70d1a6e19a7d34867a89f790c2fcdaa350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        This is NOT A PATCH.

	PLEASE include my email in the reply as I am not currently on
	the linux kernel mail alias.

	This code snap is grabbed from what is believed to be a semi-current
	OS source (fxr.watson.org) comparison webpage.

	Upon a quick CFS scheduler code walk, increasing the period
	should ALSO be dependent on the number of online/active CPUs.

	The period should be adjusted based on the number of
	online CPUs. This change allows NCPUs * tasks without
	changing/increasing the period.

	On first thought NR_CPUS should give the number of cpu on
	the system, however, this may be different from the number of
	CPUs online, thus..

	Change #1: place after line 425
	int cpu, ncpu;


	Change #2: place before line 427
	for_each_online_cpu(cpu) {
		ncpu++;
         }
	nr_running /=  ncpu;
	

	This may not be from from the latest source, but should be accurate.

	sched_fair.c :

   415  * The idea is to set a period in which each task runs once.
   416  *
   417  * When there are too many tasks (sysctl_sched_nr_latency) we  
have to stretch
   418  * this period because otherwise the slices get too small.
   419  *
   420  * p = (nr <= nl) ? l : l*nr/nl
   421  */
   422 static u64 __sched_period(unsigned long nr_running)
   423 {
   424         u64 period = sysctl_sched_latency;
   425         unsigned long nr_latency = sched_nr_latency;
   426

   427         if (unlikely(nr_running > nr_latency)) {
   428                 period = sysctl_sched_min_granularity;
   429                 period *= nr_running;
   430         }
   431
   432         return period;
   433 }


   435 /*
   436  * We calculate the wall-time slice from the period by taking a  
part
   437  * proportional to the weight.
   438  *
   439  * s = p*P[w/rw]
   440  */
   441 static u64 sched_slice(struct cfs_rq *cfs_rq, struct  
sched_entity *se)
   442 {
   443         unsigned long nr_running = cfs_rq->nr_running;
   444
   445         if (unlikely(!se->on_rq))
   446                 nr_running++;
   447
   448         return calc_delta_weight(__sched_period(nr_running), se);
   449 }
   450


		Thank you, Mitchell Erblich

	
