Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbZEOHrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbZEOHrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZEOHrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:47:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:21032 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZEOHri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:47:38 -0400
Message-Id: <4A0D3A390200007800001081@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 15 May 2009 08:47:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <andi@firstfloor.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap	
	 allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
 <4A0C46B80200007800000ED4@vpn.id2.novell.com>
 <4A0C3EF9.4050907@kernel.org>
In-Reply-To: <4A0C3EF9.4050907@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 14.05.09 17:55 >>>
>> In order to reduce the amount of work to do during lookup as well as
>> the chance of having a collision at all, wouldn't it be reasonable
>> to use as much of an allocated 2/4M page as possible rather than
>> returning whatever is left after a single CPU got its per-CPU memory
>> chunk from it? I.e. you'd return only those (few) pages that either
>> don't fit another CPU's chunk anymore or that are left after running
>> through all CPUs.
>> 
>> Or is there some hidden requirement that each CPU's per-CPU area must
>> start on a PMD boundary?
>
>The whole point of doing the remapping is giving each CPU its own PMD
>mapping for perpcu area, so, yeah, that's the requirement.  I don't
>think the requirement is hidden tho.

No, from looking at the code the requirement seems to only be that you
get memory allocated from the correct node and mapped by a large page.
There's nothing said why the final virtual address would need to be large
page aligned. I.e., with a slight modification to take the NUMA requirement
into account (I noticed I ignored that aspect after I had already sent that
mail), the previous suggestion would still appear usable to me.

>How hot is the cpa path?  On my test systems, there were only few
>calls during init and then nothing.  Does it become very hot if, for
>example, GEM is used?  But I really don't think the log2 binary search
>overhead would be anything noticeable compared to TLB shootdown and
>all other stuff going on there.

I would view cutting down on that only as a nice side effect, not a primary
reason to do the change. The primary reason is this:

>> This would additionally address a potential problem on 32-bits -
>> currently, for a 32-CPU system you consume half of the vmalloc space
>> with PAE (on non-PAE you'd even exhaust it, but I think it's
>> unreasonable to expect a system having 32 CPUs to not need PAE).
>
>I recall having about the same conversation before.  Looking up...
>
>-- QUOTE --
>  Actually, I've been looking at the numbers and I'm not sure if the
>  concern is valid.  On x86_32, the practical number of maximum
>  processors would be around 16 so it will end up 32M, which isn't
>  nice and it would probably a good idea to introduce a parameter to
>  select which allocator to use but still it's far from consuming all
>  the VM area.  On x86_64, the vmalloc area is obscenely large at 245,
>  ie 32 terabytes.  Even with 4096 processors, single chunk is measly
>  0.02%.

Just to note - there must be a reason we (SuSE/Novell) build our default
32-bit kernel with support for 128 CPUs, which now is simply broken.

>  If it's a problem for other archs or extreme x86_32 configurations,
>  we can add some safety measures but in general I don't think it is a
>  problem.
>-- END OF QUOTE --
>
>So, yeah, if there are 32bit 32-way NUMA machines out there, it would
>be wise to skip remap allocator on such machines.  Maybe we can
>implement a heuristic - something like "if vm area consumption goes
>over 25%, don't use remap".

Possibly, as a secondary consideration on top of the suggested reduction
of virtual address space consumption.

Jan

