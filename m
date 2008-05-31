Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYFAOqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYFAOqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYFAOpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4288 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbYFAOpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:45:05 -0400
Date: Sat, 31 May 2008 10:04:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080531080427.GH5405@ucw.cz>
References: <1211852026.3286.36.camel@pasglop> <20080526.184047.88207142.davem@davemloft.net> <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaprr721c6.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > Though it's my understanding that at least ia64 does require the
>  > explicit barriers anyway, so we are still in a dodgy situation here
>  > where it's not clear what drivers should do and we end up with
>  > possibly excessive barriers on powerpc where I end up with both
>  > the wmb/rmb/mb that were added for ia64 -and- the ones I have in
>  > readl/writel to make them look synchronous... Not nice.
> 
> ia64 is a disaster with a slightly different ordering problem -- the
> mmiowb() issue.  I know Ben knows far too much about this, but for big
> SGI boxes, you sometimes need mmiowb() to avoid problems with driver
> code that does totally sane stuff like
> 
> 	spin_lock(&mmio_lock);
> 	writel(val1, reg1);
> 	writel(val2, reg2);
> 	spin_unlock(&mmio_lock);
> 
> If that snippet is called on two CPUs at the same time, then the device
> might see a sequence like
> 
> 	CPU1 -- write reg1
> 	CPU2 -- write reg1
> 	CPU1 -- write reg2
> 	CPU2 -- write reg2
> 
> in spite of the fact that everything is totally ordered on the CPUs by
> the spin lock.
> 
> The reason this is such a disaster is because the code looks right,
> makes sense, and works fine on 99.99% of all systems out there.  So I
> would bet that 99% of our drivers have missing mmiowb() "bugs" -- no one
> has plugged the hardware into an Altix box and cared enough to stress
> test it.

Yes, ia64 is a disaster, and needs its spinlock implementation fixed
:-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
