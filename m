Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYJONT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYJONT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYJONTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:19:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:12020 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYJONTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XmyKrDbsf2UzqHeKXUCbU2KYTbZ240vh/KkCbPewySWd6JgwX9SFE9qOFyyBrPCA2Q
         RV74k3Qch8rNBJ7VyvwEp4DxAhhxGkTbXd5EVlMSffUuAVQAwnGUrdf41o3Cp++Ib1MI
         uCS4+AjzBrKXysM+y9Z+uvxlJe07/nmzm5SdI=
Message-ID: <48F5EDCF.5080107@gmail.com>
Date: Wed, 15 Oct 2008 15:19:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: GIT head no longer boots on x86-64
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org> <1223910693-28693-1-git-send-email-jirislaby@gmail.com> <20081013164717.7a21084a@lxorguk.ukuu.org.uk> <20081015115153.GA16413@elte.hu>
In-Reply-To: <20081015115153.GA16413@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2008 01:51 PM, Ingo Molnar wrote:
> Queued the fix below up in tip/x86/urgent for a merge to Linus later 
> today. Thanks!

Thanks. Omitted S-O-B below.

> From 5870942537422066655816e971629aa729c023d8 Mon Sep 17 00:00:00 2001
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Mon, 13 Oct 2008 17:11:33 +0200
> Subject: [PATCH] x86: fix CONFIG_DEBUG_VIRTUAL=y boot crash on x86-64
> 
> Alan reported a bootup crash in the module loader:
> 
>> BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e40b1
> 
> SMP kernel is running on UP, in such a case the module .text
> is patched to use UP locks before the module is added to the modules
> list and it thinks there are no valid data at that place while
> patching.
> 
> Also the !is_module_address(addr) test is useless now.
> 
> Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Tested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  include/linux/mm.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c61ba10..45772fd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -267,6 +267,10 @@ static inline int is_vmalloc_addr(const void *x)
>  #ifdef CONFIG_MMU
>  	unsigned long addr = (unsigned long)x;
>  
> +#ifdef CONFIG_X86_64
> +	if (addr >= MODULES_VADDR && addr < MODULES_END)
> +		return 1;
> +#endif
>  	return addr >= VMALLOC_START && addr < VMALLOC_END;
>  #else
>  	return 0;

