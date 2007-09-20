Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXITIzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXITIzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbXITIz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:55:28 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:48426 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXITIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:55:27 -0400
Message-ID: <46F23550.6050209@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2007 14:24:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Guillaume Chazarain <guichaz@yahoo.fr>, Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v5)
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com> <46D7C23F.7020509@linux.vnet.ibm.com> <20070831143535.2e4709c7@localhost.localdomain> <20070912171816.f0993440.akpm@linux-foundation.org> <20070915204239.4a6af65e@localhost.localdomain> <20070918002339.4a989377@localhost.localdomain> <20070919232054.77c271aa.akpm@linux-foundation.org>
In-Reply-To: <20070919232054.77c271aa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 18 Sep 2007 00:23:39 +0200 Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> 
>> TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
>> the basic and extended accounting.  With this patch,
>> TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
>> of a thread group.  This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
>> fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
>> (http://guichaz.free.fr/misc/iotop.py).
> 
> This patch conflicts somewhat with
> add-scaled-time-to-taskstats-based-process-accounting.patch
> 
> I fixed it up like this:
> 
> void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
> {
> 	if (task->flags & PF_SUPERPRIV)
> 		stats->ac_flag |= ASU;
> 	if (task->flags & PF_DUMPCORE)
> 		stats->ac_flag |= ACORE;
> 	if (task->flags & PF_SIGNALED)
> 		stats->ac_flag |= AXSIG;
> 	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
> 		/*
> 		 * Threads are created by do_fork() and don't exec but not in
> 		 * the AFORK sense, as the latter involves fork(2).
> 		 */
> 		stats->ac_flag |= AFORK;
> 
> 	stats->ac_utimescaled +=
> 		cputime_to_msecs(task->utimescaled) * USEC_PER_MSEC;
> 	stats->ac_stimescaled +=
> 		cputime_to_msecs(task->stimescaled) * USEC_PER_MSEC;
> 	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
> 	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
> 	stats->ac_minflt += task->min_flt;
> 	stats->ac_majflt += task->maj_flt;
> }
> 
> (note the s/=/+=/ in there) but it all needs reviewing and checking and
> testing please.

Andrew,

Thanks for reviewing the patchset, this patch is on my review and test
queue (which has gotten rather long of late). I'll test it further and
get back.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
