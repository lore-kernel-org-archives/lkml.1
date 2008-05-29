Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYE2VlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYE2VlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYE2VlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:41:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:33591 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYE2VlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:41:09 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jes Sorensen <jes@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <yq0iqwxrwuh.fsf@jaguar.mkp.net>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop>
	 <adaiqwzsa83.fsf@cisco.com>  <yq0iqwxrwuh.fsf@jaguar.mkp.net>
Content-Type: text/plain
Date: Fri, 30 May 2008 07:40:23 +1000
Message-Id: <1212097223.8888.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 10:47 -0400, Jes Sorensen wrote:
> 
> The only way to guarantee ordering in the above setup, is to either
> make writel() fully ordered or adding the mmiowb()'s inbetween the two
> writel's. On Altix you have to go and read from the PCI brige to
> ensure all writes to it have been flushed, which is also what mmiowb()
> is doing. If writel() was to guarantee this ordering, it would make
> every writel() call extremely expensive :-(

Interesting. I've always been taught by ia64 people that mmiowb() was
intended to be used solely between writel() and spin_unlock().

I think in the above case, you really should make writel() ordered.
Anything else is asking for trouble, for the exact same reasons that I
made it fully ordered on powerpc at least vs. previous stores. I only
kept it relaxed vs. subsequent cacheable stores (ie, spin_unlock), for
which I use the trick mentioned before.

Yes, this has some cost (can be fairly significant on powerpc too) but
I think it's a very basic assumption from drivers that consecutive
writel's, especially issued by the same CPU, will get to the device
in order.

If this is a performance problem, then provide relaxed variants and
use them in selected drivers.

Cheers,
Ben.


