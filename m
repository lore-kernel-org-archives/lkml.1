Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbZEOIMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbZEOIMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZEOIMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:12:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:53891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbZEOIL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:11:56 -0400
Message-ID: <4A0D23A4.30006@kernel.org>
Date: Fri, 15 May 2009 17:11:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap		 allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org> <4A0C46B80200007800000ED4@vpn.id2.novell.com> <4A0C3EF9.4050907@kernel.org> <4A0D3A390200007800001081@vpn.id2.novell.com>
In-Reply-To: <4A0D3A390200007800001081@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:11:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jan Beulich wrote:
>> The whole point of doing the remapping is giving each CPU its own PMD
>> mapping for perpcu area, so, yeah, that's the requirement.  I don't
>> think the requirement is hidden tho.
> 
> No, from looking at the code the requirement seems to only be that you
> get memory allocated from the correct node and mapped by a large page.
> There's nothing said why the final virtual address would need to be large
> page aligned. I.e., with a slight modification to take the NUMA requirement
> into account (I noticed I ignored that aspect after I had already sent that
> mail), the previous suggestion would still appear usable to me.

The requirement is having separate PMD mapping per NUMA node.  What
has been implemented is the simplest form of that - one mapping per
CPU.  Sure it can be further improved with more knowledge of the
topology.  If you're interested, please go ahead.

>>> This would additionally address a potential problem on 32-bits -
>>> currently, for a 32-CPU system you consume half of the vmalloc space
>>> with PAE (on non-PAE you'd even exhaust it, but I think it's
>>> unreasonable to expect a system having 32 CPUs to not need PAE).
>> I recall having about the same conversation before.  Looking up...
>>
>> -- QUOTE --
>>  Actually, I've been looking at the numbers and I'm not sure if the
>>  concern is valid.  On x86_32, the practical number of maximum
>>  processors would be around 16 so it will end up 32M, which isn't
>>  nice and it would probably a good idea to introduce a parameter to
>>  select which allocator to use but still it's far from consuming all
>>  the VM area.  On x86_64, the vmalloc area is obscenely large at 245,
>>  ie 32 terabytes.  Even with 4096 processors, single chunk is measly
>>  0.02%.
> 
> Just to note - there must be a reason we (SuSE/Novell) build our default
> 32-bit kernel with support for 128 CPUs, which now is simply broken.

It's not broken, it will just fall back to 4k allocator.  Also, please
take a look at the refreshed patchset, remap allocator is not used
anymore if it's gonna occupy more than 20% (random number from the top
of my head) of vmalloc area.

>> So, yeah, if there are 32bit 32-way NUMA machines out there, it would
>> be wise to skip remap allocator on such machines.  Maybe we can
>> implement a heuristic - something like "if vm area consumption goes
>> over 25%, don't use remap".
> 
> Possibly, as a secondary consideration on top of the suggested reduction
> of virtual address space consumption.

Yeah, further improvements welcome.  No objection whatsoever there.

Thanks.

-- 
tejun
