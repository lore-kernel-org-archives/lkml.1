Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbXCaRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbXCaRH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXCaRH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:07:27 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:56564 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXCaRH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:07:26 -0400
Date: Sat, 31 Mar 2007 19:07:03 +0200
From: Eduard Bloch <edi@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org> <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de> <20070330191038.067c346b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330191038.067c346b@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>
* Alan Cox [Fri, Mar 30 2007, 07:10:38PM]:
> >    If there is a simple way to get the mapping between the sg and sr
> >    devices that would be great and almost solve the problems, but I
> >    cannot discover a such thing in the kernel.
> 
> You can go trying to match bus values but we have SG_IO on /dev/sr. This
> is an old known problem with /dev/sg, and it is one reason Jens and co
> fixed it with the SG_IO interface.

I am trying a different way now, fishing the associated device name from
sysfs' symlinks and then reassigning the device access to /dev/sr. Not
that I like it very much but it seems to be the best workaround, even
independent from potential fixes in kernel. I do not count on them
either, considering the hostile tone here.

> >  - of course the hardware does not handle concurent requests, it is
> >    designed that way. It is burden of kernel to canalize the access and
> >    deal with concurrency issues. Obviously the kernel can and shall not
> 
> It's the job of the kernel to serialize requests coming in and it does
> that for you both with SCSI and even old IDE. If you ask it to do
> something stupid then that becomes the desktops problem.

But the desktop needs some means to deal with that. AFAICS the only
feasible way for applications to communicate about device usage policy
is locking with O_EXCL. Many people do not realize that even read-only
actions do harm when a delicate operation is in progress. This bad
assumption is already hardcoded into crucial components like libblkid
(mount), increasing the risk of creating coasters up to 100 percent for
no good reason, IMHO.

> >    do all the work but at least the basic safety mechanisms must work
> >    reliably and currently they don't.
> 
> The kernel does not have sufficient information to handle /dev/sg locking

But the kernel knows already that there is a block device behind it. It
is displayed in sysfs. It shall "just" reuse the lock mechanism of that
device, not more and not less. Naturally this "just" definition is
bendable and that is why I initially asked here.

> by itself. That is one reason /dev/sg is a privileged interface. It's
> designed to let you do anything however crazy you like, as root. If you
> do something stupid it breaks. The whole point of /dev/sg is that you can
> do anything with it. You shouldn't be using /dev/sg for normal CD burning
> applications on 2.6. 

The sad thing is, this is just another assumption. At least on Debian
/dev/sgX belongs to the cdrom group when it's a cdrom device and the
permissions do just invite to work with it.

> For sane systems use the SG_IO interface on the proper device file. That
> also fixes the need for setuid access and the like except when issuing
> "dangerous" commands.

IIRC there were similar issues with the SCSI command filtering with
both but I am not sure on that.

> The desktop user space should really know what it is doing with the CD
> device if it wants to do things like CD burning. If the serial port
> people could get this right in 1977 then there is no excuse fo the CD

Serial port? Do we have multiple drivers with multiple interfaces
accessing the same hardware simultaneously and independently? I don't
think so.

> using people not getting it right in 2007

CD burning people (at least most of them) do get it right, please
realize that. It is others who come along and disturb the burning
process. And sometimes it is even not their fault, e.g. hald is assumed
to do proper locking with O_EXCL. They may just happen to use different
userspace interfaces, and the kernel lets them clash.

Oh, and please don't kill the messenger, I am not Schilling.

And if you think it is just simple and sufficient to tell people "you
have to use /dev/sr now and everything else is your problem", please
compare that with the time line of devfs deprecation, for example.

The use of /dev/sg* is still common practice, its invention predates
devfs by many years and there is no big campaign telling to switch to
udev and there is no automatic fallback to a safe system (like static
device files) and no obvious way to see what is going on before the
burning process starts. You just get a coaster in the beginning and no
clear way to see why it happens. I guess it will take years for the
you-shall-not-use-sg message to settle down in the heads of users.

Eduard.
-- 
Klug sein hat noch nie einen Menschen an Dummheiten gehindert.
		-- Stefan Zweig
