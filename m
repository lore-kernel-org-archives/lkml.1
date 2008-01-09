Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYAIBY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYAIBY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYAIBYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:24:18 -0500
Received: from gw.goop.org ([64.81.55.164]:55953 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYAIBYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:24:18 -0500
Message-ID: <478421A6.6050109@goop.org>
Date: Tue, 08 Jan 2008 17:21:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <20080109004329.GA6603@elte.hu> <47841EB1.1020304@goop.org> <20080109011609.GB29807@elte.hu>
In-Reply-To: <20080109011609.GB29807@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This isn't correct, because it will set _PAGE_GLOBAL on 32-bit 
>> unconditionally.  It needs to be something like:
>>     
>
> hm, why is that a problem? Ah, the VDSO page must not be global-mapped, 
> right? It's getting late here, i should stop modifying the kernel ;)
>   

No, because old processors don't support global pages, and the 32-bit 
setup code makes sure to only set _PAGE_GLOBAL in __PAGE_KERNEL once it 
has been identified, whereas 64-bit can assume its always present.

Erk.  Hm.  The old pgtable_64.h defines both PAGE_KERNEL_VSYSCALL, which 
is global, and PAGE_KERNEL_VSYSCALL32 which is not.  However, it looks 
like PAGE_KERNEL_VSYSCALL is used exactly once in setting up a fixmap, 
and PAGE_KERNEL_VSYSCALL32 is not used at all.

>> +#define GLOBAL_PGPROT(prot)	__pgprot(prot | _PAGE_GLOBAL)
>> +
>> +#define PAGE_KERNEL			GLOBAL_PGPROT(__PAGE_KERNEL)
>> +#define PAGE_KERNEL_RO			GLOBAL_PGPROT(__PAGE_KERNEL_RO)
>> +#define PAGE_KERNEL_EXEC		GLOBAL_PGPROT(__PAGE_KERNEL_EXEC)
>> +#define PAGE_KERNEL_RX			GLOBAL_PGPROT(__PAGE_KERNEL_RX)
>> +#define PAGE_KERNEL_NOCACHE		GLOBAL_PGPROT(__PAGE_KERNEL_NOCACHE)
>> +#define PAGE_KERNEL_LARGE		GLOBAL_PGPROT(__PAGE_KERNEL_LARGE)
>> +#define PAGE_KERNEL_LARGE_EXEC		GLOBAL_PGPROT(__PAGE_KERNEL_LARGE_EXEC)
>> +#define PAGE_KERNEL_VSYSCALL		GLOBAL_PGPROT(__PAGE_KERNEL_VSYSCALL)
>> +#define PAGE_KERNEL_VSYSCALL_NOCACHE	GLOBAL_PGPROT(__PAGE_KERNEL_VSYSCALL_NOCACHE)
>>     
>
> i suspect you wanted to make GLOBAL_PGPROT a NOP on 32-bit?
>   

Yeah, cut'n'paste from a stale buffer.

> but i think it would be better to just do this distinction for the 
> PAGE_KERNEL_VSYSCALL?
>   

?  The _PAGE_GLOBAL issue is distinct from the VSYSCALL one.

    J
