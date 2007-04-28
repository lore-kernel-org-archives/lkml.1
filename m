Return-Path: <linux-kernel-owner+w=401wt.eu-S1030991AbXD1Gaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030991AbXD1Gaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXD1Gaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:30:39 -0400
Received: from gw.goop.org ([64.81.55.164]:41182 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161221AbXD1GaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:30:08 -0400
Message-ID: <4632E9F1.8020407@goop.org>
Date: Fri, 27 Apr 2007 23:30:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org> <m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> When constructing the initial pagetable in pagetable_init, make sure
>> that non-PSE pmds are updated to PSE ones.  This fixes a bug in the
>> paravirt pagetable init code, which otherwise tries to avoid overwrite
>> existing mappings.
>>
>> This moves the definition of pmd_huge() out of the hugetlbfs files
>> into pgtable.h.
>>
>> [ I know Eric would like to make larger changes to the way
>>   pagetable init works, but this patch is the minimal fix to an
>>   existing bug. ]
>>     
>
> My preference would be for whoever had:
> paravirt_ops-hooks-to-set-up-initial-pagetable.patch
>
> queued to drop it until we can get a version that doesn't break early
> page table setup.
>
> Your partial fix still leaves the real page tables in a partially
> incorrect state, and even if we removed your changes from the PSE
> path we still can wind up not failing to set _PAGE_NX in the
> appropriate places on 4K pages.
>
> I have tried to be constructive and suggest how we can fix this
> cleanly.
>   

Well, you've proposed:

   1. write the pte entries unconditionally
   2. a callback to ask what permissions each page should be mapped
   3. a general mechanism to query for pages which require special
      mappings, such at PAT in the native case, and RO for Xen

      and I've proposed:

   4. if we're given a template pagetable, then don't overwrite any
      existing mapping


1 works in general, but it doesn't work for Xen because it ends up
mapping pagetable pages RW.

If 2 is constrained to boot-time init then its reasonably possible to
implement, but it will add a new paravirt_op which isn't going to make
Andi happy.  A general mechanism will be extremely hard to implement,
because I don't know of an efficient way to identify whether a
particular pfn is part of a pagetable or not.

3 suffers the same problem as the general form of 2, but its more
ambitious since it would also allow identification of pages with an
arbitrary set of special properties.

Perhaps 2 and 3 could be implemented by stashing some state in the page
structure, but that's no use for pagetable_init, because page structures
don't exist at that point.

4 is what I've implemented.  It works for Xen, but it currently prevents
non-PAE native booting from properly constructing a PSE mapping for the
kernel.  And as you point out, it also prevents harmless (from Xen's
perspective) updates of the page permissions.  Plus it just adds a bit
more uglification entropy to mm/init.c.


So, in summary:

Given that 1 is unworkable for Xen, 2 is kind of groady, 3 is
longer-term research project and 4 is buggy, we need something else.

I don't have any particularly bright ideas, but there is the other idea
I mentioned.  I could pre-initialize the pagetable with the Xen
template, but use unconditional calls to set_pte in pagetable_init. 
However, the init-time xen_set_pte simply refuse to set _PAGE_WRITE on a
pte which isn't already writable, thereby protecting the RO state of the
pagetable pages.  Once pagetable construction has finished, it would
switch to the real xen_set_pte, which operates as normal.

This has the downside of making init-time xen_set_pte a little strange,
but it does have the advantage of making the Xen constraints solely the
responsibility of the Xen code, and it is mitigated by the fact that it
is only in effect during pagetable_init.

Would that work for everyone?

    J
