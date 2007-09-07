Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXIGXhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXIGXhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXIGXhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:37:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42092 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbXIGXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:37:07 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200709072337.l87Nbv7j430732@sabah.engr.sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
To: balbir@linux.vnet.ibm.com
Date: Fri, 7 Sep 2007 16:37:57 -0700 (PDT)
Cc: guichaz@yahoo.fr (Guillaume Chazarain),
       akpm@linux-foundation.org (Andrew Morton),
       linux-kernel@vger.kernel.org (Linux Kernel Mailing List),
       jlan@cthulhu.engr.sgi.com (Jay Lan)
In-Reply-To: <46D7C23F.7020509@linux.vnet.ibm.com> from "Balbir Singh" at Aug 31, 2007 12:54:47 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Aug 31 00:24:47 2007, balbir@linux.vnet.ibm.com wrote:
> 
> Jonathan Lim wrote:
> > On Sat Aug 25 21:58:44 2007, balbir@linux.vnet.ibm.com wrote:
> >>> Also, I don't understand why the code to update btime:
> >>>
> >>>         /* calculate task elapsed time in timespec */
> >>>         do_posix_clock_monotonic_gettime(&uptime);
> >>>         ts = timespec_sub(uptime, tsk->start_time);
> >>> 	...
> >>>         stats->ac_btime = get_seconds() - ts.tv_sec;
> >>>
> >>> does not simply use tsk->start_time or tsk->real_start_time without
> >>> comparing it to the current time.
> >> From what I understand, task->start_time and task->real_start_time
> >> are taken from the realtime clock. The accounting in CSA seems
> >> to be very similar to the accounting done in do_acct_process()
> >> (kernel/acct.c).
> > 
> > In CSA 3.0 ...
> > 
> > csa_acct_eop(int exitcode, struct task_struct *p)
> > 
> >         csa->ac_btime = boottime +
> >                         ((p->start_time.tv_nsec < NSEC_PER_SEC/2) ?
> >                          p->start_time.tv_sec :
> >                          p->start_time.tv_sec +1);
> > 
> > where 
> > 
> >         do_posix_clock_monotonic_gettime(&uptime);
> >         boottime = xtime.tv_sec - uptime.tv_sec;
> > 
> > In an upcoming version of CSA ...
> > 
> > csa_acct_eop(struct taskstats *p)
> > 
> >         csa->ac_btime = p->ac_btime;
> > 
> > where
> > 
> >         do_posix_clock_monotonic_gettime(&uptime);
> >         ts = uptime - tsk->start_time;
> >         p->ac_btime = get_seconds() - ts.tv_sec;
> >                     = xtime.tv_sec - (uptime - tsk->start_time);
> >                     = (xtime.tv_sec - uptime) + tsk->start_time;
> > 
> > So they're basically equivalent.
> 
> Excellent, so can Guillaume change ac_btime to be just tsk->start_time?

I don't think so.  Current time (xtime) is relative to the epoch; uptime and
tsk->start_time (jiffies) are both relative to some boot time.  So you need to
subtract uptime from xtime to get the boot time relative to the epoch, then add
tsk->start_time.  The result is what ac_btime should be set to.

I think his recent changes are as follows:

--- a/kernel/tsacct.c   Fri Aug 31 01:42:23 2007 -0700
+++ b/kernel/tsacct.c   Tue Aug 28 20:35:27 2007 +0200
...
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_times(struct taskstats *stats, struct task_struct *task)
...
-       ts = timespec_sub(uptime, tsk->start_time);
+       ts = timespec_sub(uptime, task->start_time);
...
-       stats->ac_btime = get_seconds() - ts.tv_sec;
...
+       stats->ac_btime = get_seconds() - ts.tv_sec;

So really no different from before, which is correct.

Jonathan
