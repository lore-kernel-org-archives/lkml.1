Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYA0QlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYA0QlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYA0Qkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:40:53 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46428 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYA0Qkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:40:52 -0500
Date: Sun, 27 Jan 2008 22:24:00 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Toralf.=?iso-8859-1?Q?F=F6rster_=3Ctoralf=2Efoerster=40gmx=2Ede=3E?=@snowy.in.ibm.com
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Message-ID: <20080127165400.GB1044@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <479B69D2.5050603@wpkg.org> <200801261946.54518.toralf.foerster@gmx.de> <20080127144610.GA25632@linux.vnet.ibm.com> <200801271606.19862.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801271606.19862.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 04:06:17PM +0100, Toralf Förster wrote:
> > The third line (giving overall cpu usage stats) is what is interesting here.
> > If you have more than one cpu, you can get cpu usage stats for each cpu
> > in top by pressing 1. Can you provide this information with and w/o 
> > CONFIG_FAIR_GROUP_SCHED?
> 
> This is what I get if I set CONFIG_FAIR_GROUP_SCHED to "y"
> 
> top - 16:00:59 up 2 min,  1 user,  load average: 2.56, 1.60, 0.65
> Tasks:  84 total,   3 running,  81 sleeping,   0 stopped,   0 zombie
> Cpu(s): 49.7%us,  0.3%sy, 49.7%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
> Mem:   1036180k total,   322876k used,   713304k free,    13164k buffers
> Swap:   997880k total,        0k used,   997880k free,   149208k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  6070 dnetc     39  19   664  348  264 R 49.7  0.0   1:09.71 dnetc
>  6676 tfoerste  20   0  1796  488  428 R 49.3  0.0   0:02.72 factor
> 
> Stopping dnetc gives:
> 
> top - 16:02:36 up 4 min,  1 user,  load average: 2.50, 1.87, 0.83
> Tasks:  89 total,   3 running,  86 sleeping,   0 stopped,   0 zombie
> Cpu(s): 99.3%us,  0.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   1036180k total,   378760k used,   657420k free,    14736k buffers
> Swap:   997880k total,        0k used,   997880k free,   180868k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  6766 tfoerste  20   0  1796  488  428 R 84.9  0.0   0:05.41 factor

Thanks for this respone. This confirms that cpu's idle time is close to
zero, as I intended to verify.

> > If I am not mistaken, cpu ondemand gov goes by the cpu idle time stats,
> > which should not be affected by FAIR_GROUP_SCHED. I will lookaround for
> > other possible causes.

On further examination, ondemand governor seems to have a tunable to
ignore nice load. In your case, I see that dnetc is running at a
positive nice value (19) which could explain why ondemand gov thinks
that the cpu is only ~50% loaded.

Can you check what is the setting of this knob in your case?

# cat /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load

You can set that to 0 to ask ondemand gov to include nice load into
account while calculating cpu freq changes:

# echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load

This should restore the behavior of ondemand governor as seen in 2.6.23
in your case (even with CONFIG_FAIR_GROUP_SCHED enabled). Can you pls confirm 
if that happens?

> As I stated our in http://lkml.org/lkml/2008/1/26/207 the issue is solved
> after unselecting FAIR_GROUP_SCHED. 

I understand, but we want to keep CONFIG_FAIR_GROUP_SCHED enabled by
default.

Ingo,
	Most folks seem to be used to a global nice-domain, where a nice 19 
task gives up cpu in competetion to a nice-0 task (irrespective of which 
userid's they belong to). CONFIG_FAIR_USER_SCHED brings noticeable changes wrt 
that. We could possibly let it be as it is (since that is what a server
admin may possibly want when managing university servers) or modify it to be 
aware of nice-level (priority of user-sched entity is equivalent to highest 
prio task it has).

In any case, I will send across a patch to turn off CONFIG_FAIR_USER_SCHED by 
default (and instead turn on CONFIG_FAIR_CGROUP_SCHED by default).

-- 
Regards,
vatsa
