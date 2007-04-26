Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXDZAO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXDZAO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXDZAO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:14:29 -0400
Received: from gw.goop.org ([64.81.55.164]:45416 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXDZAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:14:27 -0400
Message-ID: <462FEEFC.6030401@goop.org>
Date: Wed, 25 Apr 2007 17:14:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>	<462FD179.6070802@goop.org> <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>	<462FDF6D.8050903@goop.org> <m13b2oow70.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b2oow70.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> The issue is not a matter of avoiding duplicate work, but making sure
>> all the pagetables are consistent from Xen's perspective.
>>
>> Specifically, you may not ever, at any time, create a writable mapping
>> of a page which is currently part of an active pagetable.  This means
>> that when we're creating mappings of physical memory, the pages which
>> are part of the current pagetable must be mapped RO.  The easiest way I
>> found to guarantee that is to copy the Xen-provided pagetable as a
>> template, and only update pages which are missing.
>>     
>
> Hmm.  I now see your problem.
>
>   
>> The other way I could do this is to have special-purpose init-time
>> version of xen_set_pte which checks to see if it's making a RO mapping
>> RW, and refuse to do it.  That would minimize the changes to mm/init.c,
>> but give init-time set_pte rather unexpected hidden semantics.
>>     
>
> Yes.  However how do we handle attempting to create this kind
> of mapping when mmap /dev/mem?  or /dev/kmem?
>   

Hm, I hadn't thought about that. I'm not sure that /dev/k?mem is very
useful in an unprivileged guest, but I guess its useful for debugging or
stats or something. It's tricky to tell whether an arbitrary pfn is part
of a pagetable or not; there's a PG_PINNED page flag to tell you if its
active, but iff you've already determined its a pagetable page.

> I'm pretty certain there are other paths through the kernel where
> we can get page table mapping.
>
> Right now by leaving things read-only you are hiding from the kernel 
> what you are really trying to do.  That makes me distinctly
> uncomfortable.  In general when things get swept under the rug
> we can never handle the properly.  Although this issue may be small
> enough it doesn't matter.
>   

Well, the general idea is that in a paravirtualized environment
pagetable pages need special handling. Different hypervisors need
different handling, but they all need something special. The paravirt
hooks are intended to capture all the interesting events, without
over-constraining what special thing the hypervisor wants to do at that
point.

That's why I went for the "allow the hypervisor to provide a prototype
pagetable, and avoid the bits it has already set up"; it allows it to do
whatever it wants, without getting too specific about what that is, and
retains a fairly straightforward interface.

> I suspect what we want to do is come up with a function to call
> to test to see if a page should be read-only and map such pages
> _PAGE_KERNEL_RO, or _PAGE_KERNEL_RO_EXEC if it's code.
>   

Hm, I think that's a hard function to write in general. For the special
case of pagetable_init it wouldn't be too hard, but it doesn't seem like
a big improvement over the current state of affairs.

> Speaking of things what are paravirt_alloc_pd and parafirt_alloc_pd 
> supposed to do?
>   
(alloc_pd and alloc_pt)

Broadly speaking, they tell the hypevisor that there's a new page about
to be attached to the pagetable. Xen uses it as the hook to map those
pages RO if the pagetable is active. VMI (and lguest?) use it to tell
the hypervisor's shadow pagetable machinery that there's something new
to track.

J
