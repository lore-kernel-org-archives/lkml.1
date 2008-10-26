Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYJZGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYJZGeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 02:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYJZGeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 02:34:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:40144 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYJZGeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 02:34:11 -0400
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: galak@kernel.crashing.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, torvalds@osdl.org, maxk@qualcomm.com,
       tglx@linutronix.de
In-Reply-To: <20081025.210412.206011121.davem@davemloft.net>
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
	 <20081024.161813.193686281.davem@davemloft.net>
	 <1224970389.7654.473.camel@pasglop>
	 <20081025.210412.206011121.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 26 Oct 2008 17:33:35 +1100
Message-Id: <1225002815.7654.487.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 21:04 -0700, David Miller wrote:
> But back to my original wonder, since I've always tipped off of this
> generic IRQ layer cpu mask, when was it ever defaulting to zero
> and causing the behvaior your powerpc guys actually want? :-)

Well, I'm not sure what Kumar wants. Most powerpc SMP setups actually
want to spread interrupts to all CPUs, and those who can't tend to just
not implement set_affinity... So Kumar must have a special case of MPIC
usage here on FSL platforms.

In any case, the platform limitations should be dealt with there or the
user could break it by manipulating affinity via /proc anyway.

By yeah, I do expect default affinity to be all CPUs and in fact, I even
have an -OLD- comment in the code that says

 	/* let the mpic know we want intrs. default affinitya is 0xffffffff ...

Now, I've tried to track that down but it's hard because the generic code
seem to have changed in many ways around affinity handling...

So it looks like nowadays, the generic setup_irq() will call
irq_select_affinity() when an interrupt is first requested. Unless
you set CONFIG_AUTO_IRQ_AFFINITY and implement your own
irq_select_affinity(), thus, you will get the default one which copies
the content of this global irq_default_affinity to the interrupt.

However it does that _after_ your IRQ startup() has been called
(yes, this is very fishy), and so after you did your irq_choose_cpu()...

This is all very messy, along with hooks for balancing and other confusing
stuff that I suspect keeps changing. I'll have to spend more time next
week to sort out what exactly is happening on powerpc and whether we
get our interrupts spread or not...

That's the downside of having more generic irq code I suppose: now people
keep rewriting half of the generic code with x86 exclusively in mind and
we have to be extra careful :-)

Cheers,
Ben.


