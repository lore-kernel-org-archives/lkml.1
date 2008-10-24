Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYJXUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYJXUPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYJXUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:15:41 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37485 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbYJXUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:15:40 -0400
Message-ID: <49022D90.6080606@vmware.com>
Date: Fri, 24 Oct 2008 13:18:24 -0700
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, dhecht@vmware.com
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
References: <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com> <20081024072320.GE27492@one.firstfloor.org> <4901EA14.9070300@zytor.com> <20081024192532.GG27492@one.firstfloor.org>
In-Reply-To: <20081024192532.GG27492@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2008 12:25 PM, Andi Kleen wrote:
>> BIOSes are also just software, and we have to deal with bugs in them
>> *all the time*.  The reality is that we're going to have to deal with
>> both vendor and user reluctance to upgrade, and therefore have to deal
>> with brokenness in the field.
> 
> In the field they will just continue using clock=pit, like they
> always did on vmware. And also they will not update the Linux kernel.
> 
> This is strictly for new installations. And I frankly don't
> see why Linux needs to get white listed workarounds when the
> Hypervisor couldn't as well be fixed. We have the bizarre
> situation here where a HV vendor tries to add workarounds
> to Linux instead of fixing it on their products.
> 

What exactly would you like vmware to fix?  VMware fully virtualizes 
x86.  However, when running the kernel on virtual cpus, as compared to 
running on a physical cpus, the timing characteristics are different -- 
  virtual cpus have to time share physical cpus with each other.

So, timing assumptions that the kernel makes when running directly on 
physical cpus no longer hold when running on virtual cpus.

Prior to clocksource/clockevents, the timing assumptions that the Linux 
kernel made were terrible for hypervisors.  Now, the assumptions are 
much better.  However, three *minor* assumptions that the kernel makes 
are violated when running on a hypervisor:

1) The fast-path TSC calibration code makes assumptions about being able 
to sample various counters in sequence in a set amount of time that are 
not true when running virtualized.  (Actually, it makes assumptions that 
aren't really true 100% of the time on physical cpus, but in that case 
the odds of violating the assumptions (by hitting an SMI at exactly the 
right time and length) are really rare.

Note that accurate calibration of the TSC is extremely important in 
clocksource kernels since any error will lead to long term drift of 
wallclock time.

2) There is no guarantee that the acpi_pm timer will be sampled at least 
every 4.68 seconds (the wrap interval), because the vcpu, in extreme 
circumstances, may not have a chance to run in that time.  Thus, the 
acpi_pm timer is not suitable to be used as a clocksource watchdog when 
running on a hypervisor.

3) Virtual TSCs can be kept nearly in sync, but because the virtual TSC 
offset is set by software, it's not perfect.  So, the TSC 
synchronization test can fail.  (Really, it can fail on native as well, 
and that's why the tests for backwards TSC were added to 
read_tsc()/vread_tsc()).

Clearly, #1 and #2 *cannot* be fixed in the hypervisor.  These are cases 
where the kernel is making assumptions that just are not true when 
running on certain platforms (i.e. hypervisors).  Let's fix them.

#3, as you have suggested below, can perhaps be fixed by loosening the 
check a bit to allow some leeway for marginally offset TSCs.

> Now making generic code a little more flexible in what
> it accepts is fine though (like relaxing tsc_sync or
> checking and trusting UNSTABLE_TSC). That will scale at least
> and doesn't need significant new code.
> 

I think everyone can agree that this is the preferred approach, in 
general.  And in fact it was the approach Alok first used for the TSC 
frequency calibration problem (this is one reason why he merged the 
32-bit and 64-bit TSC code -- to standardize on the more robust 64-bit 
calibration code).  But, in the end, folks wanted a "fast" TSC 
calibration path, and that path makes assumptions that just won't be 
true when running on a hypervisor, so we are left with skipping that 
path if we are on a virtual cpu.

Also, with regards to your claim that users should continue to use 
clock=pit like options on newer kernels: that is just plain *wrong*. 
The reason for clock=pit (really clock=pmtmr) recommendation on 
pre-clocksource kernels wasn't to avoid using the TSC, but it was simply 
a workaround to avoid the kernel code that attempted to compensate for 
lost ticks (but would do so incorrectly in the case of late, but not 
lost, interrupts -- again, it was a kernel timing assumption that was 
invalid on hypervisors).

Dan
