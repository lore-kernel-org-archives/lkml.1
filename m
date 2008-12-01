Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYLAXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYLAXAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:00:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLAXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:00:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=px6lcWorJkch600p0JPw4c3Mf/c5UDbktTsndCf7EOIGZwbSu7nF4Bf/cAELSPAa7
	VW0bTg8+ug/DZhn3829Jg==
MIME-Version: 1.0
In-Reply-To: <20081127200459.GA25799@redhat.com>
References: <20081127200459.GA25799@redhat.com>
Date: Mon, 1 Dec 2008 15:00:14 -0800
Message-ID: <604427e00812011500j48ae17d8w4f6f47eba7493af8@mail.gmail.com>
Subject: Re: + make-get_user_pages-interruptible.patch added to -mm tree
From: Ying Han <yinghan@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <menage@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <matthew@wil.cx>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Oleg, i looked at the code again and this is a reasonable
change. I will make the change on the patch.
Andrew,
    should i make a patch based on current change or make the same
patch as [V6]?

thanks
--Ying

On Thu, Nov 27, 2008 at 12:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Ying Han wrote:
>>
>> -static int sigkill_pending(struct task_struct *tsk)
>> +int sigkill_pending(struct task_struct *tsk)
>>  {
>>       return  sigismember(&tsk->pending.signal, SIGKILL) ||
>>               sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
>> diff -puN mm/memory.c~make-get_user_pages-interruptible mm/memory.c
>> --- a/mm/memory.c~make-get_user_pages-interruptible
>> +++ a/mm/memory.c
>> @@ -1219,12 +1219,12 @@ int __get_user_pages(struct task_struct
>>                       struct page *page;
>>
>>                       /*
>> -                      * If tsk is ooming, cut off its access to large memory
>> -                      * allocations. It has a pending SIGKILL, but it can't
>> -                      * be processed until returning to user space.
>> +                      * If we have a pending SIGKILL, don't keep
>> +                      * allocating memory.
>>                        */
>> -                     if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
>> -                             return i ? i : -ENOMEM;
>> +                     if (unlikely(sigkill_pending(current) ||
>> +                                     sigkill_pending(tsk)))
>
> Please do not export/use sigkill_pending(). It is "private" for ptrace_stop()
> (and actually should die imho).
>
> We have fatal_signal_pending() for that.
>
> Oleg.
>
>
