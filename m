Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbYE0WP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbYE0WP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbYE0WPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:15:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:57271 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbYE0WPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:15:12 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <adaiqwzsa83.fsf@cisco.com>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop>
	 <adaiqwzsa83.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 08:13:30 +1000
Message-Id: <1211926410.3286.95.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 14:33 -0700, Roland Dreier wrote:
> > This is a different issue. We deal with it on powerpc by having writel
>  > set a per-cpu flag and spin_unlock() test it, and do the barrier if
>  > needed there.
> 
> Cool... I assume you do this for mutex_unlock() etc?

That's a good point... I don't think we do. Maybe we should.

> Is there any reason why ia64 can't do this too so we can kill mmiowb and
> save everyone a lot of hassle?  (mips, sh and frv have non-empty
> mmiowb() definitions too but I'd guess that these are all bugs based on
> misunderstandings of the mmiowb() semantics...)

Well, basically our approach was that mmiowb() is a pain in the neck,
nobody (ie. driver writers) really understands what it's for, and so
it's either not there or misused. So we didn't want to introduce it for
powerpc, but instead did the trick above in order to -slightly- improve
our writel (ie avoid a sync -after- the write) .

>  > However, drivers such as e1000 -also- have a wmb() between filling the
>  > ring buffer and kicking the DMA with MMIO, with a comment about this
>  > being needed for ia64 relaxed ordering.
> 
> I put these barriers into mthca, mlx4 etc, although it came from my
> possible misunderstanding of the memory ordering rules in the kernel
> more than any experience of problems (as opposed the the mmiowb()s,
> which all came from real world bugs).

Ben.


