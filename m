Return-Path: <linux-kernel-owner+w=401wt.eu-S936140AbXFFWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140AbXFFWDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934844AbXFFWD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:03:27 -0400
Received: from lucidpixels.com ([75.144.35.66]:46888 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934501AbXFFWD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:03:26 -0400
Date: Wed, 6 Jun 2007 18:03:25 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <Pine.LNX.4.64.0706061747180.3697@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706061803040.4671@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <Pine.LNX.4.64.0706061747180.3697@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mem:   8039620k total,  7936472k used,   103148k free,      708k buffers
Mem:   8039608k total,   969380k used,  7070228k free,     1232k buffers

I am curious, why does the patch != the mem=8832M?

Justin.

On Wed, 6 Jun 2007, Justin Piszcz wrote:

>
>
> On Wed, 6 Jun 2007, Jesse Barnes wrote:
>
>> On some machines, buggy BIOSes don't properly setup WB MTRRs to
>> cover all available RAM, meaning the last few megs (or even gigs)
>> of memory will be marked uncached.  Since Linux tends to allocate
>> from high memory addresses first, this causes the machine to be
>> unusably slow as soon as the kernel starts really using memory
>> (i.e. right around init time).
>> 
>> This patch works around the problem by scanning the MTRRs at
>> boot and figuring out whether the current end_pfn value (setup
>> by early e820 code) goes beyond the highest WB MTRR range, and
>> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
>> is printed too, letting the user know that not all of their
>> memory is available due to a likely BIOS bug.
>> 
>> Something similar could be done on i386 if needed, but the boot
>> ordering would be slightly different, since the MTRR code on i386
>> depends on the boot_cpu_data structure being setup.
>> 
>> Justin, can you please test and make sure this patch works for
>> you too?  It'll only work around the problem, but it's better
>> than having to do mem= by hand or waiting for a fix from your
>> BIOS vendor.
>> 
>> Thanks,
>> Jesse
>
> Jesse, it worked.
>
> With mem=8832M (without your patch): 2.6.22-rc4:
>
> top - 17:39:02 up 1 day,  8:07, 25 users,  load average: 2.33, 0.76, 0.30
> Tasks: 325 total,  11 running, 314 sleeping,   0 stopped,   0 zombie
> Cpu(s): 80.0%us, 20.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Mem:   8039620k total,  7936472k used,   103148k free,      708k buffers
> Swap: 16787768k total,      128k used, 16787640k free,  6646248k cached
>
> With no mem= in append line (with your patch): 2.6.22-rc4:
>
> top - 17:44:01 up 1 min,  1 user,  load average: 0.97, 0.25, 0.08
> Tasks: 145 total,   1 running, 144 sleeping,   0 stopped,   0 zombie
> Cpu(s):  5.2%us,  3.0%sy,  1.2%ni, 86.8%id,  3.8%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Mem:   8039608k total,   969380k used,  7070228k free,     1232k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   109448k cached
>
> Odd, remote netconsole did not capture the dmesg the E820 memory map.
>
> Jun  6 17:43:03 p34 [   53.598611] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 
> 6 ports 3 Gbps 0x3f impl SATA mode Jun  6 17:43:03 p34 [   53.598683] ahci 
> 0000:00:1f.2: flags: 64bit ncq led clo pio slum part Jun  6 17:43:03 p34 [ 
> 53.598986] scsi0 : ahci Jun  6 17:43:03 p34 [   53.599131] scsi1 : ahci Jun 
> 6 17:43:03 p34 [   53.599239] scsi2 : ahci Jun  6 17:43:03 p34 [   53.599340] 
> scsi3 : ahci Jun  6 17:43:03 p34 [   53.599438] scsi4 : ahci
>
> I will run with this patch for a while but so far, no issues, everything 
> looks great.
>
> Will it make it into 2.6.22-rc5? :)
>
> Justin.
>
