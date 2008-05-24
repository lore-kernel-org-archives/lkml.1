Return-Path: <linux-kernel-owner+w=401wt.eu-S1763166AbYEXWWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763166AbYEXWWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbYEXWW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:22:29 -0400
Received: from www.tglx.de ([62.245.132.106]:58486 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbYEXWW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:22:28 -0400
Date: Sun, 25 May 2008 00:22:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: "Hans J. Koch" <hjk@linutronix.de>,
       Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
In-Reply-To: <20080524044354.GA8129@suse.de>
Message-ID: <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com>
 <20080523135557.27fe4855@bluebox.local> <20080524044354.GA8129@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Greg KH wrote:

> On Fri, May 23, 2008 at 01:55:57PM +0200, Hans J. Koch wrote:
> > Sometimes it is necessary to enable/disable the interrupt of a UIO device
> > from the userspace part of the driver. With this patch, the UIO kernel driver
> > can implement an "irqcontrol()" function that does this. Userspace can write
> > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> > UIO core will then call the driver's irqcontrol function.
> 
> Why not just a new sysfs file for the uio device, irq_enabled, or
> something like that?  That way our main read/write path is left alone.

It makes a certain amount of sense to use write. You hold the device
file descriptor anyway for the read (wait for interrupt) operation,
so using the same file descriptor is not a too bad idea:

    while (!stop) {

        /* wait for interrupt */
	read(fd);

	do_stuff();

	/*reenable interrupt */
	write(fd);
    }

I thought about using a sysfs entry for a while, but looking at the
actual use case made the write() solution a more natural choice.

Thanks,

	tglx
