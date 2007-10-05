Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbXJEEIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbXJEEIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 00:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXJEEIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 00:08:46 -0400
Received: from gw.goop.org ([64.81.55.164]:57770 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXJEEIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 00:08:45 -0400
Message-ID: <4705B8CA.5070608@goop.org>
Date: Thu, 04 Oct 2007 21:08:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickens <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <470596C4.8060804@goop.org> <20071004194432.9b3353c2.akpm@linux-foundation.org>
In-Reply-To: <20071004194432.9b3353c2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> y'know, I think I think it's been several years since I saw a report of an
> honest to goodness, genuine SMP race in core kernel.  We used to be
> infested by them, but the term has fallen into disuse.  Interesting, but
> OT.
>   

I was a bit surprised to find myself typing it too.  I guess it could
also be a preempt race, which has been a bit more common.  Anyway, its a
deliberately unlocked access to the pagetable structure, so not terribly
surprising.

>> It seems to me that there are a few ways to fix this:
>>
>>    1. Use asm-generic/pgtable.h when CONFIG_PARAVIRT is enabled.  This
>>       will clearly work, but is pretty blunt.
>>    2. Make test_and_clear_pte_flags a new paravirt-op, which can be
>>       implemented in Xen as a hypercall, and as a raw test_and_clear_bit
>>       for everyone else.  The downside is adding yet another pv-op.
>>    3. Restructure the pagetable setup code so that the mm is not added
>>       to the prio tree until after arch_dup_mmap has been called (and
>>       the converse for exit_mmap).  This is arguably cleaner, but I
>>       haven't looked to see how much trouble this would be.
>>
>> Thoughts anyone?  Does making the pagetables visible "early" cause
>> problems for anyone else?
>>     
>
> I expect that 2) has the maximum niceness*suitable-for-2.6.23 product.
>   

OK, I'll whip a patch together.

> That's if you actually care much about kernel.org major releases - do many
> people run kernel.org kernels on Xen? 

Well, given that there hasn't been a Xen-capable kernel.org release yet,
no...  But we'll see what happens when .23 goes out the door.

>  If "not many" then we could perhaps
> do something more elaborate for 2.6.23.1.  But adding ever more pvops as
> core kernel evolves was always expected.
>   

I think keep it simple for now; anything significant can wait for the
brave new world of unified x86.

    J

