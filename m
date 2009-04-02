Return-Path: <linux-kernel-owner+w=401wt.eu-S1766012AbZDBJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766012AbZDBJfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761566AbZDBJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:35:28 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:20702 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbZDBJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:35:27 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <18900.33346.375497.2714@cargo.ozlabs.ibm.com>
References: <20090328194359.426029037@chello.nl>
	 <20090328194929.546464621@chello.nl>
	 <18894.49084.341238.775487@cargo.ozlabs.ibm.com>
	 <1238662238.8530.5622.camel@twins>
	 <18900.33346.375497.2714@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 11:36:19 +0200
Message-Id: <1238664979.8530.5723.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:15 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > > That means that we don't need any CPU memory barriers on either side.
> > > All the kernel needs to do is to increment `lock' when it updates
> > > things, and the user side can be:
> > > 
> > > 	do {
> > > 		seq = pc->lock;
> > > 		index = pc->index;
> > > 		offset = pc->offset;
> > > 		barrier();
> > > 	} while (pc->lock != seq);
> > > 
> > > and all that's needed is a compiler barrier to stop the compiler from
> > > optimizing too much.
> > 
> > Can this work at all?
> > 
> > I mean, user-space could get preempted/rescheduled after we read the
> > mmap() data using that seqlock and before we actually did the read-pmc
> > bit.
> > 
> > In that case, the counter can have changed underneath us and we're
> > reading rubbish.
> 
> Good point.  This should work, though:
> 
> 	do {
> 		seq = pc->lock;
> 		barrier();
> 		value = read_pmc(pc->index) + pc->offset;
> 		barrier();
> 	} while (pc->lock != seq);
> 	return value;

I don't think you need the first barrier(), all you need to avoid is it
reusing the first pc->lock read, so one should suffice.

Also, you need to handle the !pc->index case.

But yeah.

