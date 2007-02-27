Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXB0Upl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXB0Upl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXB0Upl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:45:41 -0500
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:54424 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXB0Upk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:45:40 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and asm-generic/semaphore.h
Date: Tue, 27 Feb 2007 21:45:26 +0100
User-Agent: KMail/1.9.6
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070227001338.344233745@sodium.jf.intel.com> <20070227021803.38c8591f@lxorguk.ukuu.org.uk> <200702261757.11968.inaky@linux.intel.com>
In-Reply-To: <200702261757.11968.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702272145.28803.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inaky,

On Tuesday, 27. February 2007, Inaky Perez-Gonzalez wrote:
> On Monday 26 February 2007 18:18, Alan wrote:
> > > Yeah, I need semaphore. This is a hw register that says when the hw
> > > is ready to accept a new command. Code that wants to send commands has
> > > to down the semaphore and then send it. When hw is ready to get a new
> > > command, it sends and IRQ and the IRQ up()s the semaphore.
> >
> > So you need a mutex not a semaphore
> 
> Theoretically I could use a mutex. Practically it would trigger ugly
> complications. Only the owner can unlock a mutex (for example), so
> I could not unlock from an IRQ handler -- not to mention that the
> semantic rules outlined in Documentation/mutex-design.txt explicitly
> forbid IRQ usage. 
> 
> And then, this is what semaphores where designed for, as gates :)
> for once that I get to use a semaphore properly...

But they are not required for that :-)

I would suggest to use an irq-safe spinlock for the hardware access
and a status indicator (ready for command), if this is really just a command register. 
If the status indicator is updated (in IRQ) and read under spinlock, that is safe.

If that command sending is speed critical, please try a FIFO and batch that stuff.

Timeout based locking mechanisms are flawed, because they introduce the hard to find
timing sensitive bugs.

Please try sth. different (e.g. like suggested above).

Semaphores aren't good "busy/ready flags", as you might have already noticed.

Many Thanks and Best Regards

Ingo Oeser, the down{_interruptible,}_timeout() implementation of Linux :-)
