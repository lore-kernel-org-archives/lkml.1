Return-Path: <linux-kernel-owner+w=401wt.eu-S935327AbZDBJ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935327AbZDBJ73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbZDBJ7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:59:16 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54636 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZDBJ7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:59:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18900.35934.799877.893556@cargo.ozlabs.ibm.com>
Date: Thu, 2 Apr 2009 20:58:54 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
In-Reply-To: <1238664979.8530.5723.camel@twins>
References: <20090328194359.426029037@chello.nl>
	<20090328194929.546464621@chello.nl>
	<18894.49084.341238.775487@cargo.ozlabs.ibm.com>
	<1238662238.8530.5622.camel@twins>
	<18900.33346.375497.2714@cargo.ozlabs.ibm.com>
	<1238664979.8530.5723.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> > Good point.  This should work, though:
> > 
> > 	do {
> > 		seq = pc->lock;
> > 		barrier();
> > 		value = read_pmc(pc->index) + pc->offset;
> > 		barrier();
> > 	} while (pc->lock != seq);
> > 	return value;
> 
> I don't think you need the first barrier(), all you need to avoid is it
> reusing the first pc->lock read, so one should suffice.

I need it to make sure that the compiler doesn't put the load of
pc->index or pc->offset before the first load of pc->lock.  The second
barrier is needed to make sure the compiler puts the second load of
pc->lock after the loads of pc->index and pc->offset.  So I think I do
need to barrier()s (but only compiler barriers, not cpu memory
barriers).

> Also, you need to handle the !pc->index case.

Hmmm, yeah.  I claim that read_pmc(0) always returns 0. :)

Paul.
