Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZBFQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZBFQbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZBFQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:31:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbZBFQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:31:06 -0500
Message-ID: <498C65BB.3000003@redhat.com>
Date: Fri, 06 Feb 2009 11:30:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [BUGFIX][PATCH -rc/-mm] prevent kprobes from catching spurious
 page  faults
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com> <20090128181053.GC9908@Krystal> <498B6457.20302@redhat.com> <20090205235727.GA16040@elte.hu> <20090206011320.GA7161@Krystal>
In-Reply-To: <20090206011320.GA7161@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>
>>> -	if (notify_page_fault(regs))
>>> -		return;
>>>  	if (unlikely(kmmio_fault(regs, address)))
>>>  		return;
>>>
>>> @@ -634,6 +632,9 @@ void __kprobes do_page_fault(struct pt_r
>>>  		if (spurious_fault(address, error_code))
>>>  			return;
>>>
>>> +		/* kprobes don't want to hook the spurious faults. */
>>> +		if (notify_page_fault(regs))
>>> +			return;
>>>  		/*
>>>  		 * Don't take the mm semaphore here. If we fixup a prefetch
>>>  		 * fault we could otherwise deadlock.
>>> @@ -641,6 +642,9 @@ void __kprobes do_page_fault(struct pt_r
>>>  		goto bad_area_nosemaphore;
>>>  	}
>>>
>>> +	/* kprobes don't want to hook the spurious faults. */
>>> +	if (notify_page_fault(regs))
>>> +		return;
>> I dont know - this spreads that callback to two places now. Any
>> reason why kprobes cannot call spurious_fault(), if there's a
>> probe active?
>>
>> Also, moving that would remove the planned cleanup of merging these
>> two into one call:
>>
>>  	if (notify_page_fault(regs))
>>  		return;
>>   	if (unlikely(kmmio_fault(regs, address)))
>>   		return;
>>
>> We should reduce the probing cross section, not increase it,
>> especially in such a critical codepath as the pagefault handler.
>>
>> Btw., why cannot kprobes install a dynamic probe to the fault
>> handler itself? That way the default path would have no such
>> callbacks and checks at all.
>>
> 
> Or we could simply merge my 2 LTTng page fault handler tracepoints per
> architecture and be done with it ?

As you can see, these functions are a kind of fixup code.
If it succeed fixup a fault, do_page_fault() has to return because
the fault is fixed.

Since tracepoint itself is just a watchpoint, it should not
change code path. So, I think just moving kmmio_fault() to
notify_page_fault() is enough.

> I'd need to clean up the patchset a little bit to fold a few patches,
> but that would be straightforward enough.

Anyway, I agree with the idea to push tracepoint in the pagefault.
It is very useful for watching system behavior.

Thanks!


> 
> Mathieu
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

