Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYGJK7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYGJK7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYGJK7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:59:40 -0400
Received: from www.tglx.de ([62.245.132.106]:45310 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbYGJK7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:59:39 -0400
Date: Thu, 10 Jul 2008 12:58:51 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710105850.GA3202@local>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se> <20080710065639.GA16794@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080710065639.GA16794@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 08:56:39AM +0200, Uwe Kleine-König wrote:
> > +
> > +static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
> > +{
> > +       struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> > +       unsigned long flags;
> > +
> > +       /* Just disable the interrupt in the interrupt controller, and
> > +        * remember the state so we can allow user space to enable it later.
> > +        */
> > +       spin_lock_irqsave(&priv->lock, flags);
> > +       if (!priv->irq_disabled) {
> > +               disable_irq_nosync(irq);
> > +               priv->irq_disabled = 1;
> > +       }
> > +       spin_unlock_irqrestore(&priv->lock, flags);
> > +       return IRQ_HANDLED;
> > +}
> > +
> > +static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
> > +{
> > +       struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> > +       unsigned long flags;
> > +
> > +       /* Allow user space to enable and disable the interrupt
> > +        * in the interrupt controller, but keep track of the
> > +        * state to prevent per-irq depth damage.
> > +        */
> > +
> > +       spin_lock_irqsave(&priv->lock, flags);
> > +       if (irq_on && priv->irq_disabled)
> > +               enable_irq(dev_info->irq);
> > +       else if (!irq_on && !priv->irq_disabled)
> > +               disable_irq(dev_info->irq);
> I'm not sure if this is a problem on SMP.  Should you use
> disable_irq_nosync here, too?  Probably it's OK.

*_nosync should not be needed, as he doesn't call irqcontrol from the irq
handler. But using the same lock in handler and irqcontrol presents a
problem, as Alan pointed out.

> 
> > +
> > +       priv->irq_disabled = !irq_on;
> > +       spin_unlock_irqrestore(&priv->lock, flags);
> > +       return 0;
> > +}
> 
> 
> > +       ret = uio_register_device(&pdev->dev, priv->uioinfo);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "unable to register uio device\n");
> > +               goto bad1;
> > +       }
> > +
> > +       platform_set_drvdata(pdev, priv);
> This should probably go before uio_register_device.  (Uups, this is an
> issue for uio_pdrv, too.)

Yes, because uio_register_device will enable the irq, and you might
arrive in the handler without having your platform data in place.

Thanks,
Hans

