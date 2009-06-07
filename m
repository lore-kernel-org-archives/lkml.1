Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZFGPQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZFGPQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZFGPQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:16:16 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50237 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZFGPQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A0xCw5NKjrc9vUpln4bDT1K+FzltuP8XMTApip6Sz2MZJsAlfs9bBPgZpkEp57CtJi
         4Xy+KDPqYwDjeLPoFOYGZZG4EOx33DU1DRXhxauSbd6TjwdQoofKsaAA/E3dxrVTPIZ5
         Mb7SjVOtdWSbyY5IdExW0HeNUfb5I/qLoWR+A=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906051906000.14826@sister.anvils>
References: <1244212553-21629-1-git-send-email-minchan.kim@gmail.com>
	 <Pine.LNX.4.64.0906051906000.14826@sister.anvils>
Date: Mon, 8 Jun 2009 00:16:17 +0900
Message-ID: <28c262360906070816h765bf4fag9b426199ac0627d@mail.gmail.com>
Subject: Re: [RFC] remove page_table_lock in anon_vma_prepare
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hugh.

On Sat, Jun 6, 2009 at 3:26 AM, Hugh Dickins<hugh.dickins@tiscali.co.uk> wrote:
> On Fri, 5 Jun 2009, Minchan Kim wrote:
>
>> As I looked over the page_table_lock, it related to page table not anon_vma
>>
>> I think anon_vma->lock can protect race against threads.
>> Do I miss something ?
>>
>> If I am right, we can remove unnecessary page_table_lock holding
>> in anon_vma_prepare. We can get performance benefit.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Nick Piggin <npiggin@suse.de>
>
> No, NAK to this one.  Look above the context shown in the patch:
>
>                anon_vma = find_mergeable_anon_vma(vma);
>                allocated = NULL;
>                if (!anon_vma) {
>                        anon_vma = anon_vma_alloc();
>                        if (unlikely(!anon_vma))
>                                return -ENOMEM;
>                        allocated = anon_vma;
>                }
>                spin_lock(&anon_vma->lock);
>
> So if find_mergeable_anon_vma failed to find a suitable neighbouring
> vma to share with, we'll have got the anon_vma from anon_vma_alloc().
>
> Two threads could perfectly well do that concurrently (mmap_sem is
> held only for reading), each allocating a separate fresh anon_vma,
> then they'd each do spin_lock(&anon_vma->lock), but on _different_
> anon_vmas, so wouldn't exclude each other at all: we need a common
> lock to exclude that race, and abuse page_table_lock for the purpose.

Indeed!
I have missed it until now.
In fact, I expected whoever expert like you point me out.


> (As I expect you've noticed, we used not to bother with the spin_lock
> on anon_vma->lock when we'd freshly allocated the anon_vma, it looks
> as if it's unnecessary.  But in fact Nick and Linus found there's a
> subtle reason why it is necessary even then - hopefully the git log
> explains it, or I could look up the mails if you want, but at this
> moment the details escape me.

Hmm. I didn't follow up that at that time.

After you noticed me, I found that.
commit d9d332e0874f46b91d8ac4604b68ee42b8a7a2c6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Oct 19 10:32:20 2008 -0700

    anon_vma_prepare: properly lock even newly allocated entries

It's subtle race so I can't digest it fully but I can understand that
following as.

If we don't hold lock at fresh anon_vma, it can be removed and
reallocated by other threads since other cpu's can find it, free,
reallocate before first thread which call anon_vma_prepare adds
anon_vma to list after vma->anon_vma = anon_vma

I hope my above explanation is right :)

> And do we need the page_table_lock even when find_mergeable_anon_vma
> succeeds?  That also looks as if it's unnecessary, but I've the ghost
> of a memory that it's needed even for that case: I seem to remember
> that there can be a benign race where find_mergeable_anon_vma called
> by concurrent threads could actually return different anon_vmas.
> That also is something I don't want to think too deeply into at
> this instant, but beg me if you wish!)

Unfortunately I can't found this issue mail or changelog.
Hugh. Could you explain this issue more detail in your convenient time ?
I don't mind you ignore me. I don't want you to be busy from me. :)

I always thanks for your kind explanation and learns lots of thing from you. :)
Thanks again.

-- 
Kinds regards,
Minchan Kim
