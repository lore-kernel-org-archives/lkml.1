Return-Path: <linux-kernel-owner+w=401wt.eu-S935650AbYBUXSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935650AbYBUXSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbYBUXSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:18:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbYBUXSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:18:15 -0500
Message-ID: <47BE0228.7020204@zytor.com>
Date: Thu, 21 Feb 2008 14:58:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ian Campbell <ijc@hellion.org.uk>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	 <20080215202336.GE26034@mail.oracle.com>	 <1203274161.27987.6.camel@localhost.localdomain>	 <20080218104025.GA15899@ca-server1.us.oracle.com>	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>	 <47BBDA20.8030105@zytor.com>	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>	 <47BCA275.7000504@goop.org>	 <1203546597.26910.74.camel@cthulhu.hellion.org.uk>	 <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>	 <47BDEF36.8000903@goop.org> <1203631956.28436.4.camel@cthulhu.hellion.org.uk> <47BDF9C7.6040400@zytor.com> <47BE0017.1020205@goop.org>
In-Reply-To: <47BE0017.1020205@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> What is the e820 information you feed the kernel?  We should only ever 
>> allocate page tables out of available RAM, not any other type of 
>> memory (reserved or not). 
> 
> The kernel gets a flat memory map; all memory is just plain RAM.  The 
> problem is that we're allocating a normal page and turning it into a 
> pagetable - so far so good.  Then the DMI code is randomly mapping that 
> same page RW so it can scan it for DMI signatures, which Xen is preventing.
> 
> There are two immediate fixes:
> 
>   1. Only scan for DMI if the memory is reserved (rejected, because HPA
>      says some machines don't reserve the DMI space).  Alternatively,
>      don't bother scanning if booting under Xen.
>   2. Make DMI map the memory RO so that Xen doesn't complain (which is
>      sensible because DMI is ROM anyway).
> 
> But as far as I can tell, this shouldn't be happening anyway, and could 
> happen on real hardware which doesn't reserve the DMI space.  It 
> probably doesn't because initial pagetables on real hardware use large 
> pages, and therefore allocate less memory for pagetable memory and 
> therefore doesn't end up hitting the 0xf0000 region.  But that area 
> should be excluded from the allocation pool.
> 

Which it is on real hardware, because although it's not *reserved* (type 
2), it is certainly not made available as *normal memory* (type 1).  If 
Xen maps this as type 1 then I definitely see the problem.

We can exclude type 1 memory from DMI scan, certainly.

However, Xen may want to consider why provide memory below the 1 MB 
point at all, and certainly whether it's wise to provide RAM in the 
640-1024 KB legacy region -- although you could argue that "it *should* 
work", odds are pretty good you'll have nasty surprises on a regular basis.

	-hpa

