Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZAMRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZAMRGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZAMRGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:06:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAMRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:06:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=uuNRgefa6be947KvATe4nOHwf2CVhT6Ww0tB7xH00yMQuCbOvAcZ2p9qvph4e59LC
	2YejT9ewbLZRxR6p0FBWg==
Message-ID: <496CC9D8.6040909@google.com>
Date: Tue, 13 Jan 2009 09:05:28 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, yinghan@google.com,
       hugh@veritas.com
Subject: Re: mmotm 2009-01-12-16-53 uploaded
References: <200901130053.n0D0rhev023334@imap1.linux-foundation.org> <20090113181317.48e910af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090113181317.48e910af.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.69
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 12 Jan 2009 16:53:43 -0800
> akpm@linux-foundation.org wrote:
> 
>> The mm-of-the-moment snapshot 2009-01-12-16-53 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://git.zen-sources.org/zen/mmotm.git
>>
> 
> After rtc compile fix, the kernel boots.
> 
> But with CONFIG_DEBUG_VM, I saw BUG_ON() at 
> 
> fork() -> ...
> 	-> copy_page_range() ...
> 		-> copy_one_pte()
> 			->page_dup_rmap()
> 				-> __page_check_anon_rmap().
> 
> BUG_ON(page->index != linear_page_index(vma, address)); 
> fires. (from above, the page is ANON.)
> 
> It seems page->index == 0x7FFFFFFE here and the page seems to be
> the highest address of stack.
> 
> This is caused by
>  fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes.patch 
> 
> 
> This is a fix.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> pgoff is *not* vma->vm_start >> PAGE_SHIFT.
> And no adjustment is necessary (when it maps the same start
> before/after adjust vma.)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: mmotm-2.6.29-Jan12/fs/exec.c
> ===================================================================
> --- mmotm-2.6.29-Jan12.orig/fs/exec.c
> +++ mmotm-2.6.29-Jan12/fs/exec.c
> @@ -509,7 +509,7 @@ static int shift_arg_pages(struct vm_are
>  	unsigned long length = old_end - old_start;
>  	unsigned long new_start = old_start - shift;
>  	unsigned long new_end = old_end - shift;
> -	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
> +	unsigned long new_pgoff = vma->vm_pgoff;
>  	struct mmu_gather *tlb;
>  
>  	BUG_ON(new_start > new_end);
> 

This patch is just reverting the behaviour back to having a 64bit pgoff. 
  Best just reverting the patch for the time being.

