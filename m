Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYCGACR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYCGACR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYCGACF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:02:05 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47909 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbYCGACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:02:04 -0500
Subject: Re: ata_ram driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <47D08478.8010700@gmail.com>
References: <20080222200951.GI16995@parisc-linux.org>
	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>
	 <1204817301.3062.3.camel@localhost.localdomain>
	 <47D08478.8010700@gmail.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 18:01:59 -0600
Message-Id: <1204848119.3062.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 08:55 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> >> It's because of the sequence of events.  Currently, driver unload
> >> sequence is the same as when the device is hot unplugged.  libata
> >> detects that the device is gone and disables it and report it to SCSI
> >> layer.  SCSI layer takes over and tries to kill the SCSI device and tell
> >> sd to shutdown and sd issues START_STOP to shutdown which fails w/
> >> DID_BAD_TARGET because the matching ATA device is already gone.  I've
> >> left it that way because I'm not sure whether spinning down the drive on
> >> driver unload is the correct thing to do.  The message is annoying tho.
> > 
> > Um, it's not supposed to happen that way.  Your signal that a disk is
> > gone is slave destroy ... and we don't call that until after the target
> > has been processed.  Devices are supposed to stay online (if possible)
> > from slave alloc to slave destroy.
> 
> Currently, it's like the following.
> 
> * Explicit unplug request via sysfs or whatever: ATA device stays online
> till slave_destroy finishes.

That's correct

> * Hot unplugging: Nothing much libata can do.  ATA device is yanked out
> by the user.

Yes, us too ... you just have to error all commands when the device
vanishes.

> * Driver unload: Dealt the same way as hot unplugging.

This is the problem case: driver unloading should have a
scsi_remove_host() in its path.  This is the trigger that sends out the
flushes/stops and calls slave_destroy.  scsi_remove_host() doesn't
actually return until all the destroys are completed, so it makes module
unloading wait until everything is properly shut down.

> Making driver unload like explicit unplug request is possible but it
> will mean that drives will be spun down on driver unload, which can be
> annoying to developers. 

You have a sysfs flag to prevent that, don't you?

>  In addition, the code path is shared with
> controller hot unplug in which case it's probably best not to issue any
> new command.  So, I've been reluctant to make the change.  If the change
> is required, I think it can be done by adding a few lines at the top of
> ata_port_detach().  Jeff, what do you think?

James


