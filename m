Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZCDRcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZCDRcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZCDRb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:31:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:54153 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZCDRb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:31:58 -0500
Message-ID: <49AEBB05.2030704@codemonkey.ws>
Date: Wed, 04 Mar 2009 11:31:49 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<200902282309.07576.nickpiggin@yahoo.com.au>	<49AB19E1.4050604@goop.org> <200903021737.24903.nickpiggin@yahoo.com.au>
In-Reply-To: <200903021737.24903.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Monday 02 March 2009 10:27:29 Jeremy Fitzhardinge wrote:

>> Once important area of paravirtualization is that Xen guests directly
>> use the processor's pagetables; there is no shadow pagetable or use of
>> hardware pagetable nesting.  This means that a tlb miss is just a tlb
>> miss, and happens at full processor performance.  This is possible
>> because 1) pagetables are always read-only to the guest, and 2) the
>> guest is responsible for looking up in a table to map guest-local pfns
>> into machine-wide mfns before installing them in a pte.  Xen will check
>> that any new mapping or pagetable satisfies all the rules, by checking
>> that the writable reference count is 0, and that the domain owns (or has
>> been allowed access to) any mfn it tries to install in a pagetable.
> 
> Xen's memory virtualization is pretty neat, I'll give it that. Is it
> faster than KVM on a modern CPU?

There is nothing architecturally that prevents KVM from making use of 
Direct Paging.  KVM doesn't use Direct Paging because we don't expect it 
will not be worth it.  Modern CPUs (Barcelona and Nehalem class) include 
hardware support for MMU virtualization (via NPT and EPT respectively).

I think that for the most part (especially with large page backed 
guests), there's wide agreement that even within the context of Xen, 
NPT/EPT often beats PV performance.  TLB miss overhead increases due to 
additional memory accesses but this is largely mitigated by large pages 
(see Ben Serebin's SOSP paper from a couple years ago).

> Would it be possible I wonder to make
> a MMU virtualization layer for CPUs without support, using Xen's page
> table protection methods, and have KVM use that? Or does that amount
> to putting a significant amount of Xen hypervisor into the kernel..?

There are various benchmarks out there (check KVM Forum and Xen Summit 
presentations) showing NPT/EPT beating Direct Paging but FWIW the direct 
paging could be implemented in KVM.

A really unfortunate aspect of direct paging is that it requires the 
guest to know the host physical addresses.  This requires the guest to 
cooperate when doing any fancy memory tricks (live migration, 
save/restore, swapping, page sharing, etc.).  This introduces guest code 
paths to ensure that things like live migration works which is extremely 
undesirable.

FWIW, I'm not advocating not taking the Xen dom0 patches.  Just pointing 
out that direct paging is orthogonal to the architectural differences 
between Xen and KVM.

Regards,

Anthony Liguori
