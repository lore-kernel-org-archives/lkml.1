Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0BHK1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0BHK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:27:33 -0500
Message-ID: <4B6FE70C.6020107@redhat.com>
Date: Mon, 08 Feb 2010 12:27:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
References: <20100203161103.11e2b572@annuminas.surriel.com>
In-Reply-To: <20100203161103.11e2b572@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 11:11 PM, Rik van Riel wrote:
> Currently KVM pretends that pages with EPT mappings never got
> accessed.  This has some side effects in the VM, like swapping
> out actively used guest pages and needlessly breaking up actively
> used hugepages.
>
> We can avoid those very costly side effects by emulating the
> accessed bit for EPT PTEs, which should only be slightly costly
> because pages pass through page_referenced infrequently.
>
> TLB flushing is taken care of by kvm_mmu_notifier_clear_flush_young().
>
> This seems to help prevent KVM guests from being swapped out when
> they should not on my system.
>
>    

Applied, thanks.

>
> -	/* always return old for EPT */
> +	/*
> +	 * Emulate the accessed bit for EPT, by checking if this page has
> +	 * an EPT mapping, and clearing it if it does. On the next access,
> +	 * a new EPT mapping will be established.
> +	 * This has some overhead, but not as much as the cost of swapping
> +	 * out actively used pages or breaking up actively used hugepages.
> +	 */
>   	if (!shadow_accessed_mask)
> -		return 0;
> +		return kvm_unmap_rmapp(kvm, rmapp, data);
>    

This could be optimized by using a software-available bit for 'present' 
and the rwx bits for young, that is:

   (present, rwx) -> the page is present and recently accessed, will not 
cause EPT violation
   (present, !rwx) -> page is present but old, will cause EPT violation 
but not rmap games and get_user_pages_fast().

However that's best done later if ever.

-- 
error compiling committee.c: too many arguments to function

