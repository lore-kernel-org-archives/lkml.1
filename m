Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXA3BOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXA3BOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXA3BOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:14:40 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:27747 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640AbXA3BOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:14:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FS6z1SWoPpd3saUWzZjZofSzMjBxJ9TdZlwJ6rRtxxJ88nEdeST8Zz3TcjM70zdpmjzWLfkSyZzWf/2z5WL1GKBQW9KcyXSsuxGqh1bniNsNgYvDOLr6DSZSOScgqjhSy3Pu0Mf2mBdjUVERfJaUVsX1OavdnWHo2Gej/MtGjZs=  ;
X-YMail-OSG: 2Y0MlTkVM1npaQTv8CA5iFctsWjQxt7M18iXl5z9U.3Saj7WhR6i1PNrYx1XY3XeORJwIXP5aCS.HJ4MOf66mIHFYDt1vaiDcIffLn3tXxXe2uds3WQ-
Message-ID: <45BE9BF0.10202@yahoo.com.au>
Date: Tue, 30 Jan 2007 12:14:24 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: page_mkwrite caller is racy?
References: <45BDCA8A.4050809@yahoo.com.au> <Pine.LNX.4.64.0701291521540.24726@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0701291521540.24726@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 29 Jan 2007, Nick Piggin wrote:

>>Moving page_cache_release(old_page) to below the next statement
>>will fix that problem.
> 
> 
> Yes.  I'm reluctant to steal your credit, but also reluctant to go
> back and forth too much over this: please insert your Signed-off-by
> _before_ mine in the patch below (substituting your own comment if
> you prefer) and send it Andrew.
> 
> Not a priority for 2.6.20 or -stable: aside from the unlikelihood,
> we don't seem to have any page_mkwrite users yet, as you point out.

Agreed. Thanks for doing the patch.

>>But it is sad that this thing got merged without any callers to even
>>know how it is intended to work.
> 
> 
> I'm rather to blame for that: I pushed Peter to rearranging his work
> on top of what David had, since they were dabbling in related issues,
> and we'd already solved a number of them in relation to page_mkwrite;
> so then when dirty tracking was wanted in, page_mkwrite came with it.

Well its not a big problem -- I knew there were several people lined
up who wanted it. XFS is another one IIRC.

>>Must it be able to sleep?
> 
> 
> Not as David was using it: that was something I felt strongly it
> should be allowd to do.  For example, in order to allocate backing
> store for the mmap'ed page to be written (that need has been talked
> about off and on for years).

Fine, and Mark and Anton confirm it (cc'ed, thanks guys).

This is another discussion, but do we want the page locked here? Or
are the filesystems happy to exclude truncate themselves?


> After do_wp_page has tested page_mkwrite, it must release old_page after
> acquiring page table lock, not before: at some stage that ordering got
> reversed, leaving a (very unlikely) window in which old_page might be
> truncated, freed, and reused in the same position.

Andrew please apply.

Signed-off-by: Nick Piggin <npiggin@suse.de>

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  mm/memory.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- 2.6.20-rc6/mm/memory.c	2007-01-25 08:25:27.000000000 +0000
> +++ linux/mm/memory.c	2007-01-29 15:35:56.000000000 +0000
> @@ -1531,8 +1531,6 @@ static int do_wp_page(struct mm_struct *
>  			if (vma->vm_ops->page_mkwrite(vma, old_page) < 0)
>  				goto unwritable_page;
>  
> -			page_cache_release(old_page);
> -
>  			/*
>  			 * Since we dropped the lock we need to revalidate
>  			 * the PTE as someone else may have changed it.  If
> @@ -1541,6 +1539,7 @@ static int do_wp_page(struct mm_struct *
>  			 */
>  			page_table = pte_offset_map_lock(mm, pmd, address,
>  							 &ptl);
> +			page_cache_release(old_page);
>  			if (!pte_same(*page_table, orig_pte))
>  				goto unlock;
>  		}
> 


-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
