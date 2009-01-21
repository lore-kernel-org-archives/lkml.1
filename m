Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZAURPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZAURPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZAURPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:15:44 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:5857 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZAURPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:15:43 -0500
Date: Wed, 21 Jan 2009 09:01:16 -0800
From: Brandon Philips <brandon@ifup.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: uio: add the uio_aec driver
Message-ID: <20090121170116.GA18567@jenkins.ifup.org>
References: <20090120204729.GA26477@jenkins.ifup.org> <20090120214832.GE3027@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120214832.GE3027@local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:48 Tue 20 Jan 2009, Hans J. Koch wrote:
> On Tue, Jan 20, 2009 at 12:47:29PM -0800, Brandon Philips wrote:
> > UIO driver for the Adrienne Electronics Corporation PCI time code
> > device.
> > 
> > This device differs from other UIO devices since it uses I/O ports instead of
> > memory mapped I/O. In order to make it possible for UIO to work with this
> > device a utility, uioport, can be used to read and write the ports.
> 
> We just added a feature to UIO that allows you to pass information about
> such I/O ports to userspace. In struct uio_info, there's now also a port[]
> array for that purpose. In your case, you will probably want to set the
> the porttype member of struct uio_port to UIO_PORT_X86.
> 
> The portio feature is available since .29-rc1, please use it.

Sounds good. I will rework it along with your suggestions below.

> > uioport is designed to be a setuid program and checks the permissions of
> > the /dev/uio* node and if the user has write permissions it will use
> > iopl and out*/in* to access the device.
> 
> What happens with PCI on PowerPC ?

I don't know. I could use /dev/port but my concern is that the device
spec sheet specifies that some writes should be done with outb and
others with outl. /dev/port only uses outb. Do you know if outl is
different than four outb's to a device?

Cheers,

	Brandon

> > @@ -91,5 +91,6 @@ extern void uio_event_notify(struct uio_
> >  #define UIO_MEM_PHYS	1
> >  #define UIO_MEM_LOGICAL	2
> >  #define UIO_MEM_VIRTUAL 3
> > +#define UIO_MEM_PORT	4
> 
> As I explained above, this is not needed anymore. The reason we don't want
> this: It breaks generic userspace tools that rely on the fact that any
> memory found underneath the maps/ directory in sysfs can be mapped.
> 
> In case of ports we don't have anything to be mapped, we simply want to
> pass information to userspace. That justifies having a different sysfs
> directory for it.

ack.

> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/init.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/cdev.h>
> > +#include <linux/fs.h>
> > +#include <linux/io.h>
> > +#include <asm/system.h>
> 
> please put this <asm/...> include under the <linux/...> includes, separated by
> one blank line. Makes it easier to find. BTW, do you actually need this one?

ack.

> > +	iowrite32(INT_ENABLE, info->mem[0].internal_addr + INT_ENABLE_ADDR);
> > +	iowrite8(INT_MASK_ALL, info->mem[0].internal_addr + INT_MASK_ADDR);
> > +	if (ioread8(info->mem[0].internal_addr + INTA_DRVR_ADDR)
> > +			& INTA_ENABLED_FLAG)
> > +		printk(KERN_INFO "aectc: interrupts successfully enabled\n");
> 
> I'd find it better if you printed a message in case of failure...
> And please use dev_err() etc. instead of printk().

ack.

> BTW, if this test fails, are you sure you can continue and let probe()
> succeed?

Yes, if it fails the device still has a "polling" mode.
