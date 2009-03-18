Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZCRVXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZCRVXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZCRVXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:23:45 -0400
Received: from gw.goop.org ([64.81.55.164]:37968 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZCRVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:23:45 -0400
Message-ID: <49C1665A.4080707@goop.org>
Date: Wed, 18 Mar 2009 14:23:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com>
In-Reply-To: <49C16411.2040705@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeremy Fitzhardinge wrote:
>> Disabling the interrupt will prevent the tlb flush IPI from coming in 
>> and flushing this cpu's tlb, but I don't see how it will prevent some 
>> other cpu from actually updating the pte in the pagetable, which is 
>> what we're concerned about here.  
>
> The thread that cleared the pte holds the pte lock and is now waiting 
> for the IPI.  The thread that wants to update the pte will wait for 
> the pte lock, thus also waits on the IPI and gup_fast()'s 
> local_irq_enable().  I think.

But hasn't it already done the pte update at that point?

(I think this conversation really is moot because the kernel never does 
P->P pte updates any more; its always P->N->P.)

>> Is this the only reason to disable interrupts?  
>
> Another comment says it also prevents pagetable teardown.

We could take a reference to the mm to get the same effect, no?

>> Also, assuming that disabling the interrupt is enough to get the 
>> guarantees we need here, there's a Xen problem because we don't use 
>> IPIs for cross-cpu tlb flushes (well, it happens within Xen).  I'll 
>> have to think a bit about how to deal with that, but I'm thinking 
>> that we could add a per-cpu "tlb flushes blocked" flag, and maintain 
>> some kind of per-cpu deferred tlb flush count so we can get around to 
>> doing the flush eventually.
>
> I was thinking about adding a hypercall for cross-vcpu tlb flushes.  
> Guess I'll wait for you to clear up all the issues first.

Typical...

    J

