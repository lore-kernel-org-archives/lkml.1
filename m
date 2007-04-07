Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXDGAEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXDGAEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXDGAEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:04:24 -0400
Received: from gw.goop.org ([64.81.55.164]:42565 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbXDGAEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:04:22 -0400
Message-ID: <4616DFB2.4020802@goop.org>
Date: Fri, 06 Apr 2007 17:02:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD sharing
References: <20070404191151.009821039@goop.org>	<20070404191205.392155702@goop.org> <20070406164139.08cd343b.akpm@linux-foundation.org>
In-Reply-To: <20070406164139.08cd343b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> All this paravirt stuff isn't making the kernel any prettier, is it?
>   

You're too kind.  wli's comment on the first version of this patch was
something along the lines of "this patch causes a surprising amount of
damage for what little it achieves".

>> ...
>>  
>> -#ifndef CONFIG_X86_PAE
>> -void vmalloc_sync_all(void)
>> +void _vmalloc_sync_all(void)
>>  {
>>  	/*
>>  	 * Note that races in the updates of insync and start aren't
>> @@ -600,6 +599,8 @@ void vmalloc_sync_all(void)
>>  	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
>>  	static unsigned long start = TASK_SIZE;
>>  	unsigned long address;
>> +
>> +	BUG_ON(SHARED_KERNEL_PMD);
>>  
>>  	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
>>  	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
>> @@ -623,4 +624,3 @@ void vmalloc_sync_all(void)
>>  			start = address + PGDIR_SIZE;
>>  	}
>>  }
>>     
>
> This is a functional change for non-paravirt kernels.  Non-PAE kernels now
> get a vmalloc_sync_all().  How come?
>   

You mean PAE kernels get a vmalloc_sync_all?

When we're in PAE mode, but SHARED_KERNEL_PMD is false (which is true
for Xen, but not for native execution), then the kernel mappings are not
implicitly shared between processes.  This means that the vmalloc
mappings are not shared, and so need to be explicitly synchronized
between pagetables, like in the !PAE case.

> We normally use double-underscore for things like this.
>   

OK.

> Your change clashes pretty fundamantally with
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch,
> and
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/move-die-notifier-handling-to-common-code.patch
> _does_ make the kernel prettier.
>   

Hm, it doesn't look like a deep clash.  Dropping the inline function and
just putting the "if (SHARED_KERNEL_PMD) return;" at the start of the
real vmalloc_sync_all() would work fine.

And I like vmalloc_sync_all() being a non-arch-specific interface; it
cleans up another of the xen patches.

> But I'm a bit reluctant to rework
> move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
> (somehow) until I understand why your patch is a) futzing with non-PAE,
> non-paravirt code

There should be no functional difference for non-paravirt code, PAE or
non-PAE.

>  and b) overengineered.
>   

Overall, or just this bit?

> Why didn't you just stick a
>
> 	if (SHARED_KERNEL_PMD)
> 		return;
>
> into vmalloc_sync_all()?
>   

That would work, but when building !PARAVIRT && PAE, SHARED_KERNEL_PMD
is just constant 1, so it would end up making a pointless function
call.  With the wrapper, the call disappears entirely.  It probably
doesn't matter, but I didn't want anyone to complain about making the
!PARAVIRT generated code worse (hi, Ingo!).

However, if you're making vmalloc_sync_all a weak function anyway, then
there's no difference with the paravirt patches in place.  The

	if (SHARED_KERNEL_PMD)
		return;

will evaluate to

	if (1)
		return;

    J
