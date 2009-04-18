Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZDRU3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZDRU3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZDRU3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:29:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZDRU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:29:09 -0400
To: joseph.cihula@intel.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel support II
From: Andi Kleen <andi@firstfloor.org>
References: <49D1A6AB.5090808@intel.com> <87d4baqnxy.fsf@basil.nowhere.org>
Date: Sat, 18 Apr 2009 22:29:02 +0200
In-Reply-To: <87d4baqnxy.fsf@basil.nowhere.org> (Andi Kleen's message of "Sat, 18 Apr 2009 12:02:49 +0200")
Message-ID: <878wlxr9ip.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
>> +	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
>> +	pte_unmap(pte);
>> +	return 0;
>> +}
>> +
>> +static int map_pages_for_tboot(unsigned long vaddr, unsigned long start_pfn,
>> +			       unsigned long nr)
>> +{
>> +	/* Reuse the original kernel mapping */
>> +	tboot_pg_dir = pgd_alloc(&tboot_mm);
>
> That puts the PGD into the pgd_list and then pageattr.c will actually
> walk that list and change ptes, assuming it's a standard kernel 
> mapping. Can you tolerate that? It seems dangerous. Better to use
> a pgd_alloc_kernel(). There's none, but you could add one.

Thought some more about this. I think you're ok on 64bit at least
because the kernel mappings are elsewhere from the identity map and
keeping them in sync with pageattr makes sense and avoids illegal
cache attribute aliases.

But on 32bit it could be potentially a problem in general. e.g.
what happens when the tboot shared page is in the area the kernel
is running? You would crash during the window where you run 
in that pgd.

It would be probably safer to use a low memory trampoline supplied
by the kernel too that then loads the new pgd.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
