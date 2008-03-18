Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYCREY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYCREY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 00:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYCREYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 00:24:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:56336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYCREYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uZ5FIGy0nIISzOPR00csvP+4r+BLd5jcDoJLhNObXDtteYJgpB3rQ+GLkITYKz8Aiy3P6QzQdCtsfzzQr6rto/MLS5HordKDSpiJtCQVpihW4TZoq4jKh49fbtCkON0qlw2qDnFTymQVGHr1mREo2IzzeFl0Ojd5XuiC6dw8oJE=
Message-ID: <47DF4404.8080202@googlemail.com>
Date: Tue, 18 Mar 2008 05:24:36 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Gabriel C <crazy@frugalware.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com>
In-Reply-To: <47DF3E8B.6040502@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Gabriel C wrote:
>> Thomas Gleixner wrote:
>>> On Mon, 17 Mar 2008, Gabriel C wrote:
>>>>> Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
>>>>> Submitter	: Gabriel C <nix.or.die@googlemail.com>
>>>>> Date		: 2008-02-24 01:31 (22 days old)
>>>>> References	: http://lkml.org/lkml/2008/2/23/380
>>>>> 		  http://lkml.org/lkml/2008/2/24/281
>>>>> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
>>>>>
>>>> Thomas do you want me to bisect ? 
>>> That'd be great.
>> Ok I'll start doing that later on today.
>>
> 
> I managed to bisect 'one of the bugs' down , I got some problems and used skip once because a revision didn't compiled , 
> but it seems bisect got the right commit still. Sadly it seems there are 2 different bugs.
> 
> Also before I've started the bisect I've tested linux-next to be sure the bug(s) still exists and while rc1 got that already
> I've started to bisect 2.6.24 ->  2.6.25-rc1.
> 
> cat .git/refs/bisect/bad
> 1ada5cba6a0318f90e45b38557e7b5206a9cba38
> 
> git show 1ada5cba6a0318f90e45b38557e7b5206a9cba38
> commit 1ada5cba6a0318f90e45b38557e7b5206a9cba38
> Author: Andi Kleen <ak@suse.de>
> Date:   Wed Jan 30 13:30:02 2008 +0100
> 
>     clocksource: make clocksource watchdog cycle through online CPUs
> 
>     This way it checks if the clocks are synchronized between CPUs too.
>     This might be able to detect slowly drifting TSCs which only
>     go wrong over longer time.
> 
>     Signed-off-by: Andi Kleen <ak@suse.de>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index cabfa19..edd5ef8 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -142,8 +142,13 @@ static void clocksource_watchdog(unsigned long data)
>         }
> 
>         if (!list_empty(&watchdog_list)) {
> -               __mod_timer(&watchdog_timer,
> -                           watchdog_timer.expires + WATCHDOG_INTERVAL);
> +               /* Cycle through CPUs to check if the CPUs stay synchronized to
> +                * each other. */
> +               int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
> +               if (next_cpu >= NR_CPUS)
> +                       next_cpu = first_cpu(cpu_online_map);
> +               watchdog_timer.expires += WATCHDOG_INTERVAL;
> +               add_timer_on(&watchdog_timer, next_cpu);
>         }
>         spin_unlock(&watchdog_lock);
>  }
> @@ -165,7 +170,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
>                 if (!started && watchdog) {
>                         watchdog_last = watchdog->read();
>                         watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
> -                       add_timer(&watchdog_timer);
> +                       add_timer_on(&watchdog_timer, first_cpu(cpu_online_map));
>                 }
>         } else {
>                 if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
> @@ -186,7 +191,8 @@ static void clocksource_check_watchdog(struct clocksource *cs)
>                                 watchdog_last = watchdog->read();
>                                 watchdog_timer.expires =
>                                         jiffies + WATCHDOG_INTERVAL;
> -                               add_timer(&watchdog_timer);
> +                               add_timer_on(&watchdog_timer,
> +                                               first_cpu(cpu_online_map));
>                         }
>                 }
>         }
> 
> 
>  git bisect log
> git-bisect start
> # bad: [19af35546de68c872dcb687613e0902a602cb20e] Linux 2.6.25-rc1
> git-bisect bad 19af35546de68c872dcb687613e0902a602cb20e
> # good: [49914084e797530d9baaf51df9eda77babc98fa8] Linux 2.6.24
> git-bisect good 49914084e797530d9baaf51df9eda77babc98fa8
> # bad: [d2e626f45cc450c00f5f98a89b8b4c4ac3c9bf5f] x86: add PAGE_KERNEL_EXEC_NOCACHE
> git-bisect bad d2e626f45cc450c00f5f98a89b8b4c4ac3c9bf5f
> # good: [fb46990dba94866462e90623e183d02ec591cf8f] [NETFILTER]: nf_queue: remove unnecessary hook existance check
> git-bisect good fb46990dba94866462e90623e183d02ec591cf8f
> # good: [936722922f6d2366378de606a40c14f96915474d] [IPV4] fib_trie: compute size when needed
> git-bisect good 936722922f6d2366378de606a40c14f96915474d
> # bad: [ff14c6164bd532a6dc9025c07d3b562f839f00a9] x86: x86-64 ia32 ptrace pt_regs cleanup
> git-bisect bad ff14c6164bd532a6dc9025c07d3b562f839f00a9
> # good: [c087567d3ffb2c7c61e091982e6ca45478394f1a] SUNRPC: Remove the obsolete RPC_WAITQ macro
> git-bisect good c087567d3ffb2c7c61e091982e6ca45478394f1a
> # bad: [af7a78e9258ffcca681e080cbc857f854869144f] x86: move mce related declarations
> git-bisect bad af7a78e9258ffcca681e080cbc857f854869144f
> # good: [34f5b4662bf4b54f22b32ce76ce70eccd7ebc68a] SUNRPC: Don't bother changing the sigmask for asynchronous RPC calls
> git-bisect good 34f5b4662bf4b54f22b32ce76ce70eccd7ebc68a
> # bad: [83bd01024b1fdfc41d9b758e5669e80fca72df66] x86: protect against sigaltstack wraparound
> git-bisect bad 83bd01024b1fdfc41d9b758e5669e80fca72df66
> # good: [efd9ac8630e89b9ee7ce64008bd7783952374f37] time: fold __get_realtime_clock_ts() into getnstimeofday()
> git-bisect good efd9ac8630e89b9ee7ce64008bd7783952374f37
> # bad: [37a47db8d7f0f38dac5acf5a13abbc8f401707fa] x86: assign IRQs to HPET timers, fix
> git-bisect bad 37a47db8d7f0f38dac5acf5a13abbc8f401707fa
> # skip: [316da3b3fc8efa9a5d2c99e0d449f01ff38c6aba] x86: restrict PIT clocksource usage
> git-bisect skip 316da3b3fc8efa9a5d2c99e0d449f01ff38c6aba
> # bad: [4713e22ce81eb8b3353e16435362eb3d0ec95640] clocksource: add unregister function to disable unusable clocksources
> git-bisect bad 4713e22ce81eb8b3353e16435362eb3d0ec95640
> # bad: [1ada5cba6a0318f90e45b38557e7b5206a9cba38] clocksource: make clocksource watchdog cycle through online CPUs
> git-bisect bad 1ada5cba6a0318f90e45b38557e7b5206a9cba38
> # good: [1077f5a917b7c630231037826b344b2f7f5b903f] clocksource.c: use init_timer_deferrable for clocksource_watchdog
> git-bisect good 1077f5a917b7c630231037826b344b2f7f5b903f
> 
> 
> Also the broken revision died with that :
> 
> arch/x86/kernel/i8253.c: In function 'init_pit_clocksource':
> arch/x86/kernel/i8253.c:207: error: implicit declaration of function 'is_hpet_enabled'
> make[1]: *** [arch/x86/kernel/i8253.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> If you tell me on how to fix that I'll restart the bisect from there , just in case ..
> 
> 
> Also reverting the commit from 2.6.25-rc1 fixes the 'Tsc being unstable thing' but it does not fix the hang
> when I boot with clocksource=acpi_pm so that seems to be introduced in a different commit.
> 
> I will try to bisect this hang also , most probably on weekend.
> 
> 
> Also I reverted that commit from git head and an kernel compiles right now, I'll let you know in a bit if that worked out.

Worked out :)

git head - 1ada5cba6a0318f90e45b38557e7b5206a9cba38 works here.

dmesg|grep clocksource
[    0.563915] Time: tsc clocksource has been installed.

uname -a
Linux lara 2.6.25-rc6-00014-gbde4f8f-dirty #2 SMP PREEMPT Tue Mar 18 04:48:53 CET 2008 i686 GNU/Linux


Gabriel 
