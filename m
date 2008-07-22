Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYGVR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYGVR5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYGVR5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:57:30 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:38514 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYGVR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:57:30 -0400
Date: Tue, 22 Jul 2008 12:57:29 -0500
From: scameron@beardog.cca.cpqcorp.net
To: linux-kernel@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Message-ID: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James Bottomley wrote:
> Actually, I think we can make one (which is really required ... it's a
> lot of pain to move device nodes, just look at libata).  It should be
> child's play to come up with a udev rule that simply does extra symbolic
> links from /dev/cciss<n>c<n>p<n> to whatever the sd device is.  That
> should hide a lot of the problem.
> 
> The other issue is plugging the management ioctl in, but that can be
> done via scsi_host->ioctl.
> 
> James 

Another thing which would help would be to expose device type 0x0C (raid
controller) and let sg bind to it.

CCISS_REPORT_LOGICAL and CCISS_REPORT_PHYSICAL will not return this device, but
you can artificially jam it into the list of devices, and give it an 8-byte LUN
address of all zeroes.  It will respond to inquiries, etc, so the regular scsi
device scan will find it if you map it to some bus/target/lun.

Then, it can be accessed via ioctls (and even SG_IO, though SG_IO seems to be
broken on some of the distros we support, I've noticed, so that doesn't help as
much as one might think.)

I think there might be an easier way (or at least it is more obvious to me) to
convert cciss to be a SCSI driver, and that is to reuse some of the existing
tape code that's in cciss_scsi.c.  (Probably more obvious to me because I wrote
that code.)

It is a little hard to see what Tomo's patch does, as it's all in one step.

In the times I've converted cciss to be a SCSI driver in the past 
the steps were more or less as follows (from memory):

1) copy the driver files into drivers/scsi,
2) rename everything, change the Makefile/Kconfig stuff to add in the new code.
3) take out the stuff that makes it a block driver
4) add a CCISS_REPORT_LOGICAL_LUNS call into the scsi tape device discovery
code, expose those devices, add the controller itself in to the list of devices
artificially (8-byte lun address == all zeroes).

At this point the driver will work, but performance will completely suck.

5) switch the tape code to use the block side command allocator, (cmd_alloc()
in cciss.c) and ditch the rinky-dink tape code command allocator
(scsi_cmd_alloc() in cciss_scsi.c) and jack up the number of commands 
and queue depth the SCSI side of the driver will support to something 
reasonable.

At this point performance will stop completely sucking.

6) rip out a bunch of the block side code.
7) (I've never actually done this step) move the necessary ioctls to the scsi
side of the driver.

The tape code has stuff for hot-plugging of things, sort of (and I sent up some
patches some time ago to make that better awhile ago, but they seemed to get
ignored for whatever reason.) This would need to change to be a bit more
careful (look at page 0x83 serial numbers to find what devices were
new/changed/gone rather than just looking at device type, which is what it's
doing now.  BTW, I have patches in the works for the block driver to improve
the behavior of rebuild_lun_table, which currently sucks in the brute force way
that it does things.  This patch also removes the duplicated discovery
cdde from cciss_init_one, and has cciss_init_one just call rebuild_lun_table(),
but I digress.)

In any case, I don't think what I described above was what was done here... It
looks like the tape code was ditched, and new code that does almost the same
thing was written.  Maybe there was a good reason for that, I don't know.

-- steve

