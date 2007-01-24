Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXAXPhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXAXPhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXAXPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:37:39 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36553 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXAXPhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:37:38 -0500
X-Sasl-enc: 1yr2ch0lWIpvBe3uXvkfZAlU5An7AwqLHzdEhmHuPAOk 1169653056
Date: Wed, 24 Jan 2007 13:37:27 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
Message-ID: <20070124153727.GC15402@khazad-dum.debian.net>
References: <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost> <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com> <20070123131040.GB13467@khazad-dum.debian.net> <45B6BF5D.1070300@gmail.com> <1169629789.3779.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169629789.3779.3.camel@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Soeren Sonnenburg wrote:
> might be a good idea to power down the drive using hdparm -Y followed by
> a scsiadd -r.

Unfortunately, I don't think this will be the optimal way to do it for long.
Unless I am mistaken, the above will soon have the potential to spin down
the device, and then reset the device to wake it up again (through error
handling, thus causing error messages in syslog) to send it a spin down
command(!).  It will work well right now, because scsiadd -r is unable to
shutdown a device and just removes it.

In the future, you will need to do *either* one, not both, if you told the
kernel to shutdown SCSI devices (which distros will likely enable by
default, as it is the right setup for everyone but people with servers
with disks attached to multi-initiator SCSI buses and it is required for
suspend-to-disk to work).

It will be a mess to make sure everything in userspace is updated to not try
to hdparm -y (or worse, hdparm -Y) devices that the kernel will shutdown by
itself, but it will make things a lot better for the future.

Unless...

Tejun, is it feasible to teach libata to check the device power management
state before issuing any of the sleep, head unload and spin-down commands?

libata would need to block its EH from resetting a channel for this check
operation (we don't want to wake up sleeping devices to ask it if it is
sleeping...) if it cannot easily check if an device is asleep before issuing
a command to it.   Either that, or (for as long as there is no such a thing
as a multi-initiator libata device) just keep track of the device power
management state by snooping all the commands sent to it.

The idea would be to do the "optimal" thing if one tries to sleep, unload
heads or spin down an device that is already doing one of these things...
That would make things MUCH easier on userspace.

> BIG FAT WARNING: if your SATA bay does not do electrical connector
> keying to let the disk firmware unload heads before the user manages to

This either is in the SATA specification, or it is not, and according to
Tejun it probably isn't (if it were, all disks would do the right thing at
unplug).  I'd reword it to "if your SATA bay does not take extra steps to
force the disk firmware to unload heads...".

> the disk or remove the disk from a dm setup). However it is recommended
> to power down the drive using hdparm -Y followed by a scsiadd -r as
> stated above. One can validate which disks are attached using ``scsiadd

Again, this might change soon.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
