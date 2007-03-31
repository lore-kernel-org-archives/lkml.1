Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXCaVQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXCaVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXCaVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:16:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34476 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978AbXCaVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:16:57 -0400
Date: Sat, 31 Mar 2007 23:20:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eduard Bloch <edi@gmx.de>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070331232002.7b478f37@the-village.bc.nu>
In-Reply-To: <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net>
	<20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
	<20070330134327.GA24030@infradead.org>
	<20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
	<20070330191038.067c346b@the-village.bc.nu>
	<20070331170703.GA8179@rotes76.wohnheim.uni-kl.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But the desktop needs some means to deal with that. AFAICS the only
> feasible way for applications to communicate about device usage policy
> is locking with O_EXCL. Many people do not realize that even read-only

serial ports and mail both use fcntl file locking , which is much more
flexible.

> > The kernel does not have sufficient information to handle /dev/sg locking
> 
> But the kernel knows already that there is a block device behind it. It
> is displayed in sysfs. It shall "just" reuse the lock mechanism of that
> device, not more and not less. Naturally this "just" definition is
> bendable and that is why I initially asked here.

This doesn't help. There are legitimate reasons to use /dev/sg on a
device which is active. For most subsystems this actually makes a lot of
sense when doing things like enclosure control.

> The sad thing is, this is just another assumption. At least on Debian
> /dev/sgX belongs to the cdrom group when it's a cdrom device and the
> permissions do just invite to work with it.

Which means it is privilegded.

> IIRC there were similar issues with the SCSI command filtering with
> both but I am not sure on that.

SG_IO does command filtering, /dev/sg is intended to be assigned
correctly.

> > The desktop user space should really know what it is doing with the CD
> > device if it wants to do things like CD burning. If the serial port
> > people could get this right in 1977 then there is no excuse fo the CD
> 
> Serial port? Do we have multiple drivers with multiple interfaces
> accessing the same hardware simultaneously and independently? I don't
> think so.

getty/modem/uucp/terminal emulator/slip/ppp/.. 

I do think so.

> The use of /dev/sg* is still common practice, its invention predates

The /dev/sg interface cannot do the locking. If you use /dev/sg you are
telling the kernel you what you are doing. If you don't then you'll make
coasters or even bigger messes. 

If you are prepared to fix the apps then I'd suggest fixing them to use
fcntl locks with exclusive lock/shared lock according to their need for
exclusivity. That would fix some of the HAL problems (open has side
effects relocking doesnt), but there are still corner cases with mounted
file systems that need handling and I can see those might need some kernel
helping hands.

Alan
