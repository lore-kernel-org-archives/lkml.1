Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZBFP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZBFP5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZBFP5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:57:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59673 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZBFP5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:57:13 -0500
Message-ID: <498C5DDB.70808@redhat.com>
Date: Fri, 06 Feb 2009 10:57:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [BUGFIX][PATCH -rc/-mm] prevent kprobes from catching spurious
 page  faults
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com> <20090128181053.GC9908@Krystal> <498B6457.20302@redhat.com> <20090205235727.GA16040@elte.hu>
In-Reply-To: <20090205235727.GA16040@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> -	if (notify_page_fault(regs))
>> -		return;
>>  	if (unlikely(kmmio_fault(regs, address)))
>>  		return;
>>
>> @@ -634,6 +632,9 @@ void __kprobes do_page_fault(struct pt_r
>>  		if (spurious_fault(address, error_code))
>>  			return;
>>
>> +		/* kprobes don't want to hook the spurious faults. */
>> +		if (notify_page_fault(regs))
>> +			return;
>>  		/*
>>  		 * Don't take the mm semaphore here. If we fixup a prefetch
>>  		 * fault we could otherwise deadlock.
>> @@ -641,6 +642,9 @@ void __kprobes do_page_fault(struct pt_r
>>  		goto bad_area_nosemaphore;
>>  	}
>>
>> +	/* kprobes don't want to hook the spurious faults. */
>> +	if (notify_page_fault(regs))
>> +		return;
> 
> I dont know - this spreads that callback to two places now. Any
> reason why kprobes cannot call spurious_fault(), if there's a
> probe active?

Hmm, because I think how the spurious faults are treated depends on
do_page_fault(). Calling spurious_fault() and vmalloc_fault() in
kprobe_fault_handler() is just spreading another code different way...

> Also, moving that would remove the planned cleanup of merging these
> two into one call:
> 
>  	if (notify_page_fault(regs))
>  		return;
>   	if (unlikely(kmmio_fault(regs, address)))
>   		return;

Sure, that is reasonable, if kmmio also want not catch spurious fault too.

> We should reduce the probing cross section, not increase it,
> especially in such a critical codepath as the pagefault handler.

I think my patch doesn't increase it, the first path jumps to
bad_area_nosemaphore right after calling notify_page_fault().

> 
> Btw., why cannot kprobes install a dynamic probe to the fault
> handler itself? That way the default path would have no such
> callbacks and checks at all.

because kprobe_fault_handler() is implemented not only for the
user fault handler but also for fixup page-fault ip during
single step out-of-line. It's an elemental part of kprobes.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

