Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYKYSnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYKYSnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYKYSmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:42:55 -0500
Received: from smtp-out.google.com ([216.239.45.13]:42334 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYKYSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:42:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=HTKfVNIj+0dLlPNV8fGOeuYO9a1AcQIuHWPrX2K9ca0FQxv1tzsgXcP/Z/zG6uL8N
	Kr2uTnur+ugNH7ZelvqVg==
MIME-Version: 1.0
In-Reply-To: <20081123091843.GK30453@elte.hu>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com>
	 <20081123091843.GK30453@elte.hu>
Date: Tue, 25 Nov 2008 10:42:47 -0800
Message-ID: <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, Mike Waychison <mikew@google.com>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ingo for your comments and now i am working on V2 which should
be posted later today.

On Sun, Nov 23, 2008 at 1:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ying Han <yinghan@google.com> wrote:
>
>> page fault retry with NOPAGE_RETRY
>
> Interesting patch.
Thank you, glad to know that.
>
>> Allow major faults to drop the mmap_sem read lock while waitting for
>> synchronous disk read. This allows another thread which wishes to grab
>> down_read(mmap_sem) to proceed while the current is waitting the disk IO.
>
> Do you mean down_write()? down_read() can already be nested
> arbitrarily.
fixed. it should be down_write()

>> The patch flags current->flags to PF_FAULT_MAYRETRY as identify that
>> the caller can tolerate the retry in the filemap_fault call patch.
>>
>> Benchmark is done by mmap in huge file and spaw 64 thread each
>> faulting in pages in reverse order, the the result shows 8%
>> porformance hit with the patch.
>
> I suspect we also want to see the cases where this change helps?
i am working on more benchmark to show performance improvement.
>
> Also, constructs like this are pretty ugly:
>
>> +#ifdef CONFIG_X86_64
>> +asmlinkage
>> +#endif
>> +void do_page_fault(struct pt_regs *regs, unsigned long error_code)
>> +{
>> +     current->flags |= PF_FAULT_MAYRETRY;
>> +     __do_page_fault(regs, error_code);
>> +     current->flags &= ~PF_FAULT_MAYRETRY;
>> +}
>
> This seems to be unnecessary runtime overhead to pass in a flag to
> handle_mm_fault(). Why not extend the 'write' flag of
> handle_mm_fault() to also signal "arch is able to retry"?
thanks and fixed in V2

>
> Also, _if_ we decide that from-scratch pagefault retries are good, i
> see no reason why this should not be extended to all architectures:
>
> The retry should happen purely in the MM layer - all information is
> available already, and much of do_page_fault() could generally be
> moved into mm/memory.c, with one or two arch-provided standard
> callbacks to express certain page fault quirks. (such as vm86 mode on
> x86)
>
> (Such a design would allow more nice cleanups - handle_mm_fault()
> could inline inside the pagefault handler, etc.)
I will make the megapatch in V2 for each architecture support and send
to Andrew,
linux-kernel and linux-arch. thanks.

>
> Also, a few small details. Please use this proper multi-line comment
> style:
>
>> +                     /*
>> +                      * Page is already locked by someone else.
>> +                      *
>> +                      * We don't want to be holding down_read(mmap_sem)
>> +                      * inside lock_page(). We use wait_on_page_lock here
>> +                      * to just wait until the page is unlocked, but we
>> +                      * don't really need
>> +                      * to lock it.
>> +                      */
thanks and fixed.
> Not this one:
>
>> +     /* page may be available, but we have to restart the process
>> +      * because mmap_sem was dropped during the ->fault */
>
>        Ingo
>
