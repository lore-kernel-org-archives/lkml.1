Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173Ab0AUBMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0AUBMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297Ab0AUBMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:12:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51931 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0AUBMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:12:01 -0500
To: Chris Frost <frost@cs.ucla.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Benny Halevy <bhalevy@panasas.com>, Andrew@firstfloor.org,
       "Morton <akpm"@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>
Subject: Re: [PATCH] fs: add fincore(2) (mincore(2) for file descriptors)
From: Andi Kleen <andi@firstfloor.org>
References: <20100120215712.GO27212@frostnet.net>
Date: Thu, 21 Jan 2010 02:11:59 +0100
In-Reply-To: <20100120215712.GO27212@frostnet.net> (Chris Frost's message of "Wed, 20 Jan 2010 13:57:12 -0800")
Message-ID: <87k4vc2rds.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Frost <frost@cs.ucla.edu> writes:


> For a microbenchmark that sequentially queries whether the pages of a large
> file are in memory fincore is 7-11x faster than mmap+mincore+munmap
> when querying one page a time (Pentium 4 running a 32 bit SMP kernel).

I haven't read your paper, but naively it was not fully clear 
to me why the application can't simply prefetch everything and let
the kernel worry if it's already in memory or not?

Also I'm always wondering why people do these optimizations
only now when spinning storage is about to become obsolete @)
It seems a bit like the last steam engine train.

> In this patch find_get_page() is called for each page, which in turn
> calls rcu_read_lock(), for each page. We have found that amortizing

rcu_read_lock is normally a no-op (or rather just a compiler barrier)
Even on preemptive kernels it's quite cheap and always local. It doesn't
make too much sense to optimize around it.

Also it's custom to supply man page with new system calls.
Such independent documentation often flushes out a lot of semantic issues.

+SYSCALL_DEFINE4(fincore, unsigned int, fd, loff_t, start, loff_t, len,
+		unsigned char __user *, vec)

I doubt the loff_t actually work for 32bit processes on 64bit kernels
That typically needs a special compat stub that reassembles the 64bit values
from the two registers.

Also on 32bit you'll end with a 6 argument call, which can be problematic.

> +	/*
> +	 * Allocate buffer vector page.
> +	 * Optimize allocation for small values of npages because the
> +	 * __get_free_page() call doubles fincore(2) runtime when npages == 1.
> +	 */

I suspect you could afford slightly more than 64 bytes on the stack.

> +	if (npages <= sizeof(tmp_small)) {
> +		tmp = tmp_small;
> +		tmp_count = sizeof(tmp_small);
> +	} else {
> +		tmp = (void *) __get_free_page(GFP_USER);
> +		if (!tmp) {
> +			retval = -EAGAIN;
> +			goto done;
> +		}
> +		tmp_count = PAGE_SIZE;

tmp_* are impressively bad variable names.

> +	}
> +
> +	while (pgoff < pgend) {
> +		/*
> +		 * Do at most tmp_count entries per iteration, due to
> +		 * the temporary buffer size.
> +		 */
> +		for (i = 0; pgoff < pgend && i < tmp_count; pgoff++, i++)
> +			tmp[i] = fincore_page(filp->f_mapping, pgoff);

If you really care about speed you could probably do it much faster
with a radix gang lookup for a larger range. And of course 
the get/put is not really needed, although avoiding that might
add too many special cases.

This loop needs a need_resched() somewhere, otherwise
someone could cause very large latencies in the kernel.

But even if you added that:

e.g. if I create a 1TB file and run it over the full range,
will I get a process that cannot be Ctrl-C'ed for a long time?

Perhaps some signal handling is needed too?

Still also would be undebuggable in that time. It might 
be best to simply limit it to some reasonable upper limit.
Most system calls do that in some form.

> +
> +		if (copy_to_user(vec, tmp, i)) {

When you used access_ok() earlier you could use __copy_to_user,
but since that's only a few instructions I would rather drop
the unnecessary access_ok() earlier.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
