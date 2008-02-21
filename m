Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbYBUXRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbYBUXRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYBUXRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:17:12 -0500
Received: from gw.goop.org ([64.81.55.164]:48287 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbYBUXRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:17:11 -0500
Message-ID: <47BE05C0.2090405@goop.org>
Date: Thu, 21 Feb 2008 15:14:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	<20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	<20080215202336.GE26034@mail.oracle.com>	<1203274161.27987.6.camel@localhost.localdomain>	<20080218104025.GA15899@ca-server1.us.oracle.com>	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>	<47BBDA20.8030105@zytor.com>	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>	<47BCA275.7000504@goop.org>	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>	<47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com> <m14pc26k6f.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pc26k6f.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> I thought the problem was a Xen-provided pagetable from before Linux started?
>>     
>
> The immediate symptom was that we have a page table at the address we
> are doing the DMI probe.  Xen does not allow pages tables to be mapped
> read-write so early_ioremap get into trouble.
>   

Correct.

> We have a mystery:
> - Why did the Xen domain builder or the linux kernel use 0xf0000 - 0x10000
>   for a page table.
>   

It didn't.  Ian confirmed the allocation comes from the kernel's 
pagetable setup.  The domain builder always puts pagetables after the 
kernel, so over 1M.

>   It should be possible to instrument the early linux page allocation
>   and see what page pages linux is using to see who is doing weird
>   things.
>   

Linux.  Which suggests a latent bug.

> We have possible solutions.
> - Add a read-only flag to early_ioremap for use by our table scans.
> - Don't do a DMI scan in the case of Xen.
> - Fix the Xen domain builder.
>   

1 or 2.  3 is not a problem.

> All of that said.  For DMI tables other early tables we should not
> be writing to them anyway so learning to use read-only maps may be
> the right solution.  If the reason Xen was complaining was that
> we were accessing an area that was not page tables but instead
> should only be mapped read-only I would have a lot of sympathy
> with that.  As mapping areas that are architecturally ROMs read-write
> is silly.
>   

For PV guests, Xen itself isn't really interested in any of the platform 
bios/hardware (not even acknowledging its existence, let alone emulate 
anything).  Definitely no magic memory ranges or scanning for 
signatures.  The in-kernel Xen support has made some concessions to that 
sort of stuff, by making sure various memory ranges are valid to be 
scanned, even if they don't contain anything meaningful.  We could do 
something like that for DMI if that turns out to be the best answer.

> So guys can you please finish the root cause and really see why there
> is a page table page at in 64K ROM BIOS area?
>   

It seems to me that those pages are being handed out as heap pages by 
the early allocator.  In the Xen case this is OK because there's nothing 
magic about them.  But if real hardware doesn't reserve these pages in 
the E820 map, then they could end up being used as regular memory by 
mistake, which is an issue.

    J
