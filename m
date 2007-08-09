Return-Path: <linux-kernel-owner+w=401wt.eu-S934771AbXHIGzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbXHIGzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbXHIGzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:55:03 -0400
Received: from gw.goop.org ([64.81.55.164]:38235 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXHIGzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:55:00 -0400
Message-ID: <46BAB9DD.5030400@goop.org>
Date: Wed, 08 Aug 2007 23:53:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com> <1186546847263-git-send-email-gcosta@redhat.com> <11865468513077-git-send-email-gcosta@redhat.com> <200708081200.13669.ak@suse.de>
In-Reply-To: <200708081200.13669.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +	if (opfunc == NULL)
>> +		/* If there's no function, patch it with a ud2a (BUG) */
>> +		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
>>     
>
> This will actually give corrupted BUGs because you don't supply
> the full inline BUG header. Perhaps another trap would be better.
>   

The BUG handler will still report it as a normal illegal instruction. 
It should never happen; the main thing is that it clearly points out
where the problem is (as opposed to jumping to a NULL pointer and
getting the unhelpful "oh, eip is zero" symptom).

>> +EXPORT_SYMBOL(paravirt_ops);
>>     
>
> Definitely _GPL at least.
>   

No, for the same reason as i386.

>> +extern struct paravirt_ops paravirt_ops;
>>     
>
> Should be native_paravirt_ops I guess
>
>   

No, because its the current set of pv_ops.  It starts all native, but it
is either completely or partially overwritten by hypervisor-specific ops.

>> +
>> + * This generates an indirect call based on the operation type number.
>>     
>
> The macros here don't
>   

Yes, PARAVIRT_CALL does: "call *(paravirt_ops+%c[paravirt_typenum]*8);"


>> +			     : "=a"(f)
>> +			     : paravirt_type(save_fl),
>> +			       paravirt_clobber(CLBR_RAX)
>> +			     : "memory", "cc");
>> +	return f;
>> +}
>> +
>> +static inline void raw_local_irq_restore(unsigned long f)
>> +{
>> +	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
>> +			     :
>> +			     : "D" (f),
>>     
>
> Have you investigated if a different input register generates better/smaller 
> code? I would assume rdi to be usually used already for the caller's 
> arguments so it will produce spilling
>
> Similar for the rax return in the other functions.
>   

This has to match the normal C calling convention though, doesn't it?

    J
