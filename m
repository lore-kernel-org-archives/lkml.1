Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYE0CQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYE0CQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 22:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYE0CQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 22:16:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:46520 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbYE0CQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 22:16:17 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tpiepho@freescale.com
In-Reply-To: <20080526.184047.88207142.davem@davemloft.net>
References: <1211516683.8297.271.camel@pasglop>
	 <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
	 <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 27 May 2008 12:15:40 +1000
Message-Id: <1211854540.3286.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-26 at 18:40 -0700, David Miller wrote:
> 
> > Quick summary: gcc is happily re-ordering readl/writel vs. surrounding
> > memory accesses (and thus accesses to DMA coherent memory) which is
> > obviously a _BAD_THING_.
> > 
> > This is on all archs. Quick fix is to stick a "memory" clobber in all arch
> > implementations of readl/writel/... (ie, making them a barrier()).
> > 
> > However, I'm using that as an excuse to bring back my pet subject, which
> > is basically, should we instead just finally mandate the use of explicit
> > rmb/wmb/mb's (which boils down to barrier() on x86) to drivers who want
> > to order memory consistent accesses vs. MMIO ?
> 
> This is basically what drivers are effectively doing.

Some of them. USB comes to mind. I'd be happy to make it "the rule" and
document that MMIO vs. coherent access aren't implicitely ordered. I
would still keep them ordered on powerpc for a little while tho until
I'm happy enough with driver auditing.

But heh, it's you who was telling me that it would be a bad engineering
decision and we had to make everybody look like x86 & fully ordered :-)
I decided to agree back then and stuck all those nasty heavy barriers
in the powerpc variants of readl/writel/...

Now, however, that x86 -is- also affected by the problem to some extent
(ie. compiler re-ordering, not CPU but similar), this  is why I'm asking
what's people opinion is.

I'm happy to do patches updating memory-barriers.txt and others, and
do some driver auditing (though I won't do all of them), if the general
opinion is that it's the right direction to go.

If not, then shouldn't we remove the existing spurrious wmb/rmb/mb from
drivers and slap a "memory" clobber on all archs readl/writel/... ?

Cheers,
Ben.


