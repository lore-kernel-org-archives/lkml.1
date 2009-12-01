Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZLAXW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZLAXW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZLAXW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:22:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:45580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZLAXW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:22:56 -0500
Message-ID: <4B15A5A6.2090200@kernel.org>
Date: Wed, 02 Dec 2009 08:24:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, michal.simek@petalogix.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au> <4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au> <4B152D22.9070001@kernel.org> <alpine.DEB.2.00.0912010946340.8841@router.home> <20091201160119.GA10826@elte.hu>
In-Reply-To: <20091201160119.GA10826@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/02/2009 01:01 AM, Ingo Molnar wrote:
>>> The problem is that on UP configurations.  Percpu memory allocator 
>>> becomes a simple wrapper around kmalloc and there's no way to 
>>> specify larger alignment when requesting memory from kmalloc.
>>
>> There is usually no point in aligning in UP. Alignment is typically 
>> done for smp configurations to limit cache line bouncing and control 
>> cache line use/
> 
> There is a natural minimum alignment for UP and it's smaller than the 
> cache-line size: machine word size. All our allocators (except bootmem) 
> align to machine word so there's no need to specify this explicitly.
> 
> Larger alignment than that just wastes memory - which waste UP systems 
> can afford the least.

This isn't usual alignment.  struct work_struct has one data fields
which is overloaded for two purposes.  Lower few bits are used to
carry flags while upper bits are used to point to sruct
cpu_workqueue_struct.  So, the number of available bits for flags are
determined by the alignment of cpu_workqueue_struct.  Memory usage for
cwqs isn't a big concern here.  Many workqueues will go away.  I think
we'll end up with less than half of what we have today while we'll
continue to have large number of works.

I'll just create alloc_cwq function which forces the alignment on UP.

Thanks.

-- 
tejun
