Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbZK2U1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbZK2U1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 15:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZK2U1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 15:27:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40780 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZK2U1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 15:27:52 -0500
Date: Sun, 29 Nov 2009 21:27:21 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Ogness <john.ogness@linutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Sascha Hauer <kernel@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] MXC: set GPIO IRQ handler
Message-ID: <20091129202721.GA22137@pengutronix.de>
References: <807htelb5d.fsf@merkur.tec.linutronix.de> <20091126075724.GA12179@pengutronix.de> <alpine.LFD.2.00.0911280005010.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0911280005010.24119@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, Nov 28, 2009 at 12:46:18AM +0100, Thomas Gleixner wrote:
> On Thu, 26 Nov 2009, Uwe Kleine-König wrote:
> > On Wed, Nov 25, 2009 at 07:19:58PM +0100, John Ogness wrote:
> > > The irq chip function gpio_set_irq_type() correctly sets the i.MX
> > > registers but does not set the irq handler.
> >
> > I assume you see some breakage without your patch?  In mainline?
> 
> Is there some other sensible reason why someone would send such a
> patch with a completely clear change log ?
IMHO John's commit could point out where he saw breakage.  This applies
to mine, too, of course.

> > 
> >                                             This means that all
> > > gpio-based irq's are handled with handle_edge_irq().
> 
> > This is not true in mainline, ...
> 
> We probably look at a different mainline, right ?
> 
> int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
> {
> ....
>          set_irq_chip(j, &gpio_irq_chip);
>          set_irq_handler(j, handle_edge_irq);

Oh, I was sure that John wrote "... all gpio-based irq's are handled
with handle_level_irq()."  Sorry for the confusion.
 
> > .... until 060d20d (imx/gpio: Use
> > handle_level_irq) (currently in imx/mxc-master) hits Linus' tree ...

> 
> The patch fixes an existing problem in mainline. It does not matter
> whether there is a different fix pending in some git tree which is
> supposed to hit mainline at some undefined point in the future.
That undefined point in future is the next merge window and the commit
is already contained in rmk's devel branch.

> > > This patch corrects this by also setting the appropriate handler.
> > > 
> > > This patch is against 2.6.32-rc8.
> > ... so there is no hurry.
> 
> Interesting conclusion: every level triggered GPIO interrupt in
> 2.6.32-rc8 is affected by this problem. Definitely nothing to worry
> about ....
When I sent the patch that became 060d20d to Sascha Hauer I considered
this a fix that should go in before 2.6.32, too.  Sascha decided it to
be too risky to take it outside of the merge window as he didn't knew of
any breakage in mainline code.  That's why I asked where John saw
breakage and if my patch helps.  And yes, if (and only if) the breakage
happens only for a platform or a driver that is not in mainline I don't
see a reason to take the patch before 2.6.32.  Agreed?

> > Can you please test with 060d20d if your breakage still occurs and
> > if it is still valid report some details (for me and the commit log)?
> 
> Could you please provide useful details, i.e. a short explanation why
> that commit is the superior fix, instead of forcing people to clone a
> git tree to figure out what you are (not) talking about ?
As I misread John's commit log I thought that he already has looked at
the imx tree.  (Which seems natural when working with that platform.)
I just noticed that the tree isn't listed in MAINTAINERS, I will send a
patch for that.

Having the commit log of 060d20d I don't consider it too hard to work
out why my commit should fix John's problem, too.

> That's the change log of 060d20d:
> 
>     imx/gpio: Use handle_level_irq
>     
>     According to Russell King handle_edge_irq is only useful for "edge-based
>     inputs where the controller does not remember transitions with the input
>     masked."
>     
>     So using handle_edge_irq unconditionally for both edge and level irqs is
>     wrong.  Testing showed that the controller does remember transitions
>     while the interrupt is masked.  So use handle_level_irq unconditionally.
> 
> And the changelog is utter crap.
> 
> Using handle_edge_irq for level triggered interrupts has nothing to do
> with Russell's observation simply because using handle_edge_irq for
> level triggered interrupts is patently wrong.
> 
> The fact that the irq controller of the imx happens to be designed by
> people who seem to have understood the pitfalls of edge triggered irqs
> allows to use handle_level_irq for both edge and level triggered. 
> 
> That does not make John's patch incorrect. Using handle_level_irq for
> both is merily an optimization which would be even more understandable
> if there would be an useful comment in the code.
I didn't say that John's patch is wrong.  And instead of documenting
that handle_level_irq (which is named a bit misleading) is capable of
handling edge irqs on imx, too, what about creating a handler with a
better name (say handle_generic_irq?---open for better suggestions) and
making handle_level_irq a deprecated wrapper for it?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
