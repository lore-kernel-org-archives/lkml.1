Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbYENJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbYENJZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYENJZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:25:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:13151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYENJZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,485,1204531200"; 
   d="scan'208";a="383596425"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, vatsa@linux.vnet.ibm.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
References: <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
	 <1210223914.3453.102.camel@ymzhang>
	 <20080508054047.GD32729@linux.vnet.ibm.com>
	 <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
	 <1210583090.7402.4.camel@marge.simson.net>
	 <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 May 2008 17:22:53 +0800
Message-Id: <1210756974.3177.113.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 11:20 +0200, Peter Zijlstra wrote:
> On Mon, 2008-05-12 at 11:04 +0200, Mike Galbraith wrote:
> > On Mon, 2008-05-12 at 13:02 +0800, Zhang, Yanmin wrote:
> > 
> > > A quick update:
> > > With 2.6.26-rc2 (﻿CONFIG_USER_SCHED=y), volanoMa﻿rk result on my 8-core stoakley
> > > is about 10% worse than the one of 2.6.26-rc1.
> > 
> > Here (Q6600), 2.6.26-rc2 ﻿CONFIG_USER_SCHED=y regression culprit for
> > volanomark is the same one identified for mysql+oltp.
> > 
> > (i have yet to figure out where the buglet lies, but there is definitely
> > one in there somewhere)
> > 
> Yeah, I expect that when you create some groups and move everything down
> 1 level you'll get into the same problems as with user grouping.
> 
> The thing seems to be that rq weights shrink to < 1 task level in these
> situations - because its spreading 1 tasks (well group) worth of load
> over the various CPUs.
> 
> We're going through the load balance code atm to find out where the
> small load numbers would affect decisions.
> 
> It looks like things like find_busiest_group() just think everything is
> peachy when the imbalance is < 1 task - which with all this grouping
> stuff is not necessarily true.
In case I might mislead you on the ﻿find_busiest_group path, I did more testing
and collected data on both hackbench and volanoMark.

I reran hackbench against 2.6.25, 2.6.26-rc2 and 2.6.26-rc2+slub_reverse, because
2.6.26-rc includes Christoph's handling multi page-size slub patch which could improve
hackbench. The testing machine is 8-core stoakley.

All kernel are compiled with options:
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y

		| hackbench 100 process 2000	| ﻿hackbench 100 process 10000
-------------------------------------------------------------------------------
2.6.25		|	35seconds		|	182second
﻿-------------------------------------------------------------------------------
﻿2.6.26-rc2      |	28.5seconds		 |	 140second
﻿-------------------------------------------------------------------------------
﻿2.6.26-rc2	 |				 |
+reverse_slub 	|	32seconds		|	160second
﻿-------------------------------------------------------------------------------

So if we don't consider SLUB patch improvement, 2.6.26-rc2 still has some improvement
on hackbench. Not sure if the improvement is related to scheduler.


Then, I collected the schedule caller information with volanoMark testing. Data
is collected for 20 seconds during the testing.

Below is the gprof output with kernel 2.6.25 using above config option.
                0.00    0.00    2962/19804016     retint_careful [16339]
                0.00    0.00    3234/19804016     sys_rt_sigsuspend [20024]
                0.00    0.00    4960/19804016     lock_sock_nested [11240]
                0.00    0.00    8957/19804016     sysret_careful [20253]
                0.00    0.00   28507/19804016     cpu_idle [4340]
                0.00    0.00 2137406/19804016     futex_wait [8065]
                0.00    0.00 4400980/19804016     schedule_timeout [2]
                0.00    0.00 13213237/19804016     sys_sched_yield [20035]
[1]      0.0    0.00    0.00 19804016         schedule [1]
-----------------------------------------------
                0.00    0.00       1/4400980     cifs_oplock_thread [3727]
                0.00    0.00       2/4400980     cifs_dnotify_thread [3700]
                0.00    0.00       2/4400980     inet_csk_accept [9461]
                0.00    0.00      29/4400980     do_select [5468]
                0.00    0.00 4400946/4400980     sk_wait_data [18983]
[2]      0.0    0.00    0.00 4400980         schedule_timeout [2]
                0.00    0.00 4400980/19804016     schedule [1]


Below is the gprof output with kernel 2.6.26-rc2﻿ using above config option.
                0.00    0.00    3035/12423442     sys_rt_sigsuspend [20387]
                0.00    0.00    7862/12423442     lock_sock_nested [11424]
                0.00    0.00   31105/12423442     __cond_resched [23242]
                0.00    0.00  135653/12423442     retint_careful [16627]
                0.00    0.00  180994/12423442     cpu_idle [4411]
                0.00    0.00  506419/12423442     sysret_careful [20620]
                0.00    0.00 1657696/12423442     futex_wait [8211]
                0.00    0.00 3062197/12423442     schedule_timeout [2]
                0.00    0.00 6836914/12423442     sys_sched_yield [20398]
[1]      0.0    0.00    0.00 12423442         schedule [1]
-----------------------------------------------
                0.00    0.00       1/3062197     cifs_dnotify_thread [3781]
                0.00    0.00       2/3062197     sk_stream_wait_memory [19336]
                0.00    0.00      29/3062197     do_select [5561]
                0.00    0.00 3062165/3062197     sk_wait_data [19338]
[2]      0.0    0.00    0.00 3062197         schedule_timeout [2]
                0.00    0.00 3062197/12423442     schedule [1]


So with kernel 2.6.25, about 66% calling of schedule is from ﻿sys_sched_yield,
but only 55% ﻿calling of schedule is from ﻿sys_sched_yield with kernel 2.6.26-rc2.
﻿sysret_careful/﻿retint_careful times mean non-voluntary schedule times. 2.6.25's
non-﻿voluntary schedule is far less than the one of 2.6.26-rc2.

﻿
Below is the gprof output with kernel 2.6.26-rc2﻿(CONFIG_GROUP_SCHED=y,CONFIG_CGROUP_SCHED=y).
                0.00    0.00    2519/20999187     retint_careful [16704]
                0.00    0.00    5899/20999187     lock_sock_nested [11494]
                0.00    0.00   27059/20999187     sysret_careful [20697]
                0.00    0.00   73569/20999187     cpu_idle [4473]
                0.00    0.00 2360268/20999187     futex_wait [8275]
                0.00    0.00 4755337/20999187     schedule_timeout [2]
                0.00    0.00 13769085/20999187     sys_sched_yield [20475]
[1]      0.0    0.00    0.00 20999187         schedule [1]
-----------------------------------------------
                0.00    0.00       1/4755337     cifs_dnotify_thread [3837]
                0.00    0.00       2/4755337     inet_csk_accept [9697]
                0.00    0.00      31/4755337     do_select [5624]
                0.00    0.00 4755303/4755337     sk_wait_data [19414]
[2]      0.0    0.00    0.00 4755337         schedule_timeout [2]
                0.00    0.00 4755337/20999187     schedule [1]
-----------------------------------------------

volanoMark need /proc/sys/kernel/sched_compat_yield=1.

Perhaps above info might provide some clues? either ﻿2.6.26-rc2 change has some impact on
sys_sched_yield?

yanmin


