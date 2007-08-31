Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXHaDBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXHaDBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbXHaDBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:01:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43193 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755258AbXHaDBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:01:43 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
To: balbir@linux.vnet.ibm.com
Date: Thu, 30 Aug 2007 20:02:35 -0700 (PDT)
Cc: guichaz@yahoo.fr (Guillaume Chazarain),
       akpm@linux-foundation.org (Andrew Morton),
       linux-kernel@vger.kernel.org (Linux Kernel Mailing List),
       jlan@cthulhu.engr.sgi.com (Jay Lan)
In-Reply-To: <46D10884.6040401@linux.vnet.ibm.com> from "Balbir Singh" at Aug 26, 2007 10:28:44 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat Aug 25 21:58:44 2007, balbir@linux.vnet.ibm.com wrote:
> 
> > Also, I don't understand why the code to update btime:
> > 
> >         /* calculate task elapsed time in timespec */
> >         do_posix_clock_monotonic_gettime(&uptime);
> >         ts = timespec_sub(uptime, tsk->start_time);
> > 	...
> >         stats->ac_btime = get_seconds() - ts.tv_sec;
> > 
> > does not simply use tsk->start_time or tsk->real_start_time without
> > comparing it to the current time.
> 
> From what I understand, task->start_time and task->real_start_time
> are taken from the realtime clock. The accounting in CSA seems
> to be very similar to the accounting done in do_acct_process()
> (kernel/acct.c).

In CSA 3.0 ...

csa_acct_eop(int exitcode, struct task_struct *p)

        csa->ac_btime = boottime +
                        ((p->start_time.tv_nsec < NSEC_PER_SEC/2) ?
                         p->start_time.tv_sec :
                         p->start_time.tv_sec +1);

where 

        do_posix_clock_monotonic_gettime(&uptime);
        boottime = xtime.tv_sec - uptime.tv_sec;

In an upcoming version of CSA ...

csa_acct_eop(struct taskstats *p)

        csa->ac_btime = p->ac_btime;

where

        do_posix_clock_monotonic_gettime(&uptime);
        ts = uptime - tsk->start_time;
        p->ac_btime = get_seconds() - ts.tv_sec;
                    = xtime.tv_sec - (uptime - tsk->start_time);
                    = (xtime.tv_sec - uptime) + tsk->start_time;

So they're basically equivalent.

Jonathan
