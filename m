Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbYEWWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbYEWWoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYEWWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:44:11 -0400
Received: from www.tglx.de ([62.245.132.106]:54515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYEWWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:44:09 -0400
Date: Sat, 24 May 2008 00:43:59 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
	interrupts
Message-ID: <20080523224359.GA3190@local>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com> <20080523135557.27fe4855@bluebox.local> <c384c5ea0805231344j77f61941u229206d04c1ef948@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0805231344j77f61941u229206d04c1ef948@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 10:44:42PM +0200, Leon Woestenberg wrote:
> Hello,
> 
> On Fri, May 23, 2008 at 1:55 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> > +static ssize_t uio_write(struct file *filep, const char __user *buf,
> > +                       size_t count, loff_t *ppos)
> > +{
> > +       struct uio_listener *listener = filep->private_data;
> > +       struct uio_device *idev = listener->dev;
> > +       ssize_t retval;
> > +       s32 irq_on;
> > +
> > +       if (idev->info->irq == UIO_IRQ_NONE)
> > +               return -EIO;
> > +
> > +       if (count != sizeof(s32))
> > +               return -EINVAL;
> > +
> > +       if (!idev->info->irqcontrol)
> > +               return -ENOSYS;
> > +
> > +       if (copy_from_user(&irq_on, buf, count))
> > +               return -EFAULT;
> > +
> > +       retval = idev->info->irqcontrol(idev->info, irq_on);
> > +
> > +       return retval ? retval : sizeof(s32);
> > +}
> > +
> 
> Shouldn't this be more future-proof, what if we need to abuse write()
> for something else in the future?

We don't. I'm thinking about letting the function fail if irq_on is not
0 or 1, just to stop any ideas of abusing write().

read() and write() only deal with irq handling, all data exchange with the
device is done through mapped memory.

> 
> I would suggest a check for ppos to be 0 (zero) as well, just to be
> sure and future-proof and backwards-safe.

write() is only for enabling/disabling irqs, there's only one possible
value of count, and we don't have a seek function. So why check ppos?

Thanks,
Hans

