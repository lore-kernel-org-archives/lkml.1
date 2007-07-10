Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbXGJH1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbXGJH1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXGJH0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:26:54 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36302 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbXGJH0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:26:53 -0400
To: balbir@linux.vnet.ibm.com
Cc: svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com
Subject: Re: [-mm PATCH 4/8] Memory controller memory accounting (v2)
In-Reply-To: Your message of "Thu, 05 Jul 2007 22:21:35 -0700"
	<20070706052135.11677.28030.sendpatchset@balbir-laptop>
References: <20070706052135.11677.28030.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070710072651.C061D1BF77E@siro.lan>
Date: Tue, 10 Jul 2007 16:26:51 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> diff -puN mm/memory.c~mem-control-accounting mm/memory.c
> --- linux-2.6.22-rc6/mm/memory.c~mem-control-accounting	2007-07-05 13:45:18.000000000 -0700
> +++ linux-2.6.22-rc6-balbir/mm/memory.c	2007-07-05 13:45:18.000000000 -0700

> @@ -1731,6 +1736,9 @@ gotten:
>  		cow_user_page(new_page, old_page, address, vma);
>  	}
>  
> +	if (mem_container_charge(new_page, mm))
> +		goto oom;
> +
>  	/*
>  	 * Re-check the pte - we dropped the lock
>  	 */

it seems that the page will be leaked on error.

> @@ -2188,6 +2196,11 @@ static int do_swap_page(struct mm_struct
>  	}
>  
>  	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> +	if (mem_container_charge(page, mm)) {
> +		ret = VM_FAULT_OOM;
> +		goto out;
> +	}
> +
>  	mark_page_accessed(page);
>  	lock_page(page);
>  

ditto.

> @@ -2264,6 +2278,9 @@ static int do_anonymous_page(struct mm_s
>  		if (!page)
>  			goto oom;
>  
> +		if (mem_container_charge(page, mm))
> +			goto oom;
> +
>  		entry = mk_pte(page, vma->vm_page_prot);
>  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  

ditto.

can you check the rest of the patch by yourself?  thanks.

YAMAMOTO Takashi
