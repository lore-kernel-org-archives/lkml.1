Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZDMQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZDMQJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZDMQJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:09:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbZDMQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:09:32 -0400
Date: Mon, 13 Apr 2009 09:04:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
In-Reply-To: <4609.1239456126@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, Valdis.Kletnieks@vt.edu wrote:
> 
> Probable cause for my problem:
> 
> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c calls work_on_cpu(). We get into a
> state where we have enough activity to kick us to a high CPU speed, and then
> the activity of writing 90 acct records per sec keeps us there - with continual
> callbacks to see if we can drop the CPU speed.

Ok, I think that that work_on_cpu() commit is broken, but I _also_ think 
that cpufreq is doing something fairly insane.

This behavior seems to be triggered by the "ondemand" policy case, btw, 
and it literally does basically:

  dbs_check_cpu:
    for_each_cpu(j, policy->cpus)
      ...
      freq_avg = __cpufreq_driver_getavg(policy, j);

where "__cpufreq_driver_getavg()" will do "freq->getavg(policy, cpu)" and 
then acpi-cpufreq.c will do that "work_on_cpu()" as part of the call to 
"get_measured_perf()".

So pretty much _all_ use is going to always effectively do a broadcast 
"work on each cpu" thing. That's always going to be pretty damn expensive.

And there's no _reason_. As far as I can tell, that ACPI cpufreq thing 
doesn't _need_ any "process context".  That "get_measured_perf()" will 
just do a single read_measured_perf_ctrs() call, and all that does is two 
'rdmsr()' calls.

So afaik, acpi-cpufreq.c should not use "work_on_cpu()" for that at all. 
It should just do a smp_call_function_single(). 

So I do think Andrew's commit is broken and we should think about it a bit 
more, but I also think that Valdis' problem comes from acpi-cpufreq just 
being damn stupid. Doing a smp_call_function_single() to read two MSR's is 
going to be a _lot_ more efficient than doing that crazy work_on_cpu() for 
that.

So the _real_ problem came through the commits like

    cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
    cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs

that were meant to reduce stack usage with big cpu masks. And sure, the 
_old_ way of doing it was also stupid (it rescheduled the process to the 
other CPU by using cpus_allowed()).

Mike, Ingo?

		Linus
