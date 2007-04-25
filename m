Return-Path: <linux-kernel-owner+w=401wt.eu-S2993139AbXDYXqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993139AbXDYXqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993140AbXDYXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:46:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53256 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993139AbXDYXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:46:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
	<20070425044813.f83dde4e.akpm@linux-foundation.org>
	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
	<462FD179.6070802@goop.org> <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>
	<462FDF6D.8050903@goop.org>
Date: Wed, 25 Apr 2007 17:45:07 -0600
In-Reply-To: <462FDF6D.8050903@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 16:08:29 -0700")
Message-ID: <m13b2oow70.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> No.  Please just remove the conditionals on the leaf pages.
>>   
>
> So, to be specific, you mean make updating the pte_t entries (and pmd_t
> entries which refer to hugepages) entries unconditional?

I mean make updating pte_t and pmd_t entries that refer to identity
mapped physical pages unconditional.

>> We know exactly what we require them to be, there is minimal
>> cost and no downside to just setting the pte entries to
>> what we want them to be for the identity mapping.
>>
>> It doesn't make sense for paravirtualization or anything else to 
>> influence that.
>>
>> This may be redoing work that has been done before but it is
>> doing it all one common place.
>>   
>
> The issue is not a matter of avoiding duplicate work, but making sure
> all the pagetables are consistent from Xen's perspective.
>
> Specifically, you may not ever, at any time, create a writable mapping
> of a page which is currently part of an active pagetable.  This means
> that when we're creating mappings of physical memory, the pages which
> are part of the current pagetable must be mapped RO.  The easiest way I
> found to guarantee that is to copy the Xen-provided pagetable as a
> template, and only update pages which are missing.

Hmm.  I now see your problem.

> The other way I could do this is to have special-purpose init-time
> version of xen_set_pte which checks to see if it's making a RO mapping
> RW, and refuse to do it.  That would minimize the changes to mm/init.c,
> but give init-time set_pte rather unexpected hidden semantics.

Yes.  However how do we handle attempting to create this kind
of mapping when mmap /dev/mem?  or /dev/kmem?

I'm pretty certain there are other paths through the kernel where
we can get page table mapping.

Right now by leaving things read-only you are hiding from the kernel 
what you are really trying to do.  That makes me distinctly
uncomfortable.  In general when things get swept under the rug
we can never handle the properly.  Although this issue may be small
enough it doesn't matter.

I suspect what we want to do is come up with a function to call
to test to see if a page should be read-only and map such pages
_PAGE_KERNEL_RO, or _PAGE_KERNEL_RO_EXEC if it's code.

Speaking of things what are paravirt_alloc_pd and parafirt_alloc_pd 
supposed to do?

Eric
