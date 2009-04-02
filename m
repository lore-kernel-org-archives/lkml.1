Return-Path: <linux-kernel-owner+w=401wt.eu-S935120AbZDBJWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935120AbZDBJWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZDBJV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:21:56 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55508 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZDBJVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:21:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18900.33346.375497.2714@cargo.ozlabs.ibm.com>
Date: Thu, 2 Apr 2009 20:15:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
In-Reply-To: <1238662238.8530.5622.camel@twins>
References: <20090328194359.426029037@chello.nl>
	<20090328194929.546464621@chello.nl>
	<18894.49084.341238.775487@cargo.ozlabs.ibm.com>
	<1238662238.8530.5622.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> > That means that we don't need any CPU memory barriers on either side.
> > All the kernel needs to do is to increment `lock' when it updates
> > things, and the user side can be:
> > 
> > 	do {
> > 		seq = pc->lock;
> > 		index = pc->index;
> > 		offset = pc->offset;
> > 		barrier();
> > 	} while (pc->lock != seq);
> > 
> > and all that's needed is a compiler barrier to stop the compiler from
> > optimizing too much.
> 
> Can this work at all?
> 
> I mean, user-space could get preempted/rescheduled after we read the
> mmap() data using that seqlock and before we actually did the read-pmc
> bit.
> 
> In that case, the counter can have changed underneath us and we're
> reading rubbish.

Good point.  This should work, though:

	do {
		seq = pc->lock;
		barrier();
		value = read_pmc(pc->index) + pc->offset;
		barrier();
	} while (pc->lock != seq);
	return value;

No?

Paul.
