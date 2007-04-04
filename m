Return-Path: <linux-kernel-owner+w=401wt.eu-S2992758AbXDDIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992758AbXDDIrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992759AbXDDIrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:47:25 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34737 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992758AbXDDIrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:47:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=j0N+2gjBtvs/ItpSp+zJrVJr2INTnZx3dHcgPt0OOuJ/OQfgUlTmR1nQ6+1hD4R+XqHUy5uyDqGzYLR8kOuSdlhv/gO0HCJcxFTNOgli4Q8m5uwA23lajySsLQrVMDvH61k9ixjDZW/QofUUoSJzWuauD2IeXf4+AC8jYimx/HY=  ;
X-YMail-OSG: Xe9jbgsVM1mbVaQMD4fyt.nj8FPbXLEJPp4mq3MSyBYI.jAK2Dhwl7NSRHqikPs8vVW4pSFRNg--
Message-ID: <4613660C.5010108@yahoo.com.au>
Date: Wed, 04 Apr 2007 18:47:08 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Ulrich Drepper <drepper@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <461357C4.4010403@yahoo.com.au> <20070404082015.GG355@devserv.devel.redhat.com>
In-Reply-To: <20070404082015.GG355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> On Wed, Apr 04, 2007 at 05:46:12PM +1000, Nick Piggin wrote:
> 
>>Does mmap(PROT_NONE) actually free the memory?
> 
> 
> Yes.
>         /* Clear old maps */
>         error = -ENOMEM;
> munmap_back:
>         vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
>         if (vma && vma->vm_start < addr + len) {
>                 if (do_munmap(mm, addr, len))
>                         return -ENOMEM;
>                 goto munmap_back;
>         }

Thanks, I overlooked the mmap vs mprotect detail. So how are the subsequent
access faults avoided?


>>In the case of pages being unused then almost immediately reused, why is
>>it a bad solution to avoid freeing? Is it that you want to avoid
>>heuristics because in some cases they could fail and end up using memory?
> 
> 
> free(3) doesn't know if the memory will be reused soon, late or never.
> So avoiding trimming could substantially increase memory consumption with
> certain malloc/free patterns, especially in threaded programs that use
> multiple arenas.  Implementing some sort of deferred memory trimming
> in malloc is "solving" the problem in a wrong place, each app really has no
> idea (and should not have) what the current system memory pressure is.

Thanks for the clarification.


>>Secondly, why is MADV_DONTNEED bad? How much more expensive is a pagefault
>>than a syscall? (including the cost of the TLB fill for the memory access
>>after the syscall, of course).
> 
> 
> That's page fault per page rather than a syscall for the whole chunk,
> furthermore zeroing is expensive.

Ah, for big allocations. OK, we could make a MADV_POPULATE to prefault
pages (like mmap's MAP_POPULATE, but without the down_write(mmap_sem)).

If you're just about to use the pages anyway, how much of a win would
it be to avoid zeroing? We allocate cache hot pages for these guys...

-- 
SUSE Labs, Novell Inc.
