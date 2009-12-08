Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZLHNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZLHNiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZLHNiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:38:16 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:42815 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZLHNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:38:16 -0500
X-IronPort-AV: E=Sophos;i="4.47,362,1257138000"; 
   d="scan'208";a="8524379"
Message-ID: <4B1E568A.4020005@analog.com>
Date: Tue, 8 Dec 2009 21:37:14 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> <7253.1260269873@redhat.com>
In-Reply-To: <7253.1260269873@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2009 13:37:59.0936 (UTC) FILETIME=[A86FE800:01CA780B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 06:57 PM, David Howells wrote:
> Mike Frysinger<vapier@gentoo.org>  wrote:
>
>> +			copy_to_user_page(vma, NULL, NULL,
>> +					  (void *) addr, buf, len);
>> ...
>> +			copy_from_user_page(vma, NULL, NULL,
>> +					    buf, (void *) addr, len);
>
> I think this is not correct.  The third parameter in both cases (vaddr) is of
> unsigned long type (so should be 0 not NULL), and should not be left zero in
> any case.  I think it should be passed addr.  In fact, we should really pass
> the second parameter too (page), though for now, I'm happy to leave that NULL.
>
> See attached revision of the patch.
>
I agree on using 0 instead of NULL. But for !MMU, I think, vaddr is 
always as same as addr. So we don't need to pass it?


Jie


> David
> ---
> From: Jie Zhang<jie.zhang@analog.com>
> Subject: [PATCH] NOMMU: Use copy_*_user_page() in access_process_vm()
>
> The MMU code uses the copy_*_user_page() variants in access_process_vm()
> rather than copy_*_user() as the former includes an icache flush.  This is
> important when doing things like setting software breakpoints with gdb.
> So switch the NOMMU code over to do the same.
>
> This patch makes the reasonable assumption that copy_from_user_page() won't
> fail - which is probably fine, as we've checked the VMA from which we're
> copying is usable, and the copy is not allowed to cross VMAs.  The one case
> where it might go wrong is if the VMA is a device rather than RAM, and that
> device returns an error which - in which case rubbish will be returned rather
> than EIO.
>
> Signed-off-by: Jie Zhang<jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger<vapier@gentoo.org>
> Signed-off-by: David Howells<dhowells@redhat.com>
> ---
>
>   mm/nommu.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index af12270..953800f 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1896,9 +1896,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>
>   		/* only read or write mappings where it is permitted */
>   		if (write&&  vma->vm_flags&  VM_MAYWRITE)
> -			len -= copy_to_user((void *) addr, buf, len);
> +			copy_to_user_page(vma, NULL, addr,
> +					 (void *) addr, buf, len);
>   		else if (!write&&  vma->vm_flags&  VM_MAYREAD)
> -			len -= copy_from_user(buf, (void *) addr, len);
> +			copy_from_user_page(vma, NULL, addr,
> +					    buf, (void *) addr, len);
>   		else
>   			len = 0;
>   	} else {

