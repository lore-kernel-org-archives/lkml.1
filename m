Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbYHLEMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbYHLEMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 00:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYHLEMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 00:12:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:2863 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYHLEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 00:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lef346wKRbrYTX2aCiDg7jc43COOiQnRG9b0A+NqmduPKsGaxUPVi+JABfLVWiBwyP
         vJkR0CmVeE0vI8rXMbSxIqoXKIcmk4OcUImlOu5lGEgTwWOCVzuQdBhTspmZWQsJY6lf
         ns7cpEOo3CJv0qnLVqqZzJAuB87AEWPhMEjU8=
Message-ID: <48f7fe350808112112k5e92330epa8345cbe4eb4c1b5@mail.gmail.com>
Date: Tue, 12 Aug 2008 00:12:21 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 3/3][reiser4] dont get radix-tree dirty tagging out of sync
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Edward Shishkin" <edward.shishkin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Reiserfs mailing list" <reiserfs-devel@vger.kernel.org>
In-Reply-To: <200808121236.51599.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A0BFC9.40502@gmail.com>
	 <200808121236.51599.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried just using __set_page_dirty_nobuffers but that caused issues
with ext3/ext4 (i can send a bug trace later if needed).

                                __inc_bdi_stat(mapping->backing_dev_info,
                                                BDI_RECLAIMABLE);
                                task_io_account_write(PAGE_CACHE_SIZE);

^^^ the above code in __set_page_dirty_nobuffers causes an issue with
do_writepages in ext3/4 when I use something like the code below:

int reiser4_set_page_dirty_internal(struct page *page)
{
     return __set_page_dirty_nobuffers(page);
}

On Mon, Aug 11, 2008 at 10:36 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Tuesday 12 August 2008 08:40, Ryan Hope wrote:
>> This was item #14 on the todo list for reiser4 inclusion in mainline:
>>
>> diff --git a/fs/reiser4/page_cache.c b/fs/reiser4/page_cache.c
>> index fe71368..a662c25 100644
>> --- a/fs/reiser4/page_cache.c
>> +++ b/fs/reiser4/page_cache.c
>> @@ -467,15 +467,14 @@ int reiser4_set_page_dirty_internal(struct page
>> *page) BUG_ON(mapping == NULL);
>>
>>       if (!TestSetPageDirty(page)) {
>> +             spin_lock_irq(&mapping->tree_lock);
>>               if (mapping_cap_account_dirty(mapping))
>>                       inc_zone_page_state(page, NR_FILE_DIRTY);
>> -
>> +             radix_tree_tag_set(&mapping->page_tree,
>> +                     page_index(page), PAGECACHE_TAG_DIRTY);
>>               __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>> +             spin_unlock_irq(&mapping->tree_lock);
>>       }
>> -
>> -     /* znode must be dirty ? */
>> -     if (mapping->host == reiser4_get_super_fake(mapping->host->i_sb))
>> -             assert("", JF_ISSET(jprivate(page), JNODE_DIRTY));
>>       return 0;
>>   }
>
> Any reason why this can't use a generic function such as
> __set_page_dirty_nobuffers? There are accounting changes gone in
> there now which I suspetc may be wrong now in reiser4 (eg. task
> io accounting).
>
> Actually every site that does a radix_tree_operation there should
> be reviewed to try to use core functoins.
>
