Return-Path: <linux-kernel-owner+w=401wt.eu-S934472AbYBUWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbYBUWxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYBUWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:53:07 -0500
Received: from gw.goop.org ([64.81.55.164]:40230 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbYBUWxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:53:05 -0500
Message-ID: <47BE0017.1020205@goop.org>
Date: Thu, 21 Feb 2008 14:49:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	 <20080215202336.GE26034@mail.oracle.com>	 <1203274161.27987.6.camel@localhost.localdomain>	 <20080218104025.GA15899@ca-server1.us.oracle.com>	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>	 <47BBDA20.8030105@zytor.com>	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>	 <47BCA275.7000504@goop.org>	 <1203546597.26910.74.camel@cthulhu.hellion.org.uk>	 <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>	 <47BDEF36.8000903@goop.org> <1203631956.28436.4.camel@cthulhu.hellion.org.uk> <47BDF9C7.6040400@zytor.com>
In-Reply-To: <47BDF9C7.6040400@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ian Campbell wrote:
>> On Thu, 2008-02-21 at 13:37 -0800, Jeremy Fitzhardinge wrote:
>>> H. Peter Anvin wrote:
>>>>> Still curious about why a pagetable page is ending up in that 
>>>>> range though.  Seems like it shouldn't be possible, since we 
>>>>> shouldn't be allowed to allocate from those pages, at least until 
>>>>> the DMI probe has happened...  Unless the early allocator is only 
>>>>> excluded from e820 reserved pages, which would cause a problem on 
>>>>> systems which don't reserve the DMI space...  HPA?
>>>>>
>>>> I thought the problem was a Xen-provided pagetable from before 
>>>> Linux started? 
>>> Hm, I don't think so.  The domain-builder pagetable is put after the 
>>> kernel, so it shouldn't be under 1M.
>>
>> I can confirm that it is Linux which is allocating it. The call path:
>>         # xm create -c debian-x86_32p-1
>>         Using config file "/etc/xen/debian-x86_32p-1".
>>         Started domain debian-1
>>         xen_alloc_pt_init PFN f0
>>         Pid: 0, comm: swapper Not tainted 2.6.25-rc2 #68
>>          [<c02ecb6b>] xen_alloc_pt_init+0x4b/0x60
>>          [<c02f5e2b>] one_page_table_init+0x8b/0xf0
>>          [<c02f63df>] paging_init+0x3bf/0x520
>>          [<c02ee444>] setup_arch+0x2a4/0x410
>>          [<c02e9a64>] start_kernel+0x64/0x380
>>          [<c02efd7f>] cpu_detect+0x6f/0xf0
>>          [<c02ed1a1>] xen_start_kernel+0x2f1/0x310
>>          =======================
>>         Entering add_active_range(0, 0, 262144) 0 entries of 256 used
>>         Zone PFN ranges:
>>           DMA             0 ->     4096
>>
>
> What is the e820 information you feed the kernel?  We should only ever 
> allocate page tables out of available RAM, not any other type of 
> memory (reserved or not). 

The kernel gets a flat memory map; all memory is just plain RAM.  The 
problem is that we're allocating a normal page and turning it into a 
pagetable - so far so good.  Then the DMI code is randomly mapping that 
same page RW so it can scan it for DMI signatures, which Xen is preventing.

There are two immediate fixes:

   1. Only scan for DMI if the memory is reserved (rejected, because HPA
      says some machines don't reserve the DMI space).  Alternatively,
      don't bother scanning if booting under Xen.
   2. Make DMI map the memory RO so that Xen doesn't complain (which is
      sensible because DMI is ROM anyway).

But as far as I can tell, this shouldn't be happening anyway, and could 
happen on real hardware which doesn't reserve the DMI space.  It 
probably doesn't because initial pagetables on real hardware use large 
pages, and therefore allocate less memory for pagetable memory and 
therefore doesn't end up hitting the 0xf0000 region.  But that area 
should be excluded from the allocation pool.

    J
