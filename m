Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZEDUsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZEDUsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZEDUsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:48:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44532 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZEDUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:48:07 -0400
Message-ID: <49FF5212.40208@redhat.com>
Date: Mon, 04 May 2009 23:37:38 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com> <1241302572-4366-2-git-send-email-ieidus@redhat.com> <1241302572-4366-3-git-send-email-ieidus@redhat.com> <1241302572-4366-4-git-send-email-ieidus@redhat.com> <Pine.LNX.4.64.0905042024180.15009@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0905042024180.15009@blonde.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sun, 3 May 2009, Izik Eidus wrote:
>
>   
>> This patch change the KSM_REMOVE_MEMORY_REGION ioctl to be specific per
>> memory region (instead of flushing all the registred memory regions inside
>> the file descriptor like it happen now)
>>
>> The previoes api was:
>> user register memory regions using KSM_REGISTER_MEMORY_REGION inside the fd,
>> and then when he wanted to remove just one memory region, he had to remove them
>> all using KSM_REMOVE_MEMORY_REGION.
>>
>> This patch change this beahivor by chaning the KSM_REMOVE_MEMORY_REGION
>> ioctl to recive another paramter that it is the begining of the virtual
>> address that is wanted to be removed.
>>
>> (user can still remove all the memory regions all at once, by just closing
>> the file descriptor)
>>
>> Signed-off-by: Izik Eidus <ieidus@redhat.com>
>>     
>
> I realize that it's ridiculous to break my silence

Hello ! :)

>  with a comment
> on this particular patch, when I've not yet commented on KSM as a
> whole.  (In the last few days I have at last managed to set aside
> some time to give KSM the attention it deserves, but I'm still
> not yet through and ready to comment.)
>
> However, although this patch is on the right lines (certainly you
> should be allowing to remove individual regions rather than just
> all at once), I believe the patch is seriously broken and corrupting
> as is, so thought I'd better speak up now.
>
> remove_mm_from_hash_and_tree(slot->mm) is still doing its own
> silly loop through the slots:
> 	list_for_each_entry(slot, &slots, link)
> 		if (slot->mm == mm)
> 			break;
> So it will be operating on whatever it finds first

I just started to write big answer that go over the code path to show 
why you are wrong, and then found the problem.

Thanks i will fix it and resend...


> , in general
> the wrong slot, and I expect havoc to follow once you kfree(slot).
>
> Easily fixed: replace remove_mm_from_hash_and_tree(mm)
> by remove_slot_from_hash_and_tree(slot).
>   

Yea, remove_mm_from_hash_and_tree(mm) is surely something that we dont 
need that was left from the old code base.

Thanks.
> Hugh
>
>   
>> ---
>>  mm/ksm.c |   31 +++++++++++++++++++++----------
>>  1 files changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 982dfff..c14019f 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -561,17 +561,20 @@ static void remove_mm_from_hash_and_tree(struct mm_struct *mm)
>>  	list_del(&slot->link);
>>  }
>>  
>> -static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma)
>> +static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma,
>> +					      unsigned long addr)
>>  {
>>  	struct ksm_mem_slot *slot, *node;
>>  
>>  	down_write(&slots_lock);
>>  	list_for_each_entry_safe(slot, node, &ksm_sma->sma_slots, sma_link) {
>> -		remove_mm_from_hash_and_tree(slot->mm);
>> -		mmput(slot->mm);
>> -		list_del(&slot->sma_link);
>> -		kfree(slot);
>> -		ksm_sma->nregions--;
>> +		if (addr == slot->addr) {
>> +			remove_mm_from_hash_and_tree(slot->mm);
>> +			mmput(slot->mm);
>> +			list_del(&slot->sma_link);
>> +			kfree(slot);
>> +			ksm_sma->nregions--;
>> +		}
>>  	}
>>  	up_write(&slots_lock);
>>  	return 0;
>> @@ -579,12 +582,20 @@ static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma)
>>  
>>  static int ksm_sma_release(struct inode *inode, struct file *filp)
>>  {
>> +	struct ksm_mem_slot *slot, *node;
>>  	struct ksm_sma *ksm_sma = filp->private_data;
>> -	int r;
>>  
>> -	r = ksm_sma_ioctl_remove_memory_region(ksm_sma);
>> +	down_write(&slots_lock);
>> +	list_for_each_entry_safe(slot, node, &ksm_sma->sma_slots, sma_link) {
>> +		remove_mm_from_hash_and_tree(slot->mm);
>> +		mmput(slot->mm);
>> +		list_del(&slot->sma_link);
>> +		kfree(slot);
>> +	}
>> +	up_write(&slots_lock);
>> +
>>  	kfree(ksm_sma);
>> -	return r;
>> +	return 0;
>>  }
>>  
>>  static long ksm_sma_ioctl(struct file *filp,
>> @@ -607,7 +618,7 @@ static long ksm_sma_ioctl(struct file *filp,
>>  		break;
>>  	}
>>  	case KSM_REMOVE_MEMORY_REGION:
>> -		r = ksm_sma_ioctl_remove_memory_region(sma);
>> +		r = ksm_sma_ioctl_remove_memory_region(sma, arg);
>>  		break;
>>  	}
>>  
>> -- 
>> 1.5.6.5
>>     

