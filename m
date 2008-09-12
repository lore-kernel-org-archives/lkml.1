Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYILULQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYILULQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYILULC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:11:02 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:50016 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbYILULA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wCW63T2H2NYdctBskSsBfUwfhVwCYbIyxR5jqXPPcbqi25MoztfkNgZKJVUnHAI6Cv
         TGyhdeIn91BQ0k5CIW2wYiUfVsq4Qnty20uLaDOEb31L+GBLvUVI2rQ7/tn76v4fwGWu
         wlq1eUB3bD8glekJusFYZuJztrijpiN6K3TMg=
Message-ID: <48CACCCD.3020400@gmail.com>
Date: Fri, 12 Sep 2008 23:10:53 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org
Subject: Re: mmap/munmap latency on multithreaded apps, because pagefaults
 hold mmap_sem during disk read
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>	<48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>	<48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>	<48B287D8.1000000@gmail.com> <1219660582.8515.24.camel@twins>	<48B290E7.4070805@gmail.com> <1219664477.8515.54.camel@twins>	<20080825134801.GN1408@mit.edu> <87y72k9otw.fsf@basil.nowhere.org> <48C57898.1080304@gmail.com> <48CAC02B.8090003@gmail.com> <48CAC47F.8070206@google.com>
In-Reply-To: <48CAC47F.8070206@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-09-12 22:35, Mike Waychison wrote:
> Török Edwin wrote:
>> On 2008-09-08 22:10, Török Edwin wrote:
>>> [snip]
>>> There is however a problem with mmap [mmap with N threads is as slow as
>>> mmap with 1 thread, i.e. it is sequential :(], pagefaults and disk I/O,
>>> I think I am hitting the problem described in this thread (2 years
>>> ago!)
>>> http://lwn.net/Articles/200215/
>>> http://lkml.org/lkml/2006/9/19/260
>>>
>>> It looks like such a patch is still not part of 2.6.27, what
>>> happened to it?
>>> I will see if that patch applies to 2.6.27, and will rerun my test with
>>> that patch applied too.
>>>   
>>
>> The patch doesn't apply to 2.6.27-rc6, I tried manually applying the
>> patch.
>> There have been many changes since 2.6.18 (like replacing find_get_page
>> with find_lock_page, filemap returning VM_FAULT codes, etc.).
>> I have probably done something wrong, because the resulting kernel won't
>> boot: I  get abnormal exits and random sigbus during boot.
>>
>> Can you please help porting the patch to 2.6.27-rc6? I have attached my
>> 2 attempts at the end of this mail.
>
> I actually have to forward port this and a bunch of other mm speed-ups
> in the coming two weeks, though they'll be ports from 2.6.18 to
> 2.6.26.  I'll be sending them out to linux-mm once I've done so and
> completed some testing.
>


That would be great, thanks!

>>
>> Also it looks like the original patch just releases the mmap_sem if
>> there is lock contention on the page, but keeps mmap_sem during read?
>> I would like mmap_sem be released during disk I/O too.
>
> The 'lock'ing of the page is the part that waits for the read to
> finish, and is the part that is contentious.

Didn't know that, thanks for explaining.

>
>>
>> I also tried changing i_mmap_lock into a semaphore, however I that won't
>> work since some users of i_mmap_lock can't sleep.
>> Taking the i_mmap_lock spinlock in filemap fault is also not possible,
>> since we would sleep while holding a spinlock.
>
> You shouldn't be seeing much contention on the i_mmap_lock, at least
> not in the fault path (it's mostly just painful when you have a lot of
> threads in direct reclaim and you have a large file mmaped).

I was thinking of using i_mmap_lock as an alternative to holding
mmap_sem, but it didn't seem like a good idea after all.

Best regards,
--Edwin
