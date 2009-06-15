Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZFONvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZFONvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZFONvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:51:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZFONvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:51:14 -0400
Message-ID: <4A3651D5.8020100@redhat.com>
Date: Mon, 15 Jun 2009 16:51:17 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ksm: write protect pages from inside ksm
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com> <Pine.LNX.4.64.0906142217270.6369@sister.anvils> <4A3576C3.2040500@redhat.com> <4A358DA7.2080305@redhat.com> <4A35903A.3090508@redhat.com> <20090615035749.6f8236cc@woof.tlv.redhat.com> <Pine.LNX.4.64.0906151300160.21984@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906151300160.21984@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I suspect too much of your testing has been on the sensible use of KSM,
> not enough on foolish abuse of it!
>   

Must of the testing was on the ioctl version of ksm, this RFC i thought 
would end up in "list of requested changes" that will force me to 
rewrite it.
(I did mention that i not sure if everything is safe, and it was mostly 
just to give the idea of possible desgien and its problems)

>   
> Right, for several reasons* not a patch we'd like to include in the
> end, but enough to show that indeed fixes the problems I was seeing:
> well caught.
>   

Yea, that why i said ugly :).

>
>   
> I'm already working with a separate list for KSM inside the mm struct
> (prefer not to be mixing these two things up), but I don't see how that
> helps.
>   

So you dont have mmlist at all?, Good i think i found another problems 
with the usage the RFC made with the mmlist,
Do you mind to send me the patch that move into diffrent mm list? or you 
still want to wait?

>   
>> Hugh, i hope at least now you will be able to run it without it will crush to
>> you.
>>     
>
> Yes, thanks, and helped me to think of a better fix (I hope!) below...
>
>   
>> Signed-off-by: Izik Eidus <ieidus@redhat.com>
>> ---
>>  kernel/fork.c |   11 ++++++-----
>>  1 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index e5ef58c..771b89a 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -484,17 +484,18 @@ void mmput(struct mm_struct *mm)
>>  {
>>  	might_sleep();
>>  
>> +	spin_lock(&mmlist_lock);
>>  	if (atomic_dec_and_test(&mm->mm_users)) {
>> +		if (!list_empty(&mm->mmlist))
>> +			list_del(&mm->mmlist);
>> +		spin_unlock(&mmlist_lock);
>>  		exit_aio(mm);
>>  		exit_mmap(mm);
>>  		set_mm_exe_file(mm, NULL);
>> -		if (!list_empty(&mm->mmlist)) {
>> -			spin_lock(&mmlist_lock);
>> -			list_del(&mm->mmlist);
>> -			spin_unlock(&mmlist_lock);
>> -		}
>>  		put_swap_token(mm);
>>  		mmdrop(mm);
>> +	} else {
>> +		spin_unlock(&mmlist_lock);
>>  	}
>>  }
>>  EXPORT_SYMBOL_GPL(mmput);
>>     
>
> I believe you can restore mmput() to how it was: patch below appears
> to fix it from the get_next_mmlist() end, using atomic_inc_not_zero() -
> swapoff's try_to_unuse() has to use that on mm_users too.  But please
> check and test it carefully, I'd usually want to test a lot more myself
> before sending out.
>
> And, hey, this very same patch appears to fix the other issue I mentioned,
> that I wasn't yet seeing any merging (within a single mm): I think your
> mm_users 1 test was badly placed before (whether or not we already have
> an mm_slot makes a big difference to the meaning of mm_users 1).
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>
> --- ksm_madvise/mm/ksm.c	2009-06-14 11:15:33.000000000 +0100
> +++ linux/mm/ksm.c	2009-06-15 12:49:12.000000000 +0100
> @@ -1137,7 +1137,6 @@ static void insert_to_mm_slots_hash(stru
>  	bucket = &mm_slots_hash[((unsigned long)mm / sizeof (struct mm_struct))
>  				% nmm_slots_hash];
>  	mm_slot->mm = mm;
> -	atomic_inc(&mm_slot->mm->mm_users);
>  	INIT_LIST_HEAD(&mm_slot->rmap_list);
>  	hlist_add_head(&mm_slot->link, bucket);
>  }
> @@ -1253,21 +1252,21 @@ static struct mm_slot *get_next_mmlist(s
>  		if (test_bit(MMF_VM_MERGEABLE, &mm->flags) ||
>  		    test_bit(MMF_VM_MERGEALL, &mm->flags)) {
>  			mm_slot = get_mm_slot(mm);
> -			if (unlikely(atomic_read(&mm->mm_users) == 1)) {
> -				if (mm_slot)
> +			if (mm_slot) {
> +				if (atomic_read(&mm->mm_users) == 1) {
>  					mm_slot->touched = 0;
> -			} else {
> -				if (!mm_slot) {
> -					insert_to_mm_slots_hash(mm,
> -							     pre_alloc_mm_slot);
> -					*used_pre_alloc = 1;
> -					mm_slot = pre_alloc_mm_slot;
> +					goto next;
>  				}
> -				mm_slot->touched = 1;
> -				return mm_slot;
> -			}
> +			} else if (atomic_inc_not_zero(&mm->mm_users)) {
> +				insert_to_mm_slots_hash(mm, pre_alloc_mm_slot);
> +				*used_pre_alloc = 1;
> +				mm_slot = pre_alloc_mm_slot;
> +			} else
> +				goto next;
> +			mm_slot->touched = 1;
> +			return mm_slot;
>  		}
> -
> +next:
>  		cur = cur->next;
>  	}
>  	return NULL;
>   
Yea, that trick with the inc_not_zero is much better, This patch does 
make sense as a bug fix..
I really would like to see it running with your new list for ksm inside 
the mmstruct, beacuse I think the mmlist usage have another problems.

So if you can send me a patch I will start stress test, on the other 
side I dont mind to wait.

Anyway, thanks.
