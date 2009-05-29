Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZE2IZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZE2IZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZE2IZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:25:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47886 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZE2IZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:25:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18975.39916.877132.690506@cargo.ozlabs.ibm.com>
Date: Fri, 29 May 2009 18:25:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
 locked mutex
In-Reply-To: <1243584388.23657.156.camel@twins>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
	<1243584388.23657.156.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> > -		&& ctx1->parent_gen == ctx2->parent_gen;
> > +		&& ctx1->parent_gen == ctx2->parent_gen
> > +		&& ctx1->parent_gen != ~0ull;
> >  }
> 
> There's a nasty surprise for people a few generations down the line. All
> of a sudden performance drops for a while for some unknown reason, and
> then its good again,.. how odd ;-)

If you can add a counter every microsecond (which I don't think any
current processor can do) it'll still be more than half a million
years before we get that far...

> But yeah, seems fine, given that the alternative is yet another
> variable.

Actually, having a 1-bit flag might be cleaner since we can then just
clear it, rather than having to put the old parent_gen back.

> <snip all the other WARN_ON_ONCEs>
> 
> How about:
> 
> #define ASSERT_CTX_STABLE(ctx) \
>   WARN_ON_ONCE((ctx)->parent_gen != ~0ull || ctx->parent_ctx)
> 
> which would deal with both a 'locked' context and uncloned one?

Yeah, all right.

> Could we maybe write this as:
> 
> static struct perf_counter_ctx *pin_ctx(struct perf_counter *counter, u64 *old_gen)

Yep, good idea.

Paul.
