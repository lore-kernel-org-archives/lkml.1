Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbZENPy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbZENPy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZENPyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:54:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:44046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805AbZENPyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:54:46 -0400
Message-ID: <4A0C3EF9.4050907@kernel.org>
Date: Fri, 15 May 2009 00:55:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap	 allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org> <4A0C46B80200007800000ED4@vpn.id2.novell.com>
In-Reply-To: <4A0C46B80200007800000ED4@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 15:54:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

Jan Beulich wrote:
> In order to reduce the amount of work to do during lookup as well as
> the chance of having a collision at all, wouldn't it be reasonable
> to use as much of an allocated 2/4M page as possible rather than
> returning whatever is left after a single CPU got its per-CPU memory
> chunk from it? I.e. you'd return only those (few) pages that either
> don't fit another CPU's chunk anymore or that are left after running
> through all CPUs.
> 
> Or is there some hidden requirement that each CPU's per-CPU area must
> start on a PMD boundary?

The whole point of doing the remapping is giving each CPU its own PMD
mapping for perpcu area, so, yeah, that's the requirement.  I don't
think the requirement is hidden tho.

How hot is the cpa path?  On my test systems, there were only few
calls during init and then nothing.  Does it become very hot if, for
example, GEM is used?  But I really don't think the log2 binary search
overhead would be anything noticeable compared to TLB shootdown and
all other stuff going on there.

> This would additionally address a potential problem on 32-bits -
> currently, for a 32-CPU system you consume half of the vmalloc space
> with PAE (on non-PAE you'd even exhaust it, but I think it's
> unreasonable to expect a system having 32 CPUs to not need PAE).

I recall having about the same conversation before.  Looking up...

-- QUOTE --
  Actually, I've been looking at the numbers and I'm not sure if the
  concern is valid.  On x86_32, the practical number of maximum
  processors would be around 16 so it will end up 32M, which isn't
  nice and it would probably a good idea to introduce a parameter to
  select which allocator to use but still it's far from consuming all
  the VM area.  On x86_64, the vmalloc area is obscenely large at 245,
  ie 32 terabytes.  Even with 4096 processors, single chunk is measly
  0.02%.

  If it's a problem for other archs or extreme x86_32 configurations,
  we can add some safety measures but in general I don't think it is a
  problem.
-- END OF QUOTE --

So, yeah, if there are 32bit 32-way NUMA machines out there, it would
be wise to skip remap allocator on such machines.  Maybe we can
implement a heuristic - something like "if vm area consumption goes
over 25%, don't use remap".

Thanks.

-- 
tejun
