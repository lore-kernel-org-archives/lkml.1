Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902Ab0A2KOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0A2KOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081Ab0A2KOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:14:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0A2KOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:14:08 -0500
Subject: Re: [PATCHv3 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joel Schopp <jschopp@austin.ibm.com>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264728185.20211.34.camel@pasglop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
	 <1264728185.20211.34.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 11:13:47 +0100
Message-ID: <1264760027.4283.2164.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 12:23 +1100, Benjamin Herrenschmidt wrote:
> On machine that don't have SMT, I would like to avoid calling
> arch_scale_smt_power() at all if possible (in addition to not compiling
> it in if SMT is not enabled in .config).
> 
> Now, I must say I'm utterly confused by how the domains are setup and I
> haven't quite managed to sort it out... it looks to me that
> SD_SHARE_CPUPOWER is always going to be set on all CPUs when the config
> option is set (though each CPU will have its own domain) or am I
> misguided ? IE. Is there any sense in having at least a fast exit path
> out of arch_scale_smt_power() for non-SMT CPUs ?

The sched_domain creation code is a f'ing stink pile that hurts
everybody's brain.

The AMD magny-cours people sort of cleaned it up a bit but didn't go
nearly far enough. Doing so is somewhere on my todo list, but sadly that
thing is way larger than my spare time.

Now SD_SHARE_CPUPOWER _should_ only be set for SMT domains, because only
SMT siblings share cpupower.

SD_SHARE_PKG_RESOURCES _should_ be set for both SMT and MC, because they
all share the same cache domain.

If it all works out that way in practice on powerpc is another question
entirely ;-)

That said, I'm still not entirely convinced I like this usage of
cpupower, its supposed to be a normalization scale for load-balancing,
not a placement hook.

I'd be much happier with a SD_GROUP_ORDER or something like that, that
works together with SD_PREFER_SIBLING to pack active tasks to cpus in
ascending group order.

