Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXDWJO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXDWJO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXDWJO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:14:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35241 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXDWJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:14:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
Date: Mon, 23 Apr 2007 03:12:51 -0600
In-Reply-To: <4627E099.209@goop.org> (Jeremy Fitzhardinge's message of "Thu,
	19 Apr 2007 14:35:21 -0700")
Message-ID: <m1d51vxxm4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Chuck Ebbert wrote:
>> H. Peter Anvin wrote:
>>   
>>> Andi Kleen wrote:
>>>     
>>>> Then we would have seen reports surely?
>>>>       
>
> Yes, I would have thought so.  It surprised me that such an obvious bug
> could be there, apparently for a long time.  But it's real, and
> potentially affects everyone.  It probably doesn't affect highly modular
> distros much, since the kernel itself will be relatively small.
>
>> I never saw a description of the symptoms of encountering this bug.
>> Does it just hang, or what?
>>   
>
> You get an early-fault message on-screen, assuming that's enabled;
> otherwise it will just appear to hang.  It happens in pagetable_init,
> when it allocates a new pagetable above the head.S mapping (8M in my
> case).  It will only hit if the kernel size approaches a 4M boundary,
> since it won't leave enough space mapped to construct the lowmem mappings.
>
> It only affects native booting, since under Xen all those mappings have
> already been constructed.  It happened to me with a paravirt kernel that
> happened to Xen compiled into it, but that was irrelevent (though
> misleading; the 40k difference in kernel size was enough to make it not
> happen in a non-Xen kernel).

I happened to be looking at this stretch of code and I have realized
that this is quite simply the wrong fix.

The problem is that it depends intimately on the details of
alloc_bootmem_pages_low.  Essentially the problem is that when
we are setting up the identity mappings in paging_init we assume
the identity mappings already exist.

If there are holes in the memory map or someone changes the way
pages are returned from alloc_bootmem_pages_low() this code
will break again.

The only way to ensure this will not happen is to do what we do
on x86_64 and map the new page table page into our address space
before we write to it.  Assuming the page we allocate is already
mapped is simply not robust.

Eric
