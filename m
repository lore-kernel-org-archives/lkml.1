Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZIRIiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZIRIiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZIRIiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:38:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:47773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZIRIiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:38:17 -0400
Message-ID: <4AB34722.7050105@kernel.org>
Date: Fri, 18 Sep 2009 17:38:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: sparc64 pcpu failures...
References: <20090917.221807.208354411.davem@davemloft.net> <20090917.223723.07032792.davem@davemloft.net>
In-Reply-To: <20090917.223723.07032792.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 08:38:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 17 Sep 2009 22:18:07 -0700 (PDT)
> 
>> Tejun, I just started seeing the following on sparc64:
>>
>> [   56.422005] WARNING: at mm/vmalloc.c:1991 pcpu_get_vm_areas+0x1b4/0x5fc()
>  ...
>> Might this be a result of:
>>
>> commit bcb2107fdbecef3de55d597d23453747af81ba88
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Fri Aug 14 15:00:53 2009 +0900
>>
>>     sparc64: use embedding percpu first chunk allocator
>>     
>>     sparc64 currently allocates a large page for each cpu and partially
>>     remap them into vmalloc area much like what lpage first chunk
>>     allocator did.  As a 4M page is used for each cpu, this results in
>>     very large unit size and also adds TLB pressure due to the double
>>     mapping of pages in the first chunk.
>>     
>>     This patch converts sparc64 to use the embedding percpu first chunk
>>     allocator which now knows how to handle NUMA configurations.  This
>>     simplifies the code a lot, doesn't incur any extra TLB pressure and
>>     results in better utilization of address space.
>>     
>>     Signed-off-by: Tejun Heo <tj@kernel.org>
>>     Acked-by: David S. Miller <davem@davemloft.net>
>>
>> Do you think?
> 
> I've verified that reverting this makes the problem go away.

Yes, this would be the result of the new congruent sparse allocator.
Heh... I didn't really expect that WARN_ON() to actually trigger.
What it means is that the farthest percpu units were too far to fit
into vmalloc area so percpu chunks couldn't be allocated in the
vmalloc area.  Checking... vmalloc area on sparc64 is only 4G so yeap
that is entirely possible.

Hmmm... the congruent sparse allocator assumes vmalloc area to be
larger with some margin than the farthest physical memory nodes.  On
x86, powerpc and ia64, this holds with sufficient margin.  Would it be
possible to modify sparc64 memory layout so that the assumption can be
satisfied?  If that's not possible, going back to lpage is an option
but in many ways congruent sparse allocator is better.

Thanks.

-- 
tejun
