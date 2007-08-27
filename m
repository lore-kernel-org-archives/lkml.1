Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbXH0Qck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbXH0Qck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXH0Qcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:32:31 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:11484 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbXH0Qca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=seCJYXBYJpQf6PPdRoUAqXoUwcpCQqaxSOUG630FnfXK/Zj6zxBUiaWwte5x8XtEGnMkiSrZaR2JFwCGK87U2sf8rr7lf3SFRQ6+u/LdtEr9QtdSYI34/auOKH9FzOiuD9bX6YfO9H7uxMyQ3I4KvfCSnyFVjOzOXo3L3oVy6/0=
Message-ID: <64bb37e0708270932h56d8744eo5ae118bdf9e8cc10@mail.gmail.com>
Date: Mon, 27 Aug 2007 18:32:28 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070823115416.GA31027@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070816010150.GG10033@linux-os.sc.intel.com>
	 <20070823115416.GA31027@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/07, Ingo Molnar <mingo@elte.hu> wrote:
> with no patch, or with my patch below each gets ~66% of CPU time,
> long-term:
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2290 mingo     20   0  2736  528  252 R   67  0.0   3:22.95 bash
>  2291 mingo     20   0  2736  532  256 R   67  0.0   3:18.94 bash
>  2292 mingo     20   0  2736  532  256 R   66  0.0   3:19.83 bash
>

I just witnessed another scheduling "bug" that might have been a feature.
I use the current 2.6.23-rc3-mm1 kernel without any additional patches.

I have a 2x2218 Opteron system using the ondemand cpufreq governor,
one CPU was a max 2600 MHz, the other was at 1000 MHz.
On this system there were three processes (all niced) running, but
they all ended up at one CPU package, so that the distribution was
100-50-50 and the other CPU still idle.

So while the 100-50-50 distribution on one CPU might be fixed by your
patch, I am interested if the behavior that the second CPU remained
idle was intended.

On one hand it made perfectly sense: Even if one 50% task would be
migrated it would one get 1000MHz of CPU before the ondemand governor
kicked in, instead of 50% of 2600MHz == 1300MHZ.

A quick grep did not show me any references to cpufreq or governors in
kernel/sched* so I would expect that the scheduler can not predict
that the CPU will power up, if a task will be migrated there.

Part of my config:
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
...
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_PREEMPT_NOTIFIERS=y
...
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
...
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set

My testcase is not reproducibly as it happened, but I could try to
recreate this, if it is necessary.

(I was running the screen saver from electricsheep.org and the three
niced tasks were three of its render threads)

Torsten
