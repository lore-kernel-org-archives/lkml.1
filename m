Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXHZE7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXHZE7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 00:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXHZE6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 00:58:54 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56859 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXHZE6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 00:58:53 -0400
Message-ID: <46D10884.6040401@linux.vnet.ibm.com>
Date: Sun, 26 Aug 2007 10:28:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@yahoo.fr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com> <20070802120427.270e5589.akpm@linux-foundation.org> <20070819213435.72b287ad@localhost.localdomain> <46C9C8D4.9080108@linux.vnet.ibm.com> <20070825171039.3bc73781@localhost.localdomain>
In-Reply-To: <20070825171039.3bc73781@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:
> Le Mon, 20 Aug 2007 22:31:08 +0530,
> Balbir Singh <balbir@linux.vnet.ibm.com> a écrit :
> 
>>> --- a/kernel/taskstats.c	Sat Aug 18 17:15:17 2007 -0700
>>> +++ b/kernel/taskstats.c	Sun Aug 19 17:20:15 2007 +0200
>>> @@ -246,6 +246,8 @@ static int fill_tgid(pid_t tgid, struct 
>>>
>>>  		stats->nvcsw += tsk->nvcsw;
>>>  		stats->nivcsw += tsk->nivcsw;
>>> +		bacct_add_tsk(stats, tsk);
>>> +		xacct_add_tsk(stats, tsk);
>> I'm afraid this is still not good enough. bacct_add_tsk() will assign
>> values and do nothing in the loop (HINT: no summation).
> 
> Hi Balbir, thank you for your review. I agree with everything you said
> and am on my way to do it as time permits, but I have some trouble
> understanding this part. You stated that bacct_add_tsk() would overwrite
> the stats of each thread in the tgid stats, but the other part of the
> patch is the (actually wrong) combination of stats in xxx_add_tsk()
> using min/max/sum.
> 

Hi, Guillaume,

The CSA code was written by Jay Lan, but I'll see if I can answer your
questions. In the current implementation, CSA does not use TGID exit
notifications. In fill_pid(), both bacct_add_tsk() and xacct_add_tsk()
are called (which is correct), they complement each other.

The code needs refactoring to ensure that they can work together
in the fill_tgid() scenario.

> Also, I don't understand why the code to update btime:
> 
>         /* calculate task elapsed time in timespec */
>         do_posix_clock_monotonic_gettime(&uptime);
>         ts = timespec_sub(uptime, tsk->start_time);
> 	...
>         stats->ac_btime = get_seconds() - ts.tv_sec;
> 
> does not simply use tsk->start_time or tsk->real_start_time without
> comparing it to the current time.
> 

>From what I understand, task->start_time and task->real_start_time
are taken from the realtime clock. The accounting in CSA seems
to be very similar to the accounting done in do_acct_process()
(kernel/acct.c).

Jay/Jonathan any comments?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
