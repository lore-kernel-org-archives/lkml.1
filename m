Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZA0QEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZA0QEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZA0QEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:04:10 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40925 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZA0QEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iIPyGIpTbhheOWRDqfetLBEQtHzzRrbWTEuYXtRFtIVwBnXhHsyZu+YsDXh5nXYlk0
         p2/bi9cOmooeH3i7GtgWnCZ/XZxbHWoUm6+F8yC1ZiXZx491X98sgM3N2Op3K/eL1f0t
         6SmFd6ecvEXElzSyr5/jGiUCTz9at2kk2Z9fY=
MIME-Version: 1.0
In-Reply-To: <20090126225545.GA1330@elte.hu>
References: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com>
	 <1232725219.4826.131.camel@laptop>
	 <2cd4df870901260548s2376a01anae0db9707dcfa14@mail.gmail.com>
	 <20090126225545.GA1330@elte.hu>
Date: Tue, 27 Jan 2009 17:04:07 +0100
Message-ID: <2cd4df870901270804p75822471odca6f5d66b9d33fa@mail.gmail.com>
Subject: Re: CPU scheduler question/problem
From: Pawel Dziekonski <dzieko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/26 Ingo Molnar <mingo@elte.hu>:
>
> * Pawel Dziekonski <dzieko@gmail.com> wrote:
>
>> 2009/1/23 Peter Zijlstra <peterz@infradead.org>:
>>
>> > The pipe workload you mentioned has would behave that way because pipes
>> > 'assume' a produces/consumer behaviour, and thus are more likely to
>> > place both tasks on the same cpu -- but will eventually pull them apart
>> > if they want to run concurrently.
>> >
>> > You might enable SCHED_DEBUG=y and try
>> >  echo NO_SYNC_WAKEUPS > /debug/sched_features
>>
>> Hello,
>>
>> that did the trick. Openssl now gets a whole core exclusively and gives
>> full performance.
>>
>> Regarding quantum chemistry application -- it is also using pipes for
>> communication between worker processes. Now this app works OK.
>
> Could you please try the fuller fix below too please, does it still do the
> trick and does the scheduler still maximize openssl and your quantum
> chemistry app's throughput?
>
> There should be no need for you to tune anything - the scheduler must get
> such workloads right out of the box.

hello,

After contacting Ingo directly I downloaded tip/master kernel tree via
http://people.redhat.com/mingo/tip.git/README.

after reboot SYNC_WAKEUPS is enabled by default and my openssl
benchmark is still
stuck on one core:

# uname -a
Linux MiP 2.6.29-rc2 #1 SMP Tue Jan 27 16:03:29 CET 2009 x86_64 x86_64
x86_64 GNU/Linux

# cat /sys/kernel/debug/sched_features
NEW_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER ADAPTIVE_GRAN WAKEUP_PREEMPT
START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK
NO_DOUBLE_TICK ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD
NO_WAKEUP_OVERLAP LAST_BUDDY OWNER_SPIN

# pidstat

16:20:43          PID    %usr %system  %guest    %CPU   CPU  Command
16:20:44         4992    0.00    2.00    0.00    2.00     4  dd
16:20:44         4993   81.00    6.00    0.00   87.00     4  openssl
16:20:44         4994    3.00    9.00    0.00   12.00     4  pv

> Also, does
> the slowdown go away (if SYNC_WAKEUPS is enabled) if you reduce/increase
> /proc/sys/kernel/sched_migration_cost?

I tested values of 100000, 500000 (default), 999999. in all cases 3
processes stay together on the same core and are jumping together
between different cores:

# pidstat 1

16:27:07          PID    %usr %system  %guest    %CPU   CPU  Command
16:27:08         4992    0.00    1.00    0.00    1.00     0  dd
16:27:08         4993   78.00    6.00    0.00   84.00     0  openssl
16:27:08         4994    2.00   12.00    0.00   14.00     0  pv

16:27:08          PID    %usr %system  %guest    %CPU   CPU  Command
16:27:09         4992    0.00    2.00    0.00    2.00     4  dd
16:27:09         4993   83.00    3.00    0.00   86.00     4  openssl
16:27:09         4994    3.00    9.00    0.00   12.00     4  pv

However value of "1" works:

16:30:08          PID    %usr %system  %guest    %CPU   CPU  Command
16:30:09         6197    0.00    4.00    0.00    4.00     2  dd
16:30:09         6198   94.00    7.00    0.00  101.00     1  openssl
16:30:09         6199    2.00   15.00    0.00   17.00     0  pv

regards, Pawel
