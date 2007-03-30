Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbXC3RHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbXC3RHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXC3RHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:07:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37810 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922AbXC3RHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:07:22 -0400
Date: Fri, 30 Mar 2007 19:10:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eduard Bloch <edi@gmx.de>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070330191038.067c346b@the-village.bc.nu>
In-Reply-To: <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net>
	<20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
	<20070330134327.GA24030@infradead.org>
	<20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>    If there is a simple way to get the mapping between the sg and sr
>    devices that would be great and almost solve the problems, but I
>    cannot discover a such thing in the kernel.

You can go trying to match bus values but we have SG_IO on /dev/sr. This
is an old known problem with /dev/sg, and it is one reason Jens and co
fixed it with the SG_IO interface.

>  - hald is using O_EXCL already, as wodim does, and this seems to work
>    well as long as they are acting on the same virtual devices.

You might want to try hal polling the master while burning on the slave
and vice versa that also used to cause some systems problems.

>  - of course the hardware does not handle concurent requests, it is
>    designed that way. It is burden of kernel to canalize the access and
>    deal with concurrency issues. Obviously the kernel can and shall not

It's the job of the kernel to serialize requests coming in and it does
that for you both with SCSI and even old IDE. If you ask it to do
something stupid then that becomes the desktops problem.

>    do all the work but at least the basic safety mechanisms must work
>    reliably and currently they don't.

The kernel does not have sufficient information to handle /dev/sg locking
by itself. That is one reason /dev/sg is a privileged interface. It's
designed to let you do anything however crazy you like, as root. If you
do something stupid it breaks. The whole point of /dev/sg is that you can
do anything with it. You shouldn't be using /dev/sg for normal CD burning
applications on 2.6. 

For sane systems use the SG_IO interface on the proper device file. That
also fixes the need for setuid access and the like except when issuing
"dangerous" commands.

Christoph is wrong about one point, the hardware isn't broken, The IDE bus
is merely badly designed in this area. 

HAL breaks systems, it causes some laptops to burn power and on a few
boxes kills your disk performance. It'll also stop a few boxes reading
video-cd disks. Most of that appears to be HAL problems or indirectly
through problems in the locking scheme chosen (O_EXCL not fcntl locks).

The desktop user space should really know what it is doing with the CD
device if it wants to do things like CD burning. If the serial port
people could get this right in 1977 then there is no excuse fo the CD
using people not getting it right in 2007

Alan
