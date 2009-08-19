Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZHSMFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZHSMFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZHSMFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:05:21 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:39029 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZHSMFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fPx7R5E9nSiYEy/EtzXIAVG/TFLXcydH7xQ73cw49AnXFUWciNCGRg8NUsNp6nVBZe
         URLex0A4x2ugDk4/IaZXPHWaxiIzQIjsZN1XLH2qQxlRRoQngDBrC3sEA+KL1yfifkOs
         j0d1QIn5w5A8xGPGg/vYYx/hRv0GYfjadQP2E=
MIME-Version: 1.0
In-Reply-To: <20090819120117.GB7306@localhost>
References: <20090816051502.GB13740@localhost>
	 <20090816112910.GA3208@localhost>
	 <20090818234310.A64B.A69D9226@jp.fujitsu.com>
	 <20090819120117.GB7306@localhost>
Date: Wed, 19 Aug 2009 21:05:19 +0900
X-Google-Sender-Auth: ec82b635e5ed236f
Message-ID: <2f11576a0908190505h6da96280xf67c962aa3f5ba07@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
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

>> page_referenced_file?
>> I think we should change page_referenced().
>
> Yeah, good catch.
>
>>
>> Instead, How about this?
>> ==============================================
>>
>> Subject: [PATCH] mm: stop circulating of referenced mlocked pages
>>
>> Currently, mlock() systemcall doesn't gurantee to mark the page PG_Mlocked
>
>                                                    mark PG_mlocked
>
>> because some race prevent page grabbing.
>> In that case, instead vmscan move the page to unevictable lru.
>>
>> However, Recently Wu Fengguang pointed out current vmscan logic isn't so
>> efficient.
>> mlocked page can move circulatly active and inactive list because
>> vmscan check the page is referenced _before_ cull mlocked page.
>>
>> Plus, vmscan should mark PG_Mlocked when cull mlocked page.
>
>                           PG_mlocked
>
>> Otherwise vm stastics show strange number.
>>
>> This patch does that.
>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks.



>> Index: b/mm/rmap.c
>> ===================================================================
>> --- a/mm/rmap.c       2009-08-18 19:48:14.000000000 +0900
>> +++ b/mm/rmap.c       2009-08-18 23:47:34.000000000 +0900
>> @@ -362,7 +362,9 @@ static int page_referenced_one(struct pa
>>        * unevictable list.
>>        */
>>       if (vma->vm_flags & VM_LOCKED) {
>> -             *mapcount = 1;  /* break early from loop */
>> +             *mapcount = 1;          /* break early from loop */
>> +             *vm_flags |= VM_LOCKED; /* for prevent to move active list */
>
>> +             try_set_page_mlocked(vma, page);
>
> That call is not absolutely necessary?

Why? I haven't catch your point.
