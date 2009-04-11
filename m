Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZDKN6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZDKN6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 09:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZDKN6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 09:58:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:42684 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZDKN6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 09:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BRfh+K9556GqJeDJMSMWgmt4yzB6SpGWMMRXZqrt27cILwqorlGz/Ghz/EQebNdCqr
         /V4+N+9JeX47NBF8i8UWGwduruQ4Mm0lSvQwGbvgZSdQeQICTwsCsjQ+bEkGL0SaRttA
         fKmReDWjjiakXsHLmh0L44S7aIYcaAvS7fUe4=
MIME-Version: 1.0
In-Reply-To: <20090410164803.0c6cc25d.akpm@linux-foundation.org>
References: <20090410060957.442203404@intel.com>
	 <20090410061254.530720232@intel.com>
	 <20090410164803.0c6cc25d.akpm@linux-foundation.org>
Date: Sat, 11 Apr 2009 22:58:31 +0900
X-Google-Sender-Auth: 1ff8fe9631b9c863
Message-ID: <2f11576a0904110658i4c595f49odbaefda8f8fa95d@mail.gmail.com>
Subject: Re: [PATCH 6/9] readahead: clean up and simplify the code for filemap 
	page fault readahead
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       lpk@581.spb.su, wli@movementarian.org, torvalds@linux-foundation.org,
       yinghan@google.com, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/11 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 10 Apr 2009 14:10:03 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
>
>> @@ -1553,18 +1581,18 @@ retry_find:
>>       if (unlikely(!PageUptodate(page)))
>>               goto page_not_uptodate;
>>
>> -     /* Must recheck i_size under page lock */
>> +     /*
>> +      * Found the page and have a reference on it.
>> +      * We must recheck i_size under page lock.
>> +      */
>>       size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>> -     if (unlikely(vmf->pgoff >= size)) {
>> +     if (unlikely(offset >= size)) {
>>               unlock_page(page);
>>               page_cache_release(page);
>>               return VM_FAULT_SIGBUS;
>>       }
>
> This hunk broke
> mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch.
>
>
> I fixed it thusly:
>
>        /*
>         * Found the page and have a reference on it.
>         * We must recheck i_size under page lock.
>         */
>        size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>        if (unlikely(offset >= size)) {
>                unlock_page(page);
>                page_cache_release(page);
>                return VM_FAULT_SIGBUS;
>        }
> +       update_page_reclaim_stat(page);
>        ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
>        vmf->page = page;
>        return ret | VM_FAULT_LOCKED;
>
> which seems logical to me.
>
> Although now I look at it, it seems that
> mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch should
> go into 2.6.30?

I haven't see this patch detail and I don't think
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
should go into 2.6.30, but I have one question.


> Ah.  But I have a note here that I didn't like it, because it adds lots
> of new spinlocking to fastpaths.  So I'll leave things as they stand
> until we have had a little talk about that.

add?

old code: grab zone->lru_lock via mark_page_accessed()
new code: grab zone->lru_lock via update_reclaim_stat()

one remove, one add.

But I agree its lock can be removed maybe..
I'm sorry my late work.
