Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbXBPGze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbXBPGze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXBPGze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:55:34 -0500
Received: from gw.goop.org ([64.81.55.164]:38917 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbXBPGzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:55:33 -0500
Message-ID: <45D55565.4020206@goop.org>
Date: Thu, 15 Feb 2007 22:55:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 10/21] Xen-paravirt: add hooks to intercept mm creation
 and destruction
References: <20070216022449.739760547@goop.org>	<20070216022531.267584466@goop.org> <20070215223409.eea8f1e3.akpm@linux-foundation.org>
In-Reply-To: <20070215223409.eea8f1e3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 18:24:59 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Add hooks to allow a paravirt implementation to track the lifetime of
>> an mm.
>>
>> --- a/arch/i386/kernel/paravirt.c
>> +++ b/arch/i386/kernel/paravirt.c
>> @@ -706,6 +706,10 @@ struct paravirt_ops paravirt_ops = {
>>  	.irq_enable_sysexit = native_irq_enable_sysexit,
>>  	.iret = native_iret,
>>  
>> +	.dup_mmap = (void *)native_nop,
>> +	.exit_mmap = (void *)native_nop,
>> +	.activate_mm = (void *)native_nop,
>> +
>>  	.startup_ipi_hook = (void *)native_nop,
>>  };
>>     
>
> eww.  I suppose there's a good reason for the casting.
>   

Yeah, it's a bit ugly.  The alternative is to have a separate
correctly-typed nop function for each operation.  But that's even more
typing.

> It seems strange to call out to arch_foo() from within an arch header file.
> I mean, we implicity know we're i386.
>
> Maybe it's just poorly named.
>   

The other two are arch_* and are called from common code. 
arch_activate_mm() is either empty or a call to
paravirt_ops.activate_mm.  I could name it paravirt_activate_mm (as it
was in earlier versions of this patch), but then it would be
inconsistent with the other functions.  I thought the consistency was
more important, because these calls need to be properly matched.

>> +static inline void paravirt_activate_mm(struct mm_struct *prev,
>> +					struct mm_struct *next)
>> +{
>> +}
>> +
>> +static inline void paravirt_dup_mmap(struct mm_struct *oldmm,
>> +				     struct mm_struct *mm)
>> +{
>> +}
>> +
>> +static inline void paravirt_exit_mmap(struct mm_struct *mm)
>> +{
>> +}
>>     
>
> These functions are unreferenced in this patchset.
>   

OK, I'll drop them.

>>  #endif /* CONFIG_PARAVIRT */
>>  #endif	/* __ASM_PARAVIRT_H */
>> ===================================================================
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -374,6 +374,12 @@ struct mm_struct {
>>  	rwlock_t		ioctx_list_lock;
>>  	struct kioctx		*ioctx_list;
>>  };
>> +
>> +#ifndef __HAVE_ARCH_MM_LIFETIME
>> +#define arch_activate_mm(prev, next)	do {} while(0)
>> +#define arch_dup_mmap(oldmm, mm)	do {} while(0)
>> +#define arch_exit_mmap(mm)		do {} while(0)
>> +#endif
>>     
>
> Can we lose __HAVE_ARCH_MM_LIFETIME?  Just define these (preferably in C,
> not in cpp) in the appropriate include/asm-foo/ files?
>   

I guess, if you want.  For everything except i386 (and x86_64 in the not
too distant future) they'll be noops.  But for consistency, I/we would
have to put the appropriate arch_activate_mm() into each arch's
activate_mm(); I seem to remember some were not as straightforward as i386.

>>  struct sighand_struct {
>>  	atomic_t		count;
>> ===================================================================
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -286,6 +286,7 @@ static inline int dup_mmap(struct mm_str
>>  		if (retval)
>>  			goto out;
>>  	}
>> +	arch_dup_mmap(oldmm, mm);
>>  	retval = 0;
>>  out:
>>  	up_write(&mm->mmap_sem);
>> ===================================================================
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -1976,6 +1976,8 @@ void exit_mmap(struct mm_struct *mm)
>>  	struct vm_area_struct *vma = mm->mmap;
>>  	unsigned long nr_accounted = 0;
>>  	unsigned long end;
>> +
>> +	arch_exit_mmap(mm);
>>  
>>  	lru_add_drain();
>>  	flush_cache_mm(mm);
>>     
>
> Perhaps some commentary telling the arch maintainer what these hooks he's
> being offered are for?
>   

OK.

    J
