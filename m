Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZHULRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZHULRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZHULRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:17:50 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:57565 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZHULRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e1zshZa7T9aX+Bdfhsj6x4cXJy0b5wzj91EDS9KPE37Z9rF/GF7AbOjqgfnRW0kbkI
         kOOh7rG6kbOpcm08uXBETk025xBui4OkYbgZd8JyG3X2xdGvi+6KLx3y/LXtkzNm1Stx
         lfLvA8C4fbLbHhE68wBLHAiYgJX8Gh/Ly2EKM=
MIME-Version: 1.0
In-Reply-To: <28c262360908190628i3f323714kf011f9b0fd4cd15@mail.gmail.com>
References: <20090816051502.GB13740@localhost>
	 <20090816112910.GA3208@localhost>
	 <20090818234310.A64B.A69D9226@jp.fujitsu.com>
	 <20090819120117.GB7306@localhost>
	 <2f11576a0908190505h6da96280xf67c962aa3f5ba07@mail.gmail.com>
	 <20090819121017.GA8226@localhost>
	 <28c262360908190525i6e56ead0mb8dcb01c3d1a69f1@mail.gmail.com>
	 <2f11576a0908190619t9951959o3841091e51324c8@mail.gmail.com>
	 <28c262360908190628i3f323714kf011f9b0fd4cd15@mail.gmail.com>
Date: Fri, 21 Aug 2009 20:17:51 +0900
X-Google-Sender-Auth: 7f63847d34ebab1a
Message-ID: <2f11576a0908210417y340f7017r20d87d81c6243184@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Jeff Dike <jdike@addtoit.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hmm, I think
>>
>> 1. Anyway, we need turn on PG_mlock.
>
> I add my patch again to explain.
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index ed63894..283266c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -358,6 +358,7 @@ static int page_referenced_one(struct page *page,
>         */
>        if (vma->vm_flags & VM_LOCKED) {
>                *mapcount = 1;  /* break early from loop */
> +               *vm_flags |= VM_LOCKED;
>                goto out_unmap;
>        }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d224b28..d156e1d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -632,7 +632,8 @@ static unsigned long shrink_page_list(struct
> list_head *page_list,
>                                                sc->mem_cgroup, &vm_flags);
>                /* In active use or really unfreeable?  Activate it. */
>                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
> -                                       referenced && page_mapping_inuse(page))
> +                                       referenced && page_mapping_inuse(page)
> +                                       && !(vm_flags & VM_LOCKED))
>                        goto activate_locked;
>
> By this check, the page can be reached at try_to_unmap after
> page_referenced in shrink_page_list. At that time PG_mlocked will be
> set.

You are right.
Please add my Reviewed-by sign to your patch.

Thanks.
