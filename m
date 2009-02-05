Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbZBECcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbZBECcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZBECci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:32:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:6939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZBECci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MqQ357s1icEDSdJWSJctRCiYhD1KCgGZjKhODLOWz+iKZ9D9Jjrcvg0X7EW/mlzECR
         gtZmy+fk2kjHVRYQktZRmOU0Hg3UbDWddp8/34ifcxNbcnmac4KNlZth7SRFVsrnKWL7
         nHhP1Wg4zmbZD8EoAO7AdpEAOW/9D8bKFqN2k=
MIME-Version: 1.0
In-Reply-To: <20090205111507.803B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090204171639.ECCE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090204233543.GA26159@barrios-desktop>
	 <20090205111507.803B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Thu, 5 Feb 2009 11:32:36 +0900
Message-ID: <44c63dc40902041832n47d6a313h6b388c5a08dc58bf@mail.gmail.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
From: MinChan Kim <barrioskmc@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: MinChan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 11:17 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > and, I think current try_to_mlock_page() is correct. no need change.
>> > Why?
>> >
>> > 1. Generally, mmap_sem holding is necessary when vma->vm_flags accessed.
>> >    that's vma's basic rule.
>> > 2. However, try_to_unmap_one() doesn't held mamp_sem. but that's ok.
>> >    it often get incorrect result. but caller consider incorrect value safe.
>> > 3. try_to_mlock_page() need mmap_sem because it obey rule (1).
>> > 4. in try_to_mlock_page(), if down_read_trylock() is failure,
>> >    we can't move the page to unevictable list. but that's ok.
>> >    the page in evictable list is periodically try to reclaim. and
>> >    be called try_to_unmap().
>> >    try_to_unmap() (and its caller) also move the unevictable page to unevictable list.
>> >    Therefore, in long term view, the page leak is not happend.
>>
>> Thanks for clarification.
>> In long term view, you're right.
>>
>> but My concern is that munlock[all] pathes always hold down of mmap_sem.
>> After all, down_read_trylock always wil fail for such cases.
>>
>> So, current task's mlocked pages only can be reclaimed
>> by background or direct reclaim path if the task don't exit.
>>
>> I think it can increase reclaim overhead unnecessary
>> if there are lots of such tasks.
>>
>> What's your opinion ?
>
> I have 2 comment.
>
> 1. typical application never munlock()ed at all.

Sometime application of embedded can do it.
That's becuase they want deterministic page allocation in some situation.
However, It's not a matter in here.

>   and exit() path is already efficient.
>   then, I don't like hacky apploach.
> 2. I think we should drop mmap_sem holding in munlock path in the future.
>   at that time, this issue disappear automatically.
>   it's clean way more.

If we can drop mmap_sem in munlock path, I am happy, too.
Please, CCed me if you make a patch for it.

By that time, I will fold this issue. :)

>
> What do you think it?
>
>
>



-- 
Thanks,
MinChan Kim
