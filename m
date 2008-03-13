Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYCMKZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYCMKZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYCMKY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:24:58 -0400
Received: from www.tglx.de ([62.245.132.106]:40346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbYCMKY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:24:57 -0400
Date: Thu, 13 Mar 2008 11:24:32 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ben Nizette <bn@niasdigital.com>, gregkh <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] UIO: Implement a UIO interface for the SMX
 Cryptengine
Message-ID: <20080313112432.578076a5@dilbert.local>
In-Reply-To: <20080313100655.GA6705@linux-sh.org>
References: <1205400940.3735.15.camel@moss.renham>
	<20080313100655.GA6705@linux-sh.org>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 13 Mar 2008 19:06:55 +0900
schrieb Paul Mundt <lethal@linux-sh.org>:

> > +
> > +	info->name = "smx-ce";
> > +	info->version = "0.03";
> 
> You may as well use DRV_NAME and DRV_VERSION, then you can toss that over
> to MODULE_VERSION() if you're so inclined. It's generally nice to keep
> modinfo happy.

UIO name and version are intentionally independent of module name and
version. It's meant to be an information for the userspace part of the driver
and should be set to values that are meaningful for it.

> 
> > +	info->irq = platform_get_irq(dev, 0);
> > +	info->irq_flags = IRQF_SHARED;
> > +	info->handler = smx_handler;
> > +
> platform_get_irq() can fail, which you don't presently handle (though I
> guess uio_register_device() will error out if you hand off -ENXIO as your
> IRQ anyways, so it's not technically an issue). That's a pretty minor
> issue, though, but might be something you wish to fix up if you are
> planning on using this as an example driver for others.

uio_register_device() will silently not register an interrupt if the number
is negative. This allows us to register a driver without interrupts. Hmm.
Maybe we should explicitly check for UIO_IRQ_NONE there and fail if a
different negative irq is passed in. Thanks for pointing this out.

But I agree, Ben should check if platform_get_irq() failed.

> 
> > +	platform_set_drvdata(dev, info);
> > +
> > +	if (uio_register_device(&dev->dev, info))
> > +		goto out_unmap;
> > +
> > +	return 0;
> > +out_unmap:
> > +	iounmap(info->mem[0].internal_addr);
> > +out_free:
> > +	kfree(info);
> > +
> > +	return -ENODEV;
> > +}
> > +
> Your error paths are also pretty quiet. A dev_err() or so in the few
> failure cases you do have might not be a terrible idea.

I agree.

> 
> uio_register_device() also has quite a few different error cases, so it's
> at least worth preserving the error value and returning that back,
> rather than always returning -ENODEV.

Right. Maybe we should make uio_register_device a bit more verbose, too.

Thanks for your detailed review!

Hans
