Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZHVHec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZHVHec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 03:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZHVHeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 03:34:31 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:52940 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZHVHea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 03:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uzznuY/yfRZAfqkyl3zuraHDPJ8VYjo39/cpsKIzeq1Ckms1b1M8fWGOidwt84Qqkw
         ggMddJhnXoLlTKGytsitzT/APySJ3Zh5nmVe4ocidY5d92Eb8CmcxUcv7a1DbQcJdFvP
         fepRHjluS39sF5LtDkHmALeFPfvCVs7BU2XO8=
MIME-Version: 1.0
In-Reply-To: <20090817115529.59395cea.kamezawa.hiroyu@jp.fujitsu.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <20090817115529.59395cea.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 22 Aug 2009 15:34:31 +0800
Message-ID: <ab418ea90908220034v72e80142x2bed8c0b9e7729ea@mail.gmail.com>
Subject: Re: [PATCH] swap: send callback when swap slot is freed
From: Nai Xia <nai.xia@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: ngupta@vflare.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 10:55 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 12 Aug 2009 20:07:43 +0530
> Nitin Gupta <ngupta@vflare.org> wrote:
>
>> Currently, we have "swap discard" mechanism which sends a discard bio request
>> when we find a free cluster during scan_swap_map(). This callback can come a
>> long time after swap slots are actually freed.
>>
>> This delay in callback is a great problem when (compressed) RAM [1] is used
>> as a swap device. So, this change adds a callback which is called as
>> soon as a swap slot becomes free. For above mentioned case of swapping
>> over compressed RAM device, this is very useful since we can immediately
>> free memory allocated for this swap page.
>>
>> This callback does not replace swap discard support. It is called with
>> swap_lock held, so it is meant to trigger action that finishes quickly.
>> However, swap discard is an I/O request and can be used for taking longer
>> actions.
>>
>> Links:
>> [1] http://code.google.com/p/compcache/
>>
>
> Hmm, do you really need notify at *every* swap free ?
> No batching is necessary ?

Compcache is a block device, it passively accepts swap pages, compresses
them and stores in compressed pages. There is little information for when the
reclaiming of unused slots should be batched.

For a normal swap device, it does not need to care much about unused slots
because the storage is always there, but for compcache, the storage is
allocated in RAM, it needs to be freed as soon as possible, otherwise
the compressing loses its meaning.

Assume the compressed ratio is 50% and there is 8 stale compressed
pages in compcache (16 user pages already be swapined), 8 more swap
pages may be pushed into it, which means 4 more compressed pages and
then 4 more swap pages  -> 2 compressed pages -> 2 more swap pages
->1 compressed page ->1 more swap page ->half compressed page->
1 more swap page->another half compressed page.
It's about 8+4+2+1+1 = 16 wasted pages, still not counting the overhead
for compressed pages management.

That means, if you batch N slots (even if you have the batch information),
your waste the same number of pages during the delayed time.
For time when swapping is already happening,  we really do not want to hold
any pages which are wasted for 100% sure.


Thanks,
Nai

>
> Thanks,
> -Kame
>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> ---
>>
>>  include/linux/swap.h |    5 +++++
>>  mm/swapfile.c        |   16 ++++++++++++++++
>>  2 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 7c15334..4cbe3c4 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -8,6 +8,7 @@
>>  #include <linux/memcontrol.h>
>>  #include <linux/sched.h>
>>  #include <linux/node.h>
>> +#include <linux/blkdev.h>
>>
>>  #include <asm/atomic.h>
>>  #include <asm/page.h>
>> @@ -20,6 +21,8 @@ struct bio;
>>  #define SWAP_FLAG_PRIO_MASK  0x7fff
>>  #define SWAP_FLAG_PRIO_SHIFT 0
>>
>> +typedef void (swap_free_notify_fn) (struct block_device *, unsigned long);
>> +
>>  static inline int current_is_kswapd(void)
>>  {
>>       return current->flags & PF_KSWAPD;
>> @@ -155,6 +158,7 @@ struct swap_info_struct {
>>       unsigned int max;
>>       unsigned int inuse_pages;
>>       unsigned int old_block_size;
>> +     swap_free_notify_fn *swap_free_notify_fn;
>>  };
>>
>>  struct swap_list_t {
>> @@ -295,6 +299,7 @@ extern sector_t swapdev_block(int, pgoff_t);
>>  extern struct swap_info_struct *get_swap_info_struct(unsigned);
>>  extern int reuse_swap_page(struct page *);
>>  extern int try_to_free_swap(struct page *);
>> +extern void set_swap_free_notify(unsigned, swap_free_notify_fn *);
>>  struct backing_dev_info;
>>
>>  /* linux/mm/thrash.c */
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 8ffdc0d..aa95fc7 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -552,6 +552,20 @@ out:
>>       return NULL;
>>  }
>>
>> +/*
>> + * Sets callback for event when swap_map[offset] == 0
>> + * i.e. page at this swap offset is no longer used.
>> + */
>> +void set_swap_free_notify(unsigned type, swap_free_notify_fn *notify_fn)
>> +{
>> +     struct swap_info_struct *sis;
>> +     sis = get_swap_info_struct(type);
>> +     BUG_ON(!sis);
>> +     sis->swap_free_notify_fn = notify_fn;
>> +     return;
>> +}
>> +EXPORT_SYMBOL(set_swap_free_notify);
>> +
>>  static int swap_entry_free(struct swap_info_struct *p,
>>                          swp_entry_t ent, int cache)
>>  {
>> @@ -583,6 +597,8 @@ static int swap_entry_free(struct swap_info_struct *p,
>>                       swap_list.next = p - swap_info;
>>               nr_swap_pages++;
>>               p->inuse_pages--;
>> +             if (p->swap_free_notify_fn)
>> +                     p->swap_free_notify_fn(p->bdev, offset);
>>       }
>>       if (!swap_count(count))
>>               mem_cgroup_uncharge_swap(ent);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
