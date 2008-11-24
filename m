Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYKXPAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYKXPAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYKXPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:00:45 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:51889 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYKXPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KF6IRtkcrL4ow2m5mdKTX2PCBtjL7gMShXQKi8iRreVsp2A0tl+7WpS9Nmdzw3iaR0
         RZiXwHKyGbc/0Th3zHGs3zHDdVQ5vOaSFg3iqpqcf2dohRLEzKsnQj1P8pCwN3iXbILj
         T4lRXCf1K6/L89kNrlcD88j4gN0sV2UJjV6fw=
Message-ID: <19f34abd0811240700x1f9eb958re98103d81c617c33@mail.gmail.com>
Date: Mon, 24 Nov 2008 16:00:43 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -tip] kmemcheck: fix dynamic enable/disable
Cc: "Sitsofe Wheeler" <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1227530628.3718.122.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081124122013.GA24810@localhost.localdomain>
	 <1227530628.3718.122.camel@penberg-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 1:43 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Vegard,
>
> On Mon, 2008-11-24 at 13:20 +0100, Vegard Nossum wrote:
>> (Ingo: Will send pull request for this later :-))
>>
>>
>> From 6f505f59011e565c2dbb7a220702feb0447cc854 Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Mon, 24 Nov 2008 11:52:05 +0100
>> Subject: [PATCH] kmemcheck: fix dynamic enable/disable
>>
>> On Fri, Oct 10, 2008 at 1:40 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> > I received a lot of errors after manually enabling kmemcheck
>> > in /proc (it had been turned off due to oneshot mode). It
>> > might be a good idea to put a warning that errrors found after
>> > enabling it at any time other than boot might be spurious.
>>
>> Fixed. This was the problem: Instructions with multiple address
>> operands could look up the shadow of an address that had
>> previously been un-hidden. After handling the memory access, the
>> page would get hidden again. The fix is to verify that the page
>> is present before we return a shadow pointer.
>
> I don't quite understand the error condition nor the fix. It's probably
> because I fried my brain during the weekend but here goes...

Hm, typo in the log. The last line should say NON-present.

The error condition again:

1. kmemcheck is enabled
2. some pages get allocated and tracked, their corresponding struct
page contains a valid ->shadow pointer and their correponding PTE has
the flags: hidden, non-present
3. kmemcheck is disabled
4. a memcpy() from one tracked page to another will use a REP MOVS
instruction, but only generate a page fault for the source address
(since this is what the CPU touches first)
5. instruction decoder sees a MOVS instruction, so source/destination
addresses are in %esi/%edi
6. we look up shadow pages for both %esi and %edi (page is tracked if
and only if kmemcheck_lookup_shadow() returns a non-NULL pointer)

When kmemcheck is disabled, we cannot simply set the ->shadow pointer
to NULL, because we need to deallocate the page as well. And we might
be in _ANY_ imaginable context (this is what makes most of kmemcheck
business so tricky, btw; the fact that the page fault handler is
called on kernel memory), including inside the page allocator itself,
so deallocating here is simply not possible.

What we do to disable tracking for a page (even though it has a
->shadow pointer) is to set the present flag of the PTE. This means
that we will take no more page faults for it.

And here is the error condition: In the original code, since
lookup_shadow() returned non-NULL, these pages were saved to be marked
non-present after handling the memory access. This is wrong, because
they were present to begin with (thus not eligible for checking). So
when checking was dynamically re-enabled, a lot of accesses to these
pages would simply be lost, and the shadow state would be
inconsistent.

The fix is to return a NULL pointer in lookup_shadow() if the PTE was
already present (that means: it has a valid ->shadow pointer, but we
DON'T want to check memory accesses to this page). Now the page won't
get marked non-present when the memory access has been handled, and
kmemcheck will not be invoked on accesses to this page.

Does this help at all?

>> diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
>> index 196dddc..62a0f63 100644
>> --- a/arch/x86/mm/kmemcheck/shadow.c
>> +++ b/arch/x86/mm/kmemcheck/shadow.c
>> @@ -27,6 +27,8 @@ void *kmemcheck_shadow_lookup(unsigned long address)
>>       pte = kmemcheck_pte_lookup(address);
>>       if (!pte)
>>               return NULL;
>> +     if (pte_present(*pte))
>> +             return NULL;
>
> OK, so when kmemcheck is disabled in oneshot mode they're made present
> and we don't mark them as non-present when we enable kmemcheck again? Is
> there a reason we can't do that? You might want add a comment explaining
> what's going on here.

Yes. If we mark them non-present again, we'll have lost updates to the
page in the mean-time. Once kmemcheck is disabled, none of the pages
that are touched can still be tracked afterwards. (And their memory
will only be freed when the underlying slab is empty.)

>
>>       page = virt_to_page(address);
>>       if (!page->shadow)
>
>> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
>> index 056b4f1..12a4bbd 100644
>> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
>> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
>> @@ -707,6 +707,16 @@ bool kmemcheck_trap(struct pt_regs *regs)
>>       }
>>
>>       /*
>> +      * At this point, we know that the trap was kmemcheck's. However, if
>> +      * kmemcheck was disabled, we need to return immediately (and stop
>> +      * emulating the REP instruction).
>> +      */
>> +     if (!kmemcheck_enabled) {
>> +             kmemcheck_hide(regs);
>> +             return true;
>> +     }
>
> OK, I assume kmemcheck_hide() stops emulating the REP instruction? Why
> do we need to do it here and not at kmemcheck disable-time? Also, this
> change doesn't seem to be explained in the patch description?

Yes. It will restore EIP to point to the REP instruction and mark the
touched pages non-present (though if kmemcheck was disabled, we always
leave the pages present).

The answer here is slightly more complicated and difficult to explain.
We call kmemcheck_save_addr() to record a page that must be marked
non-present the next time kmemcheck_hide() is called. However, this is
the wrong thing to do since it means that the next shadow lookup will
fail (because the page is already present), and no pages will be
recorded. This in turn makes kmemcheck_show() fail to re-enable the
trap flag. So this hunk is a consequence of the other.

I'll be the first to admit that this can all be a little confusing.
Maybe we need a document that explains all the little quirks of what
and why we do something in a particular way.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
