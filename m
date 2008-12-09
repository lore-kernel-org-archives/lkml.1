Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYLIR6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYLIR6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYLIR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:57:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:36120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYLIR5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:57:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=MWE5eAOuGv6F1d66PgsutpLqHM5TeD1O8tAb2IAX0MZjhD5pq6VyggnXdNbC8UAhq
	OneVyXZhRJt2X/nV5Wu0g==
MIME-Version: 1.0
In-Reply-To: <604427e00812071743u79e6d1d3y7ba510a7ff3052ec@mail.gmail.com>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
	 <493A4B48.1050706@gmail.com> <493A4C1C.3020102@gmail.com>
	 <604427e00812071743u79e6d1d3y7ba510a7ff3052ec@mail.gmail.com>
Date: Tue, 9 Dec 2008 09:57:50 -0800
Message-ID: <604427e00812090957v7bb776acu7ec00315019ddfb4@mail.gmail.com>
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Waychison <mikew@google.com>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, if it sounds good to include this patch in -mm at this point?

thanks

--Ying

On Sun, Dec 7, 2008 at 5:43 PM, Ying Han <yinghan@google.com> wrote:
> Thanks Török for your experiment and that sounds great !
>
> --Ying
>
> On Sat, Dec 6, 2008 at 1:55 AM, Török Edwin <edwintorok@gmail.com> wrote:
>> On 2008-12-06 11:52, Török Edwin wrote:
>>> On 2008-12-05 21:40, Ying Han wrote:
>>>
>>>> changelog[v2]:
>>>> - reduce the runtime overhead by extending the 'write' flag of
>>>>   handle_mm_fault() to indicate the retry hint.
>>>> - add another two branches in filemap_fault with retry logic.
>>>> - replace find_lock_page with find_lock_page_retry to make the code
>>>>   cleaner.
>>>>
>>>> todo:
>>>> - there is potential a starvation hole with the retry. By the time the
>>>>   retry returns, the pages might be released. we can make change by holding
>>>>   page reference as well as remembering what the page "was"(in case the
>>>>   file was truncated). any suggestion here are welcomed.
>>>>
>>>> I also made patches for all other arch. I am posting x86_64 here first and
>>>> i will post others by the time everyone feels comfortable of this patch.
>>>>
>>>> Edwin, please test this patch with your testcase and check if you get any
>>>> performance improvement of mmap over read. I added another two more places
>>>> in filemap_fault with retry logic which you might hit in your privous
>>>> experiment.
>>>>
>>>>
>>>
>>> I get much better results with this patch than with v1, thanks!
>>>
>>> mmap now scales almost as well as read does (there is a small ~5%
>>> overhead), which is a significant improvement over not scaling at all!
>>>
>>> Here are the results when running my testcase:
>>>
>>> Number of threads ->, 1,,, 2,,, 4,,, 8,,, 16
>>> Kernel version, read, mmap, mixed, read, mmap, mixed, read, mmap, mixed,
>>> read, mmap, mixed, read, mmap, mixed
>>> 2.6.28-rc7-tip, 27.55, 26.18, 27.06, 16.18, 16.97, 16.10, 11.06, 11.64,
>>> 11.41, 9.38, 9.97, 9.31, 9.37, 9.82, 9.3
>>>
>>>
>>> Here are the /proc/lock_stat output when running my testcase, contention
>>> is lower (34911+10462 vs 58590+7231), and waittime-total is better
>>> (57 601 464 vs 234 170 024)
>>>
>>> lock_stat version 0.3
>>> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>>                               class name    con-bounces    contentions
>>> waittime-min   waittime-max waittime-total    acq-bounces
>>> acquisitions   holdtime-min   holdtime-max holdtime-total
>>> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>>                         &mm->mmap_sem-W:          5843
>>> 10462           2.89      138824.72    14217159.52
>>> 18965          84205           1.81        5031.07      725293.65
>>>                          &mm->mmap_sem-R:         20208
>>> 34911           4.87      136797.26    57601464.49          55797
>>> 1110394           1.89      164918.52    30551371.71
>>>                          ---------------
>>>                            &mm->mmap_sem           5341
>>> [<ffffffff802bf9d7>] sys_munmap+0x47/0x80
>>>                            &mm->mmap_sem          28579
>>> [<ffffffff805d1c62>] do_page_fault+0x172/0xab0
>>>                            &mm->mmap_sem           5030
>>> [<ffffffff80211161>] sys_mmap+0xf1/0x140
>>>                            &mm->mmap_sem           6331
>>> [<ffffffff802a675e>] find_lock_page_retry+0xde/0xf0
>>>                          ---------------
>>>                            &mm->mmap_sem          13558
>>> [<ffffffff802a675e>] find_lock_page_retry+0xde/0xf0
>>>                            &mm->mmap_sem           4694
>>> [<ffffffff802bf9d7>] sys_munmap+0x47/0x80
>>>                            &mm->mmap_sem           3681
>>> [<ffffffff80211161>] sys_mmap+0xf1/0x140
>>>                            &mm->mmap_sem          23374
>>> [<ffffffff805d1c62>] do_page_fault+0x172/0xab0
>>>
>>>
>>> On clamd:
>>>
>>> Here holdtime-total is better (1 493 154 + 2 395 987 vs 2 087 538 + 2
>>> 514 673), and number of contentions on read
>>> (458 052 vs 5851
>>
>> typo, should have been: 458 052 vs 585 119
>>
>>
>
