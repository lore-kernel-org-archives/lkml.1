Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbYGCMqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbYGCMqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbYGCMqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:46:34 -0400
Received: from www.tglx.de ([62.245.132.106]:40278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760623AbYGCMqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:46:32 -0400
Date: Thu, 3 Jul 2008 14:45:05 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080703124505.GB3197@local>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080703071019.GC12214@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-König wrote:
> Hans J. Koch wrote:
> > On Wed, Jul 02, 2008 at 07:59:51PM +0900, Magnus Damm wrote:
> > > From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > >
> > > This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
> > > is responsible for acknowledging and re-enabling the interrupt.
> > 
> > This can easily be done without your patch.

BTW, the above wording "the user space driver is responsible for
acknowledging and re-enabling the interrupt" is misleading. The kernel
always has to acknowledge/disable/mask the interrupt. Userspace can only
reenable it, ideally by writing to a chip register. In some cornercases
for broken hardware we need the newly introduced write function.

> > 
> > > Shared interrupts are not supported by this mode.
> > >
> > > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > > ---
> > >
> > >  Similar code has been posted some time ago as:
> > >  "[PATCH] uio_pdrv: Unique IRQ Mode"
> > >  "[PATCH 00/03][RFC] Reusable UIO Platform Driver".
> > 
> > Yes, and in that thread I gave detailed explanations why I won't accept
> > that.
> I think for all of your concers one of the following is true:
> 
>   - they are not valid any more in this version; or

I question the whole concept as such. The concept of having a generic
irq handler using disable_irq_nosync() makes no sense at all.

Reasons:

- We do not introduce new possibilities. Everything can be done without
  that patch.

- We offer users an irq handler that shouldn't be used. It is seldom the
  best solution to call disable_irq_nosync() to disable an interrupt. In
  almost all cases you should use the irq mask register of the chip your
  driver handles. What do you want to write into the docs? Here's an irq
  handler, but please use it only if you're really desperate?

- The only argument in favor of that concept was that it saves a few
  lines of irq handler code. Given the fact that all the handler has to
  do is toggle one bit in a hardware register, this is really not much.
  And you tempt people to delete 5 lines of good code and replace them
  with a sub-optimal generic irq handler.

- You introduce the need for an irqcontrol function. This was not the
  intention of that concept. Normal UIO devices don't need a write
  function, this is only used for broken hardware. If you have normal
  hardware, and implement a proper 5 lines irq handler, userspace can simply
  reenable the irq by writing to a hardware register it has mapped
  anyway. In your concept, it has to use write() on /dev/uioX, which
  means you have to go all the way through libc, vfs, and the UIO core
  to finally call your irqcontrol function, which in turn calls
  enable_irq. As I said, there is broken hardware around where this is
  the only way, but most chips allow you to do it properly.

>   - I cannot understand it.
> 
> I'll try to list them all below.  Please tell us if the list isn't
> complete or if my comments doesn't convince you.  You might have to
> repeat yourself, but for me it's hard to sort your arguments because
> Magnus' suggestion changed over time.

OK, the version Magnus sent last is different, so some of my arguments
are superfluous now.

Please, to make things simpler, let's only talk about the concept as
such and not go into implementation details. I deliberately do not review
that code (although I believe it has more bugs than the one Alan found),
because as long as the concept doesn't make sense, I don't care how it
is implemented.

> 
> And please, I try to work out the pros and cons in a constructive way
> and hope there is nothing in it you will take personal.  It's really
> that I consider the patch valuable and don't understand your concerns.

You both keep telling me how valuable that patch is but never answered my
question what the advantage would be. I cannot see it yet.

> 
> In the first thread[1] your unique and open concerns (to the best of my
> knowledge and belief) with my comments are:
> 
> 	- "This only works for embedded devices [...]"
> 
> 	  OK, this doesn't work with shared IRQs which rules out x86.
> 	  I don't claim to know all the 23[2] other architectures but
> 	  IMHO if something is good for 3 archs and doesn't hurt the
> 	  other 21, you should do it.
> 
> 	- "This would save somebody the trouble to add the above 5 lines
> 	  to the 30 lines of board/platform support code he has to write
> 	  anyway. That's the only gain, and that is not enough."
> 
> 	  IMHO it's worth it.  Because if you add the five lines to a
> 	  central place you save 5 lines per platform using the driver.

OK, that is one argument in favor. I always admitted that, but said that
this is not enough to compensate for the disadvantages mentioned above.

> 	  Moreover this might prevent some bugs.  (And obviously this
> 	  function has the potential to have a buggy implementation as
> 	  the comment by Alan Cox shows.)

For me, this shows two things:

- I never ever had to use disable_irq_nosync() in any UIO driver yet,
  otherwise I would have noticed.

- Magnus turned in a patch that he never tested.

> 
> 	- "And if you _know_ that on your platform the irq is not
> 	  shared, this might really be a one-liner that simply calls
> 	  irq_disable. That's OK in board specific code, but not in a
> 	  generic driver."
> 	  
> 	  Please note that the patch only introduces a helper that the
> 	  platform code *can* use.  You still have the freedom not to
> 	  use it without any overhead.

It's not a good idea to add nonsense code and tell the users to ignore
it whenever they can...

> 
> 	- "I won't accept anything that changes the current UIO
> 	  behaviour."
> 
> 	  Not valid anymore.  There is no change in behaviour.

Well, at least the whole stuff would have to be explained in the docs.
You add an element to struct uio_info, together with a new #define. And
a whole class of drivers using that stuff would have a write() function
without needing it.

> 
> In the second thread[3] I cannot find any open concerns that are not
> already listed above.
> 
> > >  Changes since Uwe's last version:
> > >   - flags should be unsigned long
> > >   - simplify uio_userirq_handler()
> > 
> > That's nearly nothing. All you do is sending the same stuff three weeks
> > later in the hope somebody will merge it this time. NAK.
> I think nobody really is surprised that you're not happy with the new
> post.  But note that Magnus just did what you told him. ("I'm [not] the
> big boss who makes the final decision. I can be critized and overridden.
> If Greg loves your patch and merges it, fine. Try it.")
> 
> In the hope not to have kicked off a flame,

Oh, no, stay cool ;-)

Thanks,
Hans

