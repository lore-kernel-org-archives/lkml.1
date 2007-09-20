Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXITGVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXITGVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbXITGV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:21:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757305AbXITGV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:21:26 -0400
Date: Wed, 19 Sep 2007 23:20:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: balbir@linux.vnet.ibm.com, Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v5)
Message-Id: <20070919232054.77c271aa.akpm@linux-foundation.org>
In-Reply-To: <20070918002339.4a989377@localhost.localdomain>
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com>
	<46D7C23F.7020509@linux.vnet.ibm.com>
	<20070831143535.2e4709c7@localhost.localdomain>
	<20070912171816.f0993440.akpm@linux-foundation.org>
	<20070915204239.4a6af65e@localhost.localdomain>
	<20070918002339.4a989377@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 00:23:39 +0200 Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
> the basic and extended accounting.  With this patch,
> TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
> of a thread group.  This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
> fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
> (http://guichaz.free.fr/misc/iotop.py).

This patch conflicts somewhat with
add-scaled-time-to-taskstats-based-process-accounting.patch

I fixed it up like this:

void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
{
	if (task->flags & PF_SUPERPRIV)
		stats->ac_flag |= ASU;
	if (task->flags & PF_DUMPCORE)
		stats->ac_flag |= ACORE;
	if (task->flags & PF_SIGNALED)
		stats->ac_flag |= AXSIG;
	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
		/*
		 * Threads are created by do_fork() and don't exec but not in
		 * the AFORK sense, as the latter involves fork(2).
		 */
		stats->ac_flag |= AFORK;

	stats->ac_utimescaled +=
		cputime_to_msecs(task->utimescaled) * USEC_PER_MSEC;
	stats->ac_stimescaled +=
		cputime_to_msecs(task->stimescaled) * USEC_PER_MSEC;
	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
	stats->ac_minflt += task->min_flt;
	stats->ac_majflt += task->maj_flt;
}

(note the s/=/+=/ in there) but it all needs reviewing and checking and
testing please.
