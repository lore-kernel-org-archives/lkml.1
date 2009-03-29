Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZC2AZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZC2AZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZC2AZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:25:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49868 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZC2AZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:25:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18894.49084.341238.775487@cargo.ozlabs.ibm.com>
Date: Sun, 29 Mar 2009 11:24:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
In-Reply-To: <20090328194929.546464621@chello.nl>
References: <20090328194359.426029037@chello.nl>
	<20090328194929.546464621@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> It just occured to me it is possible to have multiple contending
> updates of the userpage (mmap information vs overflow vs counter).
> This would break the seqlock logic.
> 
> It appear the arch code uses this from NMI context, so we cannot
> possibly serialize its use, therefore separate the data_head update
> from it and let it return to its original use.

That sounds reasonable, and thanks for putting in a big comment.

Acked-by: Paul Mackerras <paulus@samba.org>

> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -160,10 +160,45 @@ struct perf_counter_hw_event {
>  struct perf_counter_mmap_page {
>  	__u32	version;		/* version number of this structure */
>  	__u32	compat_version;		/* lowest version this is compat with */
> +
> +	/*
> +	 * Bits needed to read the hw counters in user-space.
> +	 *
> +	 * The index and offset should be read atomically using the seqlock:
> +	 *
> +	 *   __u32 seq, index;
> +	 *   __s64 offset;
> +	 *
> +	 * again:
> +	 *   rmb();
> +	 *   seq = pc->lock;
> +	 *
> +	 *   if (unlikely(seq & 1)) {
> +	 *     cpu_relax();
> +	 *     goto again;
> +	 *   }
> +	 *
> +	 *   index = pc->index;
> +	 *   offset = pc->offset;
> +	 *
> +	 *   rmb();
> +	 *   if (pc->lock != seq)
> +	 *     goto again;
> +	 *
> +	 * After this, index contains architecture specific counter index + 1,
> +	 * so that 0 means unavailable, offset contains the value to be added
> +	 * to the result of the raw timer read to obtain this counter's value.
> +	 */
>  	__u32	lock;			/* seqlock for synchronization */
>  	__u32	index;			/* hardware counter identifier */
>  	__s64	offset;			/* add to hardware counter value */

I think we can simplify this (in a follow-on patch).

It has occurred to me that we don't need to do all this on the
userspace side, because we are necessarily reading and writing these
fields on the same CPU.  If the reader and writer were on different
CPUs, that would make no sense since they would be accessing different
hardware counter registers.

That means that we don't need any CPU memory barriers on either side.
All the kernel needs to do is to increment `lock' when it updates
things, and the user side can be:

	do {
		seq = pc->lock;
		index = pc->index;
		offset = pc->offset;
		barrier();
	} while (pc->lock != seq);

and all that's needed is a compiler barrier to stop the compiler from
optimizing too much.

Paul.
