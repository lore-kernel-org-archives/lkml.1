Return-Path: <linux-kernel-owner+w=401wt.eu-S2992849AbXCCBMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992849AbXCCBMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992851AbXCCBMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:12:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:16176 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992849AbXCCBMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:12:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,244,1170662400"; 
   d="scan'208"; a="203493681:sNHT20683103"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and asm-generic/semaphore.h
Date: Fri, 2 Mar 2007 17:17:02 -0800
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070227001338.344233745@sodium.jf.intel.com> <200702261757.11968.inaky@linux.intel.com> <200702272145.28803.ioe-lkml@rameria.de>
In-Reply-To: <200702272145.28803.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703021717.03140.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007 12:45, Ingo Oeser wrote:
> Hi Inaky,
>
> On Tuesday, 27. February 2007, Inaky Perez-Gonzalez wrote:
> > On Monday 26 February 2007 18:18, Alan wrote:
> > > > Yeah, I need semaphore. This is a hw register that says when the hw
> > > > is ready to accept a new command. Code that wants to send commands
> > > > has to down the semaphore and then send it. When hw is ready to get a
> > > > new command, it sends and IRQ and the IRQ up()s the semaphore.
> > >
> > > So you need a mutex not a semaphore
> >
> > Theoretically I could use a mutex. Practically it would trigger ugly
> > complications. Only the owner can unlock a mutex (for example), so
> > I could not unlock from an IRQ handler -- not to mention that the
> > semantic rules outlined in Documentation/mutex-design.txt explicitly
> > forbid IRQ usage.
> >
> > And then, this is what semaphores where designed for, as gates :)
> > for once that I get to use a semaphore properly...
>
> But they are not required for that :-)
>
> I would suggest to use an irq-safe spinlock for the hardware access
> and a status indicator (ready for command), if this is really just a
> command register. If the status indicator is updated (in IRQ) and read
> under spinlock, that is safe.

I have that already. The registers are shared for the two flows of
information, sending commands to the device and receiving notifications
from them, so any access to the registers is protected by a IRQ spinlock.

Now, it would be kind of pointless to do a busy poll for the command-ready
indicator if I have an IRQ that notifies me of it, ergo there the need
for a semaphore. I could use a waitqueue, as akpm suggested, but I still
need something else that says 'its only me who has the command sending
privilege now', and I'd still need to push a timeout something to detect
broken hw.

So: 
1 - to send a command I need to wait for !register.execute_command
2 - to access 'register', I need to have an spinlock
3 - when register.executing_command drops to zero, I get an IRQ
4 - other code flows access register

If I didn't have to wait for register.execute_command(), we have the usual
construct:

execute_command(hw) {
  ...
  spin_lock_irqsave(hw->lock, flags);
  prep_command_buffer;
  writel(execute_command, register)
  spin_unlock_irqrestore(hw->lock, flags);
  ...
}

checking for 'register.execute_command == 0' inside the spinlock protected
area, bailing out if busy and waiting for a while before retrying is another
(fugly) option that I am not willing to implement. 

Another option is using a wait_event() mechanism that is woken up from the 
IRQ that says register.execute_command is zero, but that's basically 
a semaphore.

A FIFO or queue is the most complex of the mechanisms, because now I have 
to create all this support infrastructure to store the queued commands.

A semaphore simplifies everything -- I guess I have brain corruption, because
I can't understand your objections.

execute_command(hw) {
  ...
  down(hw->cmd_semaphore);
  /* now it's only this thread who can send a command */
  spin_lock_irqsave(hw->lock, flags);
  prep_command_buffer;
  writel(execute_command, register)
  spin_unlock_irqrestore(hw->lock, flags);
  ...
}

irq_handler(hw) {
  ...
  spin_lock_irqsave(hw->lock, flags);
  if (readl(irq_register & execute_command_cleared))
	up(hw->cmd_sem);
  ...
  // touch command register here for other stuff
  ...
  spin_unlock_irqrestore(hw->lock, flags);
  ...
}

It's not a mutex or spinlock, is a gating or sequencing mechanism that
allows just one guy at a time.

> Timeout based locking mechanisms are flawed, because they introduce the
> hard to find timing sensitive bugs.

The only reason why the timeout is added is to detect when the hw is dead
so we can recover. This shouldn't create timing bugs because if it times
out [in this case], the hw is broken and we are going to reset it.

> Semaphores aren't good "busy/ready flags", as you might have already
> noticed.

That's why I am not using them as a flag.

-- Inaky
