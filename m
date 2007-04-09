Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXDIWeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXDIWeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXDIWeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:34:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50845 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXDIWeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:34:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] Pad irq_desc to internode cacheline size
References: <20070409195356.GA5275@localhost.localdomain>
	<20070409135729.a466e9cb.akpm@linux-foundation.org>
	<m1ejmt1apj.fsf@ebiederm.dsl.xmission.com>
	<20070409220936.GD5275@localhost.localdomain>
Date: Mon, 09 Apr 2007 16:33:25 -0600
In-Reply-To: <20070409220936.GD5275@localhost.localdomain> (Ravikiran
	G. Thirumalai's message of "Mon, 9 Apr 2007 15:09:36 -0700")
Message-ID: <m1abxh18lm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai <kiran@scalex86.org> writes:

> !!! No. internode aligned is 4k only if CONFIG_X86_VSMP is chosen.  The
> internode line size defaults to SMP_CACHE_BYTES for all other machine types.
> Please note that an INTERNODE_CACHE_SHIFT of 12 is defined under 
> #ifdef CONFIG_X86_VSMP in include/asm-x86_64/cache.h

You are right.  I got confused by the single definition in
asm-x86_64/cache.h

Think you can rewrite that concept so it is readable and maintainable?
Maybe all in Kconfig like INTERNODE_CACHE_BYTES or all in an sub
architecture specific header?

>> I believe this ups our worst case memory consumption for
>> the array from 1M to 32M.  Although the low end might be 2M.
>> I can't recall if an irq_desc takes one cache line or two
>> after we have put the cpu masks in it.
>> 
>> My gut feel says that what we want to do is delay this until
>> we are dynamically allocating the array members.  Then we can at
>> least have the chance of allocating the memory on the proper NUMA
>> node, and won't need the extra NUMA alignment.
>
> I was thinking on those lines as well.  But, until we get there, can we have
> this in as stop gap?  The patch does not increase the memory footprint for
> any other architecture other than vSMPowered systems.

I don't think so because it doesn't make sense, and we are talking
about extremely generic code.  And several other architectures are
already using the INTERNODE_CACHE_SHIFT concept.  So even if VSMP
is the only architecture that defines it today, it doesn't look like
the only architecture that will define it tomorrow.

If you are sufficient NUMA to care you will destroy your performance
by handling the irq on the wrong node.  So it make no sense to have
an irq_desc that is optimized for handling an irq on the wrong node.

So until we can handle this cleanly let's not let your platform
specific pain and insanity spill into other architectures.

I'm about half way there towards a patchset to get irq_desc
dynamically allocated, and if can find a day or two in the next
couple of weeks I 2.6.23 sounds like a possibility.  So this shouldn't
be something that is impossibly distant.

Eric
