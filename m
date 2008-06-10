Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYFJTZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYFJTZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYFJTZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:25:14 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:2813 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbYFJTZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:25:12 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-51.messagelabs.com!1213125910!2929156!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 10 Jun 2008 21:24:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
       "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080610192412.GA3065@digi.com>
References: <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com> <20080609084411.GA3223@local> <20080609090123.GA12080@linux-sh.org> <20080609123406.GB27803@digi.com> <aec7e5c30806092140s21cc8cbdtbaf69f864dd2bda7@mail.gmail.com> <20080610071032.GB22814@digi.com> <20080610173253.GA21204@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080610173253.GA21204@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jun 2008 19:24:15.0992 (UTC) FILETIME=[9262F780:01C8CB2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

> > diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> > index cdf338d..671a7a8 100644
> > --- a/include/linux/uio_driver.h
> > +++ b/include/linux/uio_driver.h
> > @@ -63,6 +63,7 @@ struct uio_info {
> >       long                    irq;
> >       unsigned long           irq_flags;
> >       void                    *priv;
> > +     unsigned int            flags;
> >       irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
> >       int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
> >       int (*open)(struct uio_info *info, struct inode *inode);
> 
> This should be unsigned long.
Is this only because test_and_set_bit takes an unsigned long?  Or is a
long type preferable in general?

> > +static inline irqreturn_t uio_userirq_handler(int irq,
> > +             struct uio_info *dev_info)
> > +{
> > +     int ret;
> > +
> > +     if (likely(dev_info->irqcontrol)) {
> > +             ret = dev_info->irqcontrol(dev_info, 0);
> > +             if (ret) {
> > +                     pr_warning("%s: failed to disable irq\n", __func__);
> > +                     return IRQ_NONE;
> > +             } else
> > +                     return IRQ_HANDLED;
> > +     } else
> > +             return IRQ_NONE;
> > +}
> > +
> You can simplify this by just using IRQ_RETVAL() on
> dev_info->irqcontrol(...). The printk() shouldn't be necessary, as the
> other layers should already catch that.
Right, we can make this:

	static inline irqreturn_t uio_userirq_handler(int irq,
			struct uio_info *dev_info)
	{
		int ret = -1;

		if (likely(dev_info->irqcontrol))
			ret = dev_info->irqcontrol(dev_info, 0);

		return IRQ_RETVAL(ret == 0);
	}

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
