Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXITMMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXITMMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXITMMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:12:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60748 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbXITMMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:12:30 -0400
Date: Thu, 20 Sep 2007 16:16:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>, Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v5)
Message-ID: <20070920121601.GA135@tv-sign.ru>
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com> <46D7C23F.7020509@linux.vnet.ibm.com> <20070831143535.2e4709c7@localhost.localdomain> <20070912171816.f0993440.akpm@linux-foundation.org> <20070915204239.4a6af65e@localhost.localdomain> <20070918002339.4a989377@localhost.localdomain> <20070919232054.77c271aa.akpm@linux-foundation.org> <46F23550.6050209@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F23550.6050209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Balbir Singh wrote:
>
> Andrew Morton wrote:
> > On Tue, 18 Sep 2007 00:23:39 +0200 Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> > 
> >> TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
> >> the basic and extended accounting.  With this patch,
> >> TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
> >> of a thread group.  This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
> >> fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
> >> (http://guichaz.free.fr/misc/iotop.py).
> > 
> > This patch conflicts somewhat with
> > add-scaled-time-to-taskstats-based-process-accounting.patch
> > 
> > I fixed it up like this:
> > 
> > void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
> > {
> > 	if (task->flags & PF_SUPERPRIV)
> > 		stats->ac_flag |= ASU;
> > 	if (task->flags & PF_DUMPCORE)
> > 		stats->ac_flag |= ACORE;
> > 	if (task->flags & PF_SIGNALED)
> > 		stats->ac_flag |= AXSIG;
> > 	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
> > 		/*
> > 		 * Threads are created by do_fork() and don't exec but not in
> > 		 * the AFORK sense, as the latter involves fork(2).
> > 		 */
> > 		stats->ac_flag |= AFORK;
> > 
> > 	stats->ac_utimescaled +=
> > 		cputime_to_msecs(task->utimescaled) * USEC_PER_MSEC;
> > 	stats->ac_stimescaled +=
> > 		cputime_to_msecs(task->stimescaled) * USEC_PER_MSEC;
> > 	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
> > 	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
> > 	stats->ac_minflt += task->min_flt;
> > 	stats->ac_majflt += task->maj_flt;
> > }
> > 
> > (note the s/=/+=/ in there) but it all needs reviewing and checking and
> > testing please.
> 
> Andrew,
> 
> Thanks for reviewing the patchset, this patch is on my review and test
> queue (which has gotten rather long of late). I'll test it further and
> get back.

I still think this version is very wrong. It makes the ->signal->stats
absolutely meaningless. Quoting myself:

	On 09/18, Guillaume Chazarain wrote:
	>
	> @@ -508,7 +543,7 @@ void taskstats_exit(struct task_struct *
	>    if (!stats)
	>            goto err;
	>
	> -  memcpy(stats, tsk->signal->stats, sizeof(*stats));
	> +  fill_tgid(tsk->pid, tsk, stats);

	No, no, this is wrong.

	tsk->signal->stats contains the accumulated info about the already exited
	threads, we shouldn't throw it out.

	Also, fill_tgid() doesn't make sense here, current is the last live sub-thread.

Oleg.

