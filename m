Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYFBVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYFBVCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYFBVCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:02:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53737 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877AbYFBVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:02:20 -0400
Date: Mon, 2 Jun 2008 14:02:13 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: Jes Sorensen <jes@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>, benh@kernel.crashing.org,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080602210213.GA116363@sgi.com>
References: <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop> <adaiqwzsa83.fsf@cisco.com> <yq0iqwxrwuh.fsf@jaguar.mkp.net> <20080531075242.GC108600@sgi.com> <4843C3D7.7000609@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4843C3D7.7000609@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 11:56:39AM +0200, Jes Sorensen wrote:
> Jeremy Higdon wrote:
> >We don't actually have that problem on the Altix.  All writes issued
> >by CPU X will be ordered with respect to each other.  But writes by
> >CPU X and CPU Y will not be, unless an mmiowb() is done by the
> >original CPU before the second CPU writes.  I.e.
> >
> >	CPU X	writel
> >	CPU X	writel
> >	CPU X	mmiowb
> >
> >	CPU Y	writel
> >	...
> >
> >Note that this implies some sort of locking.  Also note that if in
> >the above, CPU Y did the mmiowb, that would not work.
> 
> Hmmm,
> 
> Then it's less bad than I thought - my apologies for the confusion.
> 
> Would we be able to use Ben's trick of setting a per cpu flag in
> writel() then and checking that in spin unlock issuing the mmiowb()
> there if needed?


Yes, that should work fine.  You will get more mmiowb's than you
need, since some drivers, such as Fusion, don't need them.  On the
Origins (older SGI MIPS-based Numa), the 'sync' instruction had
the same effect as mmiowb() with respect to mmio write ordering,
and it was issued unconditionally in the spin unlock.  It was
cheaper than mmiowb, however.

If it matters, we could invent and use writel_relaxed() to get
performance back in drivers we care about....

jeremy
