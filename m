Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYBNVHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYBNVHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbYBNVHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:07:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762085AbYBNVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:07:00 -0500
Date: Thu, 14 Feb 2008 22:42:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214214241.GB19473@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <20080214171603.GC16255@one.firstfloor.org> <20080214183819.GA19846@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214183819.GA19846@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 07:38:19PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > this is indeed a bug (we change the attributes for a larger area 
> > > than needed), but your fix is unclean. Find below a cleaner 
> > > solution.
> > 
> > You're still ignoring the other problem of set_memory_uc() not 
> > handling fixmap and ioremap correctly. [...]
> 
> No, we did not ignore it, and yes, you are wrong.
> 
> One thing that you miss is that the 64-bit EFI runtime has to be marked 
> uncacheable only if it the EFI image attribute signals an uncacheable 
> area:
> 
>                 if (!(md->attribute & EFI_MEMORY_WB))
>                         set_memory_uc(md->virt_addr, md->num_pages);
> 
> and Linux EFI does not support device EFI runtimes. So your observation, 

Sorry I didn't get that (you were a bit terse). 

You're saying the EFI BIOSes will never set that flag ?

I'm reading page 123+ of UEFI 2.1 which describes GetMemoryMap() 
and these flags and I see nothing to that effect. I admit I didn't
read the full EFI bible so far so there are certainly EFI
aspects I don't understand.

Can you please clarify why EFI would not set that flag on Linux? 
Can you refer me to the parts of the spec that describe that? 


> Also note that 64-bit EFI runtime support (the ability to execute EFI 
> code) is completely new - it got introduced 14 days ago. We only use 
> fixmaps on 64-bit EFI.

On 32bit it is wrong too I think at least on non default __PAGE_OFFSET
splits.


> 
> 32-bit EFI is more common (but still not very common, compared to other 
> x86 platforms) and that is totally unaffected by secondary aliases. 

Of course it is affected. set_memory_uc() will not fix up the 
direct mapping in this case either. Given the overlap of PCI hole
to direct mapping cases there are more seldom, but certainly
exist (e.g. consider 1:3 split and a 2GB PCI hole) 

And while given that's a relatively obscure case it's a valid regression.

-Andi

