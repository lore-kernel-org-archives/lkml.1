Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZK0Xqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZK0Xqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZK0Xqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:46:52 -0500
Received: from www.tglx.de ([62.245.132.106]:34701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZK0Xqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:46:52 -0500
Date: Sat, 28 Nov 2009 00:46:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: John Ogness <john.ogness@linutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Sascha Hauer <kernel@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] MXC: set GPIO IRQ handler
In-Reply-To: <20091126075724.GA12179@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0911280005010.24119@localhost.localdomain>
References: <807htelb5d.fsf@merkur.tec.linutronix.de> <20091126075724.GA12179@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2120838363-1259363182=:24119"
Content-ID: <alpine.LFD.2.00.0911280006480.24119@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2120838363-1259363182=:24119
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.0911280006481.24119@localhost.localdomain>

On Thu, 26 Nov 2009, Uwe Kleine-König wrote:
> On Wed, Nov 25, 2009 at 07:19:58PM +0100, John Ogness wrote:
> > The irq chip function gpio_set_irq_type() correctly sets the i.MX
> > registers but does not set the irq handler.
>
> I assume you see some breakage without your patch?  In mainline?

Is there some other sensible reason why someone would send such a
patch with a completely clear change log ?

> 
>                                             This means that all
> > gpio-based irq's are handled with handle_edge_irq().

> This is not true in mainline, ...

We probably look at a different mainline, right ?

int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
{
....
         set_irq_chip(j, &gpio_irq_chip);
         set_irq_handler(j, handle_edge_irq);

> .... until 060d20d (imx/gpio: Use
> handle_level_irq) (currently in imx/mxc-master) hits Linus' tree ...

The patch fixes an existing problem in mainline. It does not matter
whether there is a different fix pending in some git tree which is
supposed to hit mainline at some undefined point in the future.

> > This patch corrects this by also setting the appropriate handler.
> > 
> > This patch is against 2.6.32-rc8.
> ... so there is no hurry.

Interesting conclusion: every level triggered GPIO interrupt in
2.6.32-rc8 is affected by this problem. Definitely nothing to worry
about ....

> Can you please test with 060d20d if your breakage still occurs and
> if it is still valid report some details (for me and the commit log)?

Could you please provide useful details, i.e. a short explanation why
that commit is the superior fix, instead of forcing people to clone a
git tree to figure out what you are (not) talking about ?

That's the change log of 060d20d:

    imx/gpio: Use handle_level_irq
    
    According to Russell King handle_edge_irq is only useful for "edge-based
    inputs where the controller does not remember transitions with the input
    masked."
    
    So using handle_edge_irq unconditionally for both edge and level irqs is
    wrong.  Testing showed that the controller does remember transitions
    while the interrupt is masked.  So use handle_level_irq unconditionally.

And the changelog is utter crap.

Using handle_edge_irq for level triggered interrupts has nothing to do
with Russell's observation simply because using handle_edge_irq for
level triggered interrupts is patently wrong.

The fact that the irq controller of the imx happens to be designed by
people who seem to have understood the pitfalls of edge triggered irqs
allows to use handle_level_irq for both edge and level triggered. 

That does not make John's patch incorrect. Using handle_level_irq for
both is merily an optimization which would be even more understandable
if there would be an useful comment in the code.

Thanks,

	tglx
--8323328-2120838363-1259363182=:24119--
