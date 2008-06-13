Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbYFMAIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbYFMAIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYFMAId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:08:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:44381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454AbYFMAIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:08:32 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jes Sorensen <jes@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Jeremy Higdon <jeremy@sgi.com>,
       Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080612150716.GX30405@parisc-linux.org>
References: <1211852026.3286.36.camel@pasglop> <4843C3D7.7000609@sgi.com>
	 <200806031433.12460.nickpiggin@yahoo.com.au>
	 <200806030952.10360.jbarnes@virtuousgeek.org> <4847A690.302@sgi.com>
	 <1212655433.9496.109.camel@pasglop>
	 <20080612150716.GX30405@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 10:07:04 +1000
Message-Id: <1213315624.14478.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 09:07 -0600, Matthew Wilcox wrote:
> On Thu, Jun 05, 2008 at 06:43:53PM +1000, Benjamin Herrenschmidt wrote:
> > Note that the powerpc implementation currently clears the flag
> > on spin_lock and tests it on unlock. We are considering changing
> > that to not touch the flag on spin_lock and just clear it whenever
> > we do a sync (ie, on unlock, on explicit mmiowb, and possibly even
> > on readl's where we happen to do sync's).
> 
> Your current scheme sounds like it's broken for
> 
> spin_lock(a)
> writel();
> spin_lock(b);
> spin_unlock(b);
> spin_unlock(a);

Which is why we are considering changing it :-)

But as Paulus said before, he did some measurement and we came to the
conclusion that (pending more measurements on a wider range of HW) we
may as well drop the whole scheme and make writel fully synchronous
instead.

Then, we can get some nice weakly ordered accessors and start adding
them with appropriate explicit barriers to the hot path of perf.
critical drivers we care about.

Cheers,
Ben.



