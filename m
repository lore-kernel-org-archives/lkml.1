Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbXHaHZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbXHaHZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXHaHZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:25:07 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59760 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXHaHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:25:03 -0400
Message-ID: <46D7C23F.7020509@linux.vnet.ibm.com>
Date: Fri, 31 Aug 2007 12:54:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jonathan Lim <jlim@sgi.com>
CC: Guillaume Chazarain <guichaz@yahoo.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com>
In-Reply-To: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Lim wrote:
> On Sat Aug 25 21:58:44 2007, balbir@linux.vnet.ibm.com wrote:
>>> Also, I don't understand why the code to update btime:
>>>
>>>         /* calculate task elapsed time in timespec */
>>>         do_posix_clock_monotonic_gettime(&uptime);
>>>         ts = timespec_sub(uptime, tsk->start_time);
>>> 	...
>>>         stats->ac_btime = get_seconds() - ts.tv_sec;
>>>
>>> does not simply use tsk->start_time or tsk->real_start_time without
>>> comparing it to the current time.
>> From what I understand, task->start_time and task->real_start_time
>> are taken from the realtime clock. The accounting in CSA seems
>> to be very similar to the accounting done in do_acct_process()
>> (kernel/acct.c).
> 
> In CSA 3.0 ...
> 
> csa_acct_eop(int exitcode, struct task_struct *p)
> 
>         csa->ac_btime = boottime +
>                         ((p->start_time.tv_nsec < NSEC_PER_SEC/2) ?
>                          p->start_time.tv_sec :
>                          p->start_time.tv_sec +1);
> 
> where 
> 
>         do_posix_clock_monotonic_gettime(&uptime);
>         boottime = xtime.tv_sec - uptime.tv_sec;
> 
> In an upcoming version of CSA ...
> 
> csa_acct_eop(struct taskstats *p)
> 
>         csa->ac_btime = p->ac_btime;
> 
> where
> 
>         do_posix_clock_monotonic_gettime(&uptime);
>         ts = uptime - tsk->start_time;
>         p->ac_btime = get_seconds() - ts.tv_sec;
>                     = xtime.tv_sec - (uptime - tsk->start_time);
>                     = (xtime.tv_sec - uptime) + tsk->start_time;
> 
> So they're basically equivalent.

Excellent, so can Guillaume change ac_btime to be just tsk->start_time?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
