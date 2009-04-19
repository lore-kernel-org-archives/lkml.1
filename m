Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZDSJAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZDSJAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZDSI74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:59:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:16446 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZDSI7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:59:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Fub2verTXvd2cDBorr2O+CAL/uyL6CKIM9rI3zwu3yqe+ZsE7PXmcyhafrq7MWKzeN
         EbjmUjzn/Eoczv82ceYuIfHcSpSWWERr06UMWOAZFtERqQ8QOmjuGcpS533lF4p3EbJZ
         1nAjAlPCUNuza2PpJK2JCX+f7ejVdRRbi1q4Q=
MIME-Version: 1.0
In-Reply-To: <20090418184337.GA5556@cmpxchg.org>
References: <20090418152100.125A.A69D9226@jp.fujitsu.com>
	 <20090418184337.GA5556@cmpxchg.org>
Date: Sun, 19 Apr 2009 17:59:54 +0900
X-Google-Sender-Auth: 4e75ed79f0483de6
Message-ID: <2f11576a0904190159t2898edfal858ba12d3460c4e5@mail.gmail.com>
Subject: Re: [PATCH for mmotm 0414] vmscan,memcg: reintroduce sc->may_swap
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Hi

>> @@ -1724,6 +1728,7 @@ unsigned long try_to_free_mem_cgroup_pag
>>       struct scan_control sc = {
>>               .may_writepage = !laptop_mode,
>>               .may_unmap = 1,
>> +             .may_swap = 1,
>>               .swap_cluster_max = SWAP_CLUSTER_MAX,
>>               .swappiness = swappiness,
>>               .order = 0,
>> @@ -1734,7 +1739,7 @@ unsigned long try_to_free_mem_cgroup_pag
>>       struct zonelist *zonelist;
>>
>>       if (noswap)
>> -             sc.may_unmap = 0;
>> +             sc.may_swap = 0;
>
> Can this be directly initialized?
>
> struct scan_control sc = {
>        ...
>        .may_swap = !noswap,
>        ...
> };

your proposal is better coding style. but I also prefer condig style
consistency.
I think we should change may_unmap and may_swap at the same time.
Thus, I'd like to does it by another patch.



>> @@ -2120,6 +2126,7 @@ unsigned long shrink_all_memory(unsigned
>>       struct scan_control sc = {
>>               .gfp_mask = GFP_KERNEL,
>>               .may_unmap = 0,
>> +             .may_swap = 1,
>
> shrink_all_memory() is not a user of shrink_zone() -> get_scan_ratio()
> and therefor not affected by this flag.  I think it's better not to
> set it here (just like sc->swappiness).

Will fix. thanks.



>>               .may_writepage = 1,
>>               .isolate_pages = isolate_pages_global,
>>       };
>> @@ -2304,6 +2311,7 @@ static int __zone_reclaim(struct zone *z
>>       struct scan_control sc = {
>>               .may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
>>               .may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
>> +             .may_swap = 1,
>
> Shouldn't this be set to !!(zone_reclaim_mode & RECLAIM_SWAP) as well?
>
> With set to 1, zone_reclaim() will also reclaim unmapped swap cache
> pages (without swapping) and it might be desirable to do that.

In general, you are right.
but another patch is better. this patch should only change memcg behavior.

I plan to change this. I'm making some zone reclaim test case, after it,
I can post the patch.


> But
> then may_swap is a confusing name.  may_anon?  may_scan_anon?
> scan_anon?

Why?
may_swap = 0 mean no swap-out directly. not anon only.
it's because shmem page stay in LRU_ANON.
