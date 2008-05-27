Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbYE0Puo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbYE0Puo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbYE0PuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:50:22 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:27867 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbYE0PuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:50:20 -0400
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="36258904"
From: Roland Dreier <rdreier@cisco.com>
To: benh@kernel.crashing.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
	<1211872130.3286.64.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 27 May 2008 08:50:17 -0700
In-Reply-To: <1211872130.3286.64.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Tue, 27 May 2008 17:08:50 +1000")
Message-ID: <adaprr721c6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2008 15:50:17.0730 (UTC) FILETIME=[5C672620:01C8C011]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Though it's my understanding that at least ia64 does require the
 > explicit barriers anyway, so we are still in a dodgy situation here
 > where it's not clear what drivers should do and we end up with
 > possibly excessive barriers on powerpc where I end up with both
 > the wmb/rmb/mb that were added for ia64 -and- the ones I have in
 > readl/writel to make them look synchronous... Not nice.

ia64 is a disaster with a slightly different ordering problem -- the
mmiowb() issue.  I know Ben knows far too much about this, but for big
SGI boxes, you sometimes need mmiowb() to avoid problems with driver
code that does totally sane stuff like

	spin_lock(&mmio_lock);
	writel(val1, reg1);
	writel(val2, reg2);
	spin_unlock(&mmio_lock);

If that snippet is called on two CPUs at the same time, then the device
might see a sequence like

	CPU1 -- write reg1
	CPU2 -- write reg1
	CPU1 -- write reg2
	CPU2 -- write reg2

in spite of the fact that everything is totally ordered on the CPUs by
the spin lock.

The reason this is such a disaster is because the code looks right,
makes sense, and works fine on 99.99% of all systems out there.  So I
would bet that 99% of our drivers have missing mmiowb() "bugs" -- no one
has plugged the hardware into an Altix box and cared enough to stress
test it.

However for the issue at hand, my expectation as a driver writer is that
readl()/writel() are ordered with respect to MMIO operations, but not
necessarily with respect to normal writes to coherent CPU memory.  And
I've included explicit wmb()s in code I've written like
drivers/infiniband/hw/mthca.

 - R.
