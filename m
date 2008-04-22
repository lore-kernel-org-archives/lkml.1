Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbYDVKqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbYDVKqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbYDVKqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:46:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:42789 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbYDVKqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:46:32 -0400
Subject: Re: [PATCH 05/15] drivers/char: minor irq handler cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Jeff Garzik <jeff@garzik.org>, alan@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080422101326.GD23482@bitwizard.nl>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
	 <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
	 <20080419060011.GA29321@bitwizard.nl> <1208851540.9640.95.camel@pasglop>
	 <20080422101326.GD23482@bitwizard.nl>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 20:46:08 +1000
Message-Id: <1208861168.9640.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 12:13 +0200, Rogier Wolff wrote:
> > You should let the kernel generic code deal with the runaway
> interrupt,
> > it should be capable of doing so nowadays pretty reliably.
> > 
> > free_irq() is definitely not going to be happy when it start messing
> > with /proc from an interrupt... It will at least give you a WARN_ON.
> 
> The situation is NOT normal operation. It is an emergency measure in
> an attempt to prevent a full hang. It is great that other parts of the
> kernel also "shout" that something is wrong.

But free_irq at interrupt time has great chances of crashing the machine
or currupting data structures in subtle ways. You should -not- do that.

Either let the kernel handle the runaway interrupt, or eventually if you
want to be brutal, call disable_irq_nosync yourself, but not free_irq.

> Consider it similar to a "kernel null pointer dereference". Once that
> happens, all bets are off. In practise you've probably seen one, and
> you were able to continue to work. It is advisable to save everything
> you can, and reboot. This is similar. 

It would be if you used something like disable_irq_nosync. Not free_irq.
The later is just bogus.

> The "generic code for runaway interrupts" didn't exist when this was
> written. If it exists, and works for the case that this was written
> for, then all is fine, and we can remove my code. As you can see, I
> copied over the code from one driver to the next after I got bitten
> again with the second driver. So having something generic is of course
> preferable. :-)

Well, if you know how to trigger the bug, it would be useful to verify
that the kernel generic code properly detects and masks the runaway
interrupt. If that works, then remove your code completely. If not, it
would be useful to figure out why :-) But either way, just replace it
with disable_irq_nosync.

Cheers,
Ben.


