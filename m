Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYAYSjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYAYSjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYAYSje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:39:34 -0500
Received: from gw.goop.org ([64.81.55.164]:38349 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbYAYSjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:39:33 -0500
Message-ID: <479A2CE0.6060206@goop.org>
Date: Fri, 25 Jan 2008 10:39:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick> <4797DBA0.5020909@goop.org> <20080125153032.GE11846@elte.hu> <479A0632.9090205@goop.org> <20080125180828.GB10993@elte.hu>
In-Reply-To: <20080125180828.GB10993@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> spurious faults happen all the time on SMP, in the native kernel.
>
> And what i mean is that Linux mprotect currently does not take advantage 
> of x86's ability to just change the ptes, because there's no structured 
> way to tell mm/mprotect.c that "it's safe to skip the TLB flush here". 
>
> The flush happens in mm/mprotect.c's change_protection() function:
>
>         flush_tlb_range(vma, start, end);
>
> and that is unnecessary when we increase the protection rights, such as 
> in a RO->RW change. (all that is needed is an smp_wmb() instead, to make 
> sure all the pte modifications are visible when the syscall returns.)
>
> and it's a really rare case these days that you can find an area where 
> Linux does not make use of a hardware MMU feature - so we should fix 
> this ;-)

Well, I guess this isn't really specific to x86; we could always 
legitimately not do a tlb flush after increasing permissions and leave 
the fault handler to clean up the mess where needed.  But I don't think 
that's necessarily much of a win; it's cheaper to just do the tlb flush 
rather than take a spurious fault, unless the faults are very rare.  If 
someone is doing an mprotect on a piece of memory (esp to make it 
writable), my guess is that they're going to touch that memory in the 
very near future.

The big win for this patch is avoiding cross-cpu tlb invalidation when 
changing kernel mappings.  mprotect doesn't attempt to do that anyway, 
and so can incur spurious faults on other CPUs.

    J
