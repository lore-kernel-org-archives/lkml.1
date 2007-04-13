Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXDMUMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXDMUMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXDMUMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:12:12 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38273 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473AbXDMUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:12:11 -0400
Message-ID: <461FE36D.1050205@vmware.com>
Date: Fri, 13 Apr 2007 13:09:17 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org>
In-Reply-To: <461FD97B.1010203@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> It seems to me that the problem is simply that it runs out of space. 
> head.S maps 8Mbytes of memory.  The kernel takes ~6.8M of that, and
> there simply isn't enough remaining space to fit the pagetables to map
> all memory into the kernel address space.  Here's my dump of all pte
> allocations.  Notice the jump at c070b000 where skips over the kernel,
> and then it just runs into the 8M limit.  This is with CONFIG_PARAVIRT,
> but no CONFIG_XEN.
>
> I don't see why this doesn't happen all the time; I can't see anything
> about this which is PARAVIRT-specific.  But I think only specific
> combinations of memory size and kernel size can trigger the problem,
> because the code in head.S will often end up mapping enough memory to
> fit everything in.  It tries to map kernelsize+initial_pagetables+128k
> of space; in this case it happens to map 8M, but if the kernel were much
> larger it would map 12M.
>
> But surely this must have been seen before?  Or is there something
> subtle I'm missing?
>   

Wow, that is a huge kernel.  No wonder I've never seen this.  Seems when 
you go over 6meg there will be a problem.  For PAE, this requires page 
tables to map up to about 896 of lowmem - each page table can map 2 meg 
of memory, so you need up to 448 page tables, or 1792k of page table 
memory - adding 16k for pmd tables, this comes to 1808k.  With 6.24M 
kernel, you simply will run out of space to map all of lowmem in 8M.

With 6.8M PAE kernel, 608M of lowmem mappings will cause you to go 
beyond 8M of initially mapped space.  Non-PAE kernels will be ok until 
you get to a kernel size of about 7.04M.

Note you can always run out of space; to ensure safety, the init code 
needs to not use a fixed mapping size, it needs to map 
end_kernel_address + pae ? 1808k : 896k, assuming 128M vmalloc hole.  
This could cause problems like running into initrd, however, so might 
require loader changes, or perhaps relocating the initrd.  Is the 
solution to just cap the kernel size at some fixed maximum?  6.2M 
appears to be the safe limit for all configurations.

I'm pulling this back onto lkml; seems this is a serious bug which needs 
attention.  I've also cc'd some parties that might have relevant 
knowledge.  Why do I seem to recall head.S mapping 128M of mappings at 
one point in time?

Zach
