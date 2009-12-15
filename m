Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbZLOVvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbZLOVvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760448AbZLOVvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:51:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:44131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760441AbZLOVvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:51:13 -0500
Message-ID: <4B280492.5070205@kernel.org>
Date: Tue, 15 Dec 2009 13:50:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       rientjes@google.com
Subject: Re: kexec boot regression
References: <4B27EE38.1050103@kernel.org> <20091215201909.GY28252@kernel.dk> <4B27EFC2.1000505@kernel.org> <20091215204221.GZ28252@kernel.dk> <20091215205512.GA28252@kernel.dk> <20091215210126.GB28252@kernel.dk> <4B27FEFB.30902@kernel.org> <20091215213032.GC28252@kernel.dk> <20091215214009.GD28252@kernel.dk> <4B2802E4.40404@kernel.org> <20091215214743.GE28252@kernel.dk>
In-Reply-To: <20091215214743.GE28252@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Dec 15 2009, Yinghai Lu wrote:
>> Jens Axboe wrote:
>>> On Tue, Dec 15 2009, Jens Axboe wrote:
>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>> Jens Axboe wrote:
>>>>>> On Tue, Dec 15 2009, Jens Axboe wrote:
>>>>>>> On Tue, Dec 15 2009, Jens Axboe wrote:
>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>> Jens Axboe wrote:
>>>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>>>> Jens Axboe wrote:
>>>>>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>>>>>> Jens Axboe wrote:
>>>>>>>>>>>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>>>>>>>>> [PATCH] x86/pci: intel ioh bus num reg accessing fix
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> it is above 0x100, so if mmconf is not enable, need to skip it
>>>>>>>>>>>>>> This works, it kexecs kernels fine. But since 2.6.32 doesn't have the
>>>>>>>>>>>>>> mmconf problem to begin with, are we now just working around the issue?
>>>>>>>>>>>>>> SRAT still reports issues, numa doesn't work.
>>>>>>>>>>>>> that patch will be bullet proof... we need it.
>>>>>>>>>>>>>
>>>>>>>>>>>>> also still need to figure out why memmap range is not passed properly.
>>>>>>>>>>>>>
>>>>>>>>>>>>> do you mean 2.6.32 kexec 2.6.32 it have worked mmconf and numa in
>>>>>>>>>>>>> second kernel?
>>>>>>>>>>>> Yes, 2.6.32 booted and 2.6.32 kexec'ed works just fine, no SRAT
>>>>>>>>>>>> complaints and NUMA works fine.
>>>>>>>>>>> do you need 
>>>>>>>>>>> memmap=62G@4G
>>>>>>>>>>> in this case?
>>>>>>>>>> Yes, I've needed that always.
>>>>>>>>> good,
>>>>>>>>>
>>>>>>>>> can you enable debug option in kexec to see why kexec can not pass
>>>>>>>>> whole 38? range to second kernel?
>>>>>>>> Not getting any output so far, -d doesn't do much. Poking around in the
>>>>>>>> source...
>>>>>>> OK, cold boot and kexec 2.0.1 gets all 39 ranges passed properly to
>>>>>>> kexec'ed kernels. Since the older kexec stopped at range 30 (31 ranges
>>>>>>> total), that smells like just a kexec bug. Retesting -git...
>>>>>> Current -git works fine when all the ranges are passed correctly. So, I
>>>>>> think, the only existing regression is the SRAT issue.
>>>>> did you change node_shift?
>>>> Yes:
>>>>
>>>> CONFIG_NODES_SHIFT=6
>>>>
>>>> What I don't get is that 2.6.32 and -git print the same PXM map, and in
>>>> both cases it's totalling exactly 64G. Yet it says:
>>>>
>>>> SRAT: PXMs only cover 49035MB of your 65419MB e820 RAM. Not used.
>>> Clue:
>>>
>>> [    0.000000] SRAT: Node 0 PXM 0 0-80000000
>>> [    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
>>> [    0.000000] SRAT: Node 2 PXM 1 480000000-880000000
>>> [    0.000000] SRAT: Node 1 PXM 2 880000000-c80000000
>>> [    0.000000] SRAT: Node 3 PXM 3 c80000000-1080000000
>>> [    0.000000] NUMA: Using 31 for the hash shift.
>>> [    0.000000] pxm0: 0-480000 (4718592), absent 553990
>>> [    0.000000] pxm1: 880000-c80000 (4194304), absent 0
>>> [    0.000000] pxm2: 480000-880000 (4194304), absent 4194304
>>> [    0.000000] pxm3: c80000-1080000 (4194304), absent 0
>>> [    0.000000] SRAT: PXMs only cover 49035MB of your 65419MB e820 RAM.  Not used.
>>> [    0.000000] SRAT: SRAT not used.
>>>
>> oh, i post one patch last week, 
>>
>> can you check it?
> 
> Sure, let me try it. I already found out that commit 8716273c is the
> guilty one (x86: Export srat physical topology).

ok, my patch should fix that.

YH
