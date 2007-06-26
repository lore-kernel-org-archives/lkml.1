Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXFZCW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXFZCW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbXFZCWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:22:19 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:42345 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753149AbXFZCWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:22:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fvCxE/ebHcsKf5jcj/V4CqNw4NbWuGwNTV+dN368H5WNzDrrdVN2WcmnZs8QwcCqyh1SIlL1aPb1Ev+M5CyoZOHctjz8frAk2NgE8AP5FCuiPdFCWBgMRwya+su6mJvqEtkxs6vvQ9rB9iYjNye49Rip/IG53GaJdfqUydDMnbo=  ;
X-YMail-OSG: yXHlr4oVM1nvabJktasV086PhIzZm38Ca1yMblmJHrQopi1Zf4YzZi.I2AmpvU5YZ2F8W9oKSmKFuCJlUde6fcnxzhRWwJiaJtK7MSpgrxMQTVWfpwk-
Message-ID: <4680784F.60607@yahoo.com.au>
Date: Tue, 26 Jun 2007 12:22:07 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Petr Vandrovec <petr@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <andrea@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22-rc5-yesterdaygit with VM debug: BUG in mm/rmap.c:66: anon_vma_link
 ?
References: <467F6882.9000800@vmware.com> <Pine.LNX.4.64.0706252129430.22492@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0706252129430.22492@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 25 Jun 2007, Petr Vandrovec wrote:
> 
>>Hello,
>>  to catch some memory corruption bug in our code I've modified malloc to do
>>mmap + mprotect - which has unfortunate effect that it creates thousands and
>>thousands of VMAs.  Everything works (though rather slowly on kernel with
>>CONFIG_VM_DEBUG) until application does fork() - kernel crashes on fork()
>>because copy_process()'s anon_vma_link complains that it could not find anon
>>vma after walking through 100000 elements of anon list - which seems strange,
>>as I did not touch system wide limit (which is 65536 vmas), and mprotect()s
>>started failing after creating 65536 vmas, as expected.
>>
>>Full output of test program and full kernel dmesg are at
>>http://buk.vc.cvut.cz/linux/rmap.
> 
> 
> Thanks for finding that, Petr.  Patch below just solves the problem
> by removing validate_anon_vma; but in the past both Nick and Andrea
> have been less eager to delete old debug code than I am, so it would
> be rude to put this patch in without an Ack from at least one of them
> - they may prefer to tinker with the limit instead, but removing the
> whole function is my preference.
> 
> You were puzzled by the numbers.  What happens is that the parent
> builds up to 65536 vmas, and from that point on is not allowed to
> split vmas any more, so the mprotects fail as you expected and
> observed.  But further mmaps succeed, up to your own 131072 limit,
> because each added area can simply extend the last vma.
> 
> All the vmas of interest here (i.e. not the executable, libs, stack
> etc.), for better or worse, share the same anon_vma: so that if
> mprotect were later used to undo the difference between neighbouring
> vmas, they could be merged together - assigning different anon_vmas
> would obstruct that merge (but yes, we've a guessed tradeoff there).
> 
> So the parent has around 65500 vmas all linked to the same anon_vma;
> and in the course of its fork, links the child's dup vmas one by one
> to that same anon_vma, until it hits the validate_anon_vma's 100000
> BUG_ON.  It's very much the nature of the anon_vma, to be shared
> between parent and child: anon pages may be shared between both.
> 
> If we raised the 100000 limit to 2*sysctl_max_map_count, then your
> program would be safe (setting aside changes to that max_map_count),
> but another program in which the child also forked would then BUG.
> 
> 
> 
> [PATCH] kill validate_anon_vma to avoid mapcount BUG

Fine by me. I had been meaning to get rid of that so DEBUG_VM is more
useful to be turned on in betas or even production kernels.

-- 
SUSE Labs, Novell Inc.
