Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZFOJw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZFOJw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFOJwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:52:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:40763 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZFOJwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:52:49 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <20090615094148.GC1314@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 19:51:16 +1000
Message-Id: <1245059476.12400.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 11:41 +0200, Nick Piggin wrote:
> 
> > Btw, you should not need to use GFP_NOWAIT anymore and GFP_KERNEL
> > should be fine even during early boot.
> 
> Is this the agreed way forward? 

Yes.

> I would like to maybe continue to
> try having early allocations pass in special flags where possible
> (it could even be a GFP_BOOT or something). It can make it easier
> to perhaps reduce branches in core code in future and things can
> be flagged in warnings....

The whole point of the exercise in removing the need for alloc_bootmem
in a whole bunch of code is defeated if you now also want specific flags
passed. I think we can cope reasonably easily.

> I just like the idea of keeping such annotations.

I think the boot order is too likely to change to make it a sane thing
to have all call sites "know" at what point they are in the boot
process. In your example, what does GFP_BOOT would mean ? Before
scheduler is initialized ? before interrupts are on ?

There's just too much stuff involved and we don't want random
allocations in various subsystem or arch code to be done with that
special knowledge of where specifically in that process they are done.
Especially since it may change.

Additionally, I believe the flag test/masking can be moved easily enough
out of the fast path... slub shouldn't need it there afaik and if it's
pushed down into the allocation of new slab's then it shouldn't be a big
deal.

Cheers,
Ben.


