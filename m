Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbZDBIuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbZDBIuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZDBIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:50:04 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:20865 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZDBIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:50:01 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <18894.49084.341238.775487@cargo.ozlabs.ibm.com>
References: <20090328194359.426029037@chello.nl>
	 <20090328194929.546464621@chello.nl>
	 <18894.49084.341238.775487@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 10:50:38 +0200
Message-Id: <1238662238.8530.5622.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 11:24 +1100, Paul Mackerras wrote:

> > --- linux-2.6.orig/include/linux/perf_counter.h
> > +++ linux-2.6/include/linux/perf_counter.h
> > @@ -160,10 +160,45 @@ struct perf_counter_hw_event {
> >  struct perf_counter_mmap_page {
> >  	__u32	version;		/* version number of this structure */
> >  	__u32	compat_version;		/* lowest version this is compat with */
> > +
> > +	/*
> > +	 * Bits needed to read the hw counters in user-space.
> > +	 *
> > +	 * The index and offset should be read atomically using the seqlock:
> > +	 *
> > +	 *   __u32 seq, index;
> > +	 *   __s64 offset;
> > +	 *
> > +	 * again:
> > +	 *   rmb();
> > +	 *   seq = pc->lock;
> > +	 *
> > +	 *   if (unlikely(seq & 1)) {
> > +	 *     cpu_relax();
> > +	 *     goto again;
> > +	 *   }
> > +	 *
> > +	 *   index = pc->index;
> > +	 *   offset = pc->offset;
> > +	 *
> > +	 *   rmb();
> > +	 *   if (pc->lock != seq)
> > +	 *     goto again;
> > +	 *
> > +	 * After this, index contains architecture specific counter index + 1,
> > +	 * so that 0 means unavailable, offset contains the value to be added
> > +	 * to the result of the raw timer read to obtain this counter's value.
> > +	 */
> >  	__u32	lock;			/* seqlock for synchronization */
> >  	__u32	index;			/* hardware counter identifier */
> >  	__s64	offset;			/* add to hardware counter value */
> 
> I think we can simplify this (in a follow-on patch).
> 
> It has occurred to me that we don't need to do all this on the
> userspace side, because we are necessarily reading and writing these
> fields on the same CPU.  If the reader and writer were on different
> CPUs, that would make no sense since they would be accessing different
> hardware counter registers.
> 
> That means that we don't need any CPU memory barriers on either side.
> All the kernel needs to do is to increment `lock' when it updates
> things, and the user side can be:
> 
> 	do {
> 		seq = pc->lock;
> 		index = pc->index;
> 		offset = pc->offset;
> 		barrier();
> 	} while (pc->lock != seq);
> 
> and all that's needed is a compiler barrier to stop the compiler from
> optimizing too much.

Can this work at all?

I mean, user-space could get preempted/rescheduled after we read the
mmap() data using that seqlock and before we actually did the read-pmc
bit.

In that case, the counter can have changed underneath us and we're
reading rubbish.

