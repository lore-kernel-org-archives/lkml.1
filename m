Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZJQWoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZJQWoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 18:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZJQWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 18:44:11 -0400
Received: from mk-filter-2-a-2.mail.uk.tiscali.com ([212.74.100.49]:6038 "EHLO
	mk-filter-2-a-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbZJQWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 18:44:10 -0400
X-Trace: 275273067/mk-filter-2.mail.uk.tiscali.com/WEBB2C/$webb2c-ALLOWED_RELAY/webb2c-ALLOWED-B2C-WEBMAIL/212.74.100.143/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 212.74.100.143
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-IP-Webmail: TRUE
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8FAI7l2UrUSmSP/2dsb2JhbACBUYVezxuEMQQ
X-IronPort-AV: E=Sophos;i="4.44,578,1249254000"; 
   d="scan'208";a="275273067"
Message-ID: <27119164.1255819452382.JavaMail.root@ps28>
Date: Sat, 17 Oct 2009 23:44:12 +0100 (GMT+01:00)
From: "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Reply-To: "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
To: <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] mm: call pte_unmap() against a proper pte (Re: [PATCH
 7/9] swap_info: swap count continuations)
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       <hongshin@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: 202.231.68.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>----Original Message----
>From: nishimura@mxp.nes.nec.co.jp
>Date: 16/10/2009 7:30 
>To: "Hugh Dickins"<hugh.dickins@tiscali.co.uk>
>Cc: "Andrew Morton"<akpm@linux-foundation.org>, "Nitin Gupta"<ngupta@vflare.
org>, "KAMEZAWA Hiroyuki"<kamezawa.hiroyu@jp.fujitsu.com>, <hongshin@gmail.
com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, "Daisuke Nishimura"
<nishimura@mxp.nes.nec.co.jp>
>Subj: [PATCH] mm: call pte_unmap() against a proper pte (Re: [PATCH 7/9] 
swap_info: swap count continuations)
>
>Hi.
>
>> @@ -645,6 +648,7 @@ static int copy_pte_range(struct mm_stru
>>  	spinlock_t *src_ptl, *dst_ptl;
>>  	int progress = 0;
>>  	int rss[2];
>> +	swp_entry_t entry = (swp_entry_t){0};
>>  
>>  again:
>>  	rss[1] = rss[0] = 0;
>> @@ -671,7 +675,10 @@ again:
>>  			progress++;
>>  			continue;
>>  		}
>> -		copy_one_pte(dst_mm, src_mm, dst_pte, src_pte, vma, addr, rss);
>> +		entry.val = copy_one_pte(dst_mm, src_mm, dst_pte, src_pte,
>> +							vma, addr, rss);
>> +		if (entry.val)
>> +			break;
>>  		progress += 8;
>>  	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
>>  
>It isn't the fault of only this patch, but I think breaking the loop without 
incrementing
>dst_pte(and src_pte) would be bad behavior because we do unmap_pte(dst_pte - 
1) later.
>(current copy_pte_range() already does it though... and this is only 
problematic
>when we break the first loop, IIUC.)

Good catch, thanks a lot for finding that.  I believe this is entirely a fault 
in my 7/9, the existing code
takes care not to break before it has made some progress (in part because of 
this unmap issue).

>
>> @@ -681,6 +688,12 @@ again:
>>  	add_mm_rss(dst_mm, rss[0], rss[1]);
>>  	pte_unmap_unlock(dst_pte - 1, dst_ptl);
>>  	cond_resched();
>> +
>> +	if (entry.val) {
>> +		if (add_swap_count_continuation(entry, GFP_KERNEL) < 0)
>> +			return -ENOMEM;
>> +		progress = 0;
>> +	}
>>  	if (addr != end)
>>  		goto again;
>>  	return 0;
>
>I've searched other places where we break a similar loop and do pte_unmap(pte 
- 1).
>Current copy_pte_range() and apply_to_pte_range() has the same problem.

And thank you for taking the trouble to look further afield: yes, 
apply_to_pte_range()
was already wrong.

>
>How about a patch like this ?
>===
>From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>
>There are some places where we do like:
>
>	pte = pte_map();
>	do {
>		(do break in some conditions)
>	} while (pte++, ...);
>	pte_unmap(pte - 1);
>
>But if the loop breaks at the first loop, pte_unmap() unmaps invalid pte.
>
>This patch is a fix for this problem.
>
>Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>





Forget the rest, get the best - http://www.tiscali.co.uk/music

