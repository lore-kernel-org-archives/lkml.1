Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZCSRcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZCSRcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZCSRcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:32:16 -0400
Received: from gw.goop.org ([64.81.55.164]:43793 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbZCSRcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:32:15 -0400
Message-ID: <49C2818B.9060201@goop.org>
Date: Thu, 19 Mar 2009 10:31:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Avi Kivity <avi@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <200903191232.05459.nickpiggin@yahoo.com.au>
In-Reply-To: <200903191232.05459.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> Also, assuming that disabling the interrupt is enough to get the
>> guarantees we need here, there's a Xen problem because we don't use IPIs
>> for cross-cpu tlb flushes (well, it happens within Xen).  I'll have to
>> think a bit about how to deal with that, but I'm thinking that we could
>> add a per-cpu "tlb flushes blocked" flag, and maintain some kind of
>> per-cpu deferred tlb flush count so we can get around to doing the flush
>> eventually.
>>
>> But I want to make sure I understand the exact algorithm here.
>>     
>
> FWIW, powerpc actually can flush tlbs without IPIs, and it also has
> a gup_fast. powerpc RCU frees its page _tables_ so we can walk them,
> and then I use speculative page references in order to be able to
> take a reference on the page without having it pinned.
>   

Ah, interesting.  So disabling interrupts prevents the RCU free from 
happening, and non-atomic pte fetching is a non-issue.  So it doesn't 
address the PAE side of the problem.

> Turning gup_get_pte into a pvop would be a bit nasty because on !PAE
> it is just a single load, and even on PAE it is pretty cheap.
>   

Well, it wouldn't be too bad; for !PAE it would turn into something we 
could inline, so there'd be little to no cost.  For PAE it would be out 
of line, but a direct function call, which would be nicely cached and 
very predictable once we've gone through the the loop once (and for Xen 
I think I'd just make it a cmpxchg8b-based implementation, assuming that 
the tlb flush hypercall would offset the cost of making gup_fast a bit 
slower).

But it would be better if we can address it at a higher level.

    J
