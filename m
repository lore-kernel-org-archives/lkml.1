Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXJLHTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXJLHTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXJLHTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:19:30 -0400
Received: from elvis.mu.org ([192.203.228.196]:56117 "EHLO elvis.mu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbXJLHT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:19:29 -0400
X-Greylist: delayed 1728 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 03:19:29 EDT
In-Reply-To: <1185518010.15205.36.camel@lappy>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org> <20070726172330.d3409b57.akpm@linux-foundation.org> <1185518010.15205.36.camel@lappy>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <69AF9B2A-6AA7-4078-B0A2-BE3D4914AEDC@FreeBSD.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>
Content-Transfer-Encoding: 7bit
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
Subject: Re: [PATCH] Don't needlessly dirty mlocked pages when initially faulting them in.
Date: Thu, 11 Oct 2007 23:50:39 -0700
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26, 2007, at 11:33 PM, Peter Zijlstra wrote:

> On Thu, 2007-07-26 at 17:23 -0700, Andrew Morton wrote:
>> On Thu, 26 Jul 2007 16:52:44 -0700 Suleiman Souhlal  
>> <ssouhlal@FreeBSD.org> wrote:
>>
>>> make_pages_present() is dirtying mlocked pages if the VMA is  
>>> writable, even
>>> though it shouldn't, by telling get_user_pages() to simulate a  
>>> write fault.
>>>
>>> A simple way to test this is to mlock a multi-GB file, and then  
>>> sync.
>>> The sync will take a long time.
>>
>> ugh, how bad of us.
>>
>>> As far as I can see, it should be safe to just not simulate a  
>>> write fault.
>>
>> We pass in "write=1" to force a COW.  This is because we want to  
>> do all
>> that memory allocation at mlock()-time, not later on, when the app  
>> writes
>> to the page.
>
> <snip patch>
>
>> So something sterner will need to be done.  I guess the  
>> write_access arg to
>> handle_mm_fault() would need to become a three-value thing.
>
> That would be most painfull. Can't we simply set write=0 for shared
> mappings? Those won't have COW to break and are the onces that do
> requires writeback. Anonymous and private mappings do COW but will  
> never
> writeback and are thus save to touch with write=1.
>
> How about something like this:
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/memory.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c
> +++ linux-2.6/mm/memory.c
> @@ -2716,7 +2716,12 @@ int make_pages_present(unsigned long add
>  	vma = find_vma(current->mm, addr);
>  	if (!vma)
>  		return -1;
> -	write = (vma->vm_flags & VM_WRITE) != 0;
> +	/*
> +	 * We want to touch writable mappings with a write fault in otder
> +	 * to break COW, except for shared mappings because these don't COW
> +	 * and we would not want to dirty them for nothing.
> +	 */
> +	write = (vma->vm_flags & VM_WRITE|VM_SHARED) == VM_WRITE;
>  	BUG_ON(addr >= end);
>  	BUG_ON(end > vma->vm_end);
>  	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;

Oops, I completely forgot about this. Sorry about that.

It works for me (as long as you put parens around VM_WRITE|VM_SHARED).

Please consider committing it. :-)

Signed-off-by: Suleiman Souhlal <suleiman@google.com>

-- Suleiman
