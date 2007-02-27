Return-Path: <linux-kernel-owner+w=401wt.eu-S1750808AbXB0UZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808AbXB0UZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXB0UZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:25:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50359 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXB0UZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:25:10 -0500
Date: Tue, 27 Feb 2007 12:24:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: hch@infradead.org, arjan@infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and
 asm-generic/semaphore.h
Message-Id: <20070227122446.8c64f3e7.akpm@linux-foundation.org>
In-Reply-To: <200702261654.18005.inaky@linux.intel.com>
References: <20070227001338.344233745@sodium.jf.intel.com>
	<20070227003313.GA7360@infradead.org>
	<200702261654.18005.inaky@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 26 Feb 2007 16:54:17 -0800 Inaky Perez-Gonzalez <inaky@linux.intel.com> wrote:
> On Monday 26 February 2007 16:33, Christoph Hellwig wrote:
> > On Mon, Feb 26, 2007 at 04:13:38PM -0800, inaky@linux.intel.com wrote:
> > > Introduce down_interruptible_timeout() using timers to make the waiter
> > > stop waiting by simulating a signal (see first patch for more
> > > details). As well introduce asm-generic/semaphore.h and make other
> > > architectures use it too.
> >
> > What do you want this for?  Do you really need a full counting semaphore
> > or do you actually want a mutex?
> 
> Yeah, I need semaphore. This is a hw register that says when the hw
> is ready to accept a new command. Code that wants to send commands has
> to down the semaphore and then send it. When hw is ready to get a new
> command, it sends and IRQ and the IRQ up()s the semaphore. 
> 
> Now, we don't want to hang on that down() forever if the hw spaces out.
> If we get a timeout, we can try recovery actions (like resetting it,
> for sake of being polite). 
>

This is a very common pattern - for example, shoving characters down a uart
or a parport.  Nobody else has needed to invent new locking infrastructure
to do such things and I'd prefer not to do so now.

Can you not do things more conventionally within that driver?  Use
waitqueues for sleeping with timeout, use a spinlock for serialisation
against the device registers.  There are squillions of examples in
drivers/*, surely.
