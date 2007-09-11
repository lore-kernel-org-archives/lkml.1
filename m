Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbXIKBTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbXIKBTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 21:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbXIKBTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 21:19:46 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:35081 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbXIKBTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 21:19:45 -0400
Date: Mon, 10 Sep 2007 19:19:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: tsc timer related problems/questions
In-reply-to: <fa.sr0PjjOVi2ceb88Wh7ND1s6urC0@ifi.uio.no>
To: Dennis Lubert <plasmahh@gmx.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <46E5ED2A.6080908@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.sr0PjjOVi2ceb88Wh7ND1s6urC0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dennis Lubert wrote:
> Hello list,
> 
> we are encountering a few behaviours regarding the ways to get accurate
> timer values under Linux that we would call bugs, and where we are
> currently stuck in further diagnosing and/or fixing.
> 
> Background: We are developing for SMP servers with up to 8 CPUs (mostly
> AMD64) and for various reasons would like to have time measurements with
> a resolution of maybe a few microseconds.
> 
> 
> - Using Kernel 2.6.20.7 and surroundings per default the TSC Timer is
> used. We are very happy with that (accuracy ~400nanoseconds) but after a
> while the system goes wild with the following message for each CPU:
> 
> [105771.523771] BUG: soft lockup detected on CPU#1!
> [105771.527869]
> [105771.527871] Call Trace:
> [105771.536079]  <IRQ>  [<ffffffff802619cc>] _spin_lock+0x9/0xb
> [105771.540294]  [<ffffffff802a6f9d>] softlockup_tick+0xd2/0xe7
> [105771.544359]  [<ffffffff8024bcbb>] run_local_timers+0x13/0x15
> [105771.548541]  [<ffffffff80289fc1>] update_process_times+0x4c/0x79
> [105771.552737]  [<ffffffff80270327>] smp_local_timer_interrupt
> +0x34/0x54
> [105771.556934]  [<ffffffff80270834>] smp_apic_timer_interrupt+0x51/0x68
> [105771.561022]  [<ffffffff80268121>] default_idle+0x0/0x42
> [105771.565199]  [<ffffffff8025cce6>] apic_timer_interrupt+0x66/0x70
> [105771.569386]  <EOI>  [<ffffffff8026814e>] default_idle+0x2d/0x42
> [105771.573597]  [<ffffffff80247929>] enter_idle+0x22/0x24
> [105771.577665]  [<ffffffff80247a92>] cpu_idle+0x5a/0x79
> [105771.581838]  [<ffffffff806bc5f7>] start_secondary+0x474/0x483
> 
> Question: Is this a known bug already or should further investigation
> take place?

It's unclear what that could be. As Arjan mentioned this can be caused 
by the BIOS going off into SMI mode for a long time. If you don't have 
ACPI turned on, doing this may prevent this from happening.

> 
> - Using Kernels from 2.6.21 on (random sampled) we experience that the
> TSC isn't used per default anymore (we usually set the nopmtimer option
> at boot for a while now). Looking briefly at the 2.6.23-rc5 code shows
> that in the function where the check is done whether the tsc is stable
> the only code path where a "is stable" result could be returned is one
> where the vendor of the CPU is detected as Intel. Instead a much slower
> timesource (10ms instead of a few us resolution, same for getting the
> time at all) is used which is totally unusable for us (Within 10ms so
> much things happen).

What time source is getting used? The best alternative is HPET, most 
newer systems are providing that now. After that, there's ACPI PM timer 
(make sure you have ACPI enabled). The worst possible fallback is the 
PIT, which from this poor resolution sounds like what it is using.

> 
> Question: Why are only Intel CPUs considered as stable? Could there be
> implemented a more sophisticated heuristic, that actually does some
> tests for tsc stability?

AMD CPUs don't seem to have synchronized TSCs across multiple CPUs. It 
seems this is the case even with different cores in the same CPU 
package. Therefore the TSC is not considered a suitable time source on 
multi-CPU AMD systems.

> - Enabling tsc explicitly as a time source via sysfs we had good results
> so far, with quit good resolution, and also various tests about
> synchronization between the CPUs didn't show any measurable changes in
> the deviation over time.
> However, once accidentally someone enabled cpufrequency scaling and
> scaled down two of four CPUs. From then on the time on the slower CPU
> was totally wrong, and all time displaying programs (simple date
> program) showed different (hours in difference) results, depending on
> which CPU they where run, so results were randomly. Programs doing a
> simple usleep() could hang (likely because the time to wakeup was
> gathered from another CPU whith time in the future). The system
> was essentially unusable and also after setting the CPUs back to the
> correct speed, things were still wrong.
> 
> Question: Is this a known problem? It looks like there is a huge problem
> in synchronizing the way the time is calculated from the TSC and the cpu
> frequency scaling, also something else seems to be buggy since also
> after setting things back even after a few seconds only, times are off
> by hours.

This is expected behavior if you force TSC usage on with CPU frequency 
scaling enabled, there's a reason we turn that off normally. (Also in 
the case where some CPUs stop the TSC in certain power-saving halt 
states.) Theoretically one could track the TSC between different CPUs 
running at different clock speeds, etc. and across halts, but it doesn't 
really seem worth the trouble, especially in cases like AMD multi-CPU 
where the TSC can't be trusted across CPUs anyway.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

