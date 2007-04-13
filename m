Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXDMU1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXDMU1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXDMU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:27:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042AbXDMU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:27:20 -0400
Message-ID: <461FE77A.6020307@zytor.com>
Date: Fri, 13 Apr 2007 13:26:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com>
In-Reply-To: <461FE36D.1050205@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
>> It seems to me that the problem is simply that it runs out of space. 
>> head.S maps 8Mbytes of memory.

8 MB was a long time ago.
head.S maps the kernel size plus INIT_MAP_BEYOND_END, which is currently 
set to 128K.

   The kernel takes ~6.8M of that, and
>> there simply isn't enough remaining space to fit the pagetables to map
>> all memory into the kernel address space.  Here's my dump of all pte
>> allocations.  Notice the jump at c070b000 where skips over the kernel,
>> and then it just runs into the 8M limit.  This is with CONFIG_PARAVIRT,
>> but no CONFIG_XEN.
>>
>> I don't see why this doesn't happen all the time; I can't see anything
>> about this which is PARAVIRT-specific.  But I think only specific
>> combinations of memory size and kernel size can trigger the problem,
>> because the code in head.S will often end up mapping enough memory to
>> fit everything in.  It tries to map kernelsize+initial_pagetables+128k
>> of space; in this case it happens to map 8M, but if the kernel were much
>> larger it would map 12M.
>>
>> But surely this must have been seen before?  Or is there something
>> subtle I'm missing?
>>   
> 
> Wow, that is a huge kernel.  No wonder I've never seen this.  Seems when 
> you go over 6meg there will be a problem.  For PAE, this requires page 
> tables to map up to about 896 of lowmem - each page table can map 2 meg 
> of memory, so you need up to 448 page tables, or 1792k of page table 
> memory - adding 16k for pmd tables, this comes to 1808k.  With 6.24M 
> kernel, you simply will run out of space to map all of lowmem in 8M.
 >
> With 6.8M PAE kernel, 608M of lowmem mappings will cause you to go 
> beyond 8M of initially mapped space.  Non-PAE kernels will be ok until 
> you get to a kernel size of about 7.04M.

This means INIT_MAP_BEYOND_END is set incorrectly.

> Note you can always run out of space; to ensure safety, the init code 
> needs to not use a fixed mapping size, it needs to map 
> end_kernel_address + pae ? 1808k : 896k, assuming 128M vmalloc hole.

Really (pae ? 2M : 1M), in other words, plus the 128K for bootmem.  Note 
that this is creating page tables for, not erasing.  To map 2M, we will 
only use 2K of additional memory (meaning there is 50% chance we end up 
using an additional 4K page.)

So the solution is simply to change INIT_MAP_BEYOND_END in head.S 
appropriately.

> This could cause problems like running into initrd, however, so might 
> require loader changes, or perhaps relocating the initrd.  Is the 
> solution to just cap the kernel size at some fixed maximum?  6.2M 
> appears to be the safe limit for all configurations.

The initrd is supposed to be loaded as far away from the kernel as 
possible.  Mapping 2M hardly seems like a problem.  When we set up the 
memory manager we actively have to watch out for the pages that belong 
to the initrd anyway.  I have on my list to be able to pull initrd out 
of highmem; that way the bootloader can always load the initrd from end 
of memory.

> I'm pulling this back onto lkml; seems this is a serious bug which needs 
> attention.  I've also cc'd some parties that might have relevant 
> knowledge.  Why do I seem to recall head.S mapping 128M of mappings at 
> one point in time?

You're probably confusing it with the 128K number, which was set to fit 
the maximum possible memory for the bootmem pagetables.

	-hpa
