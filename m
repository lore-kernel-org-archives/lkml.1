Return-Path: <linux-kernel-owner+w=401wt.eu-S1764967AbYCFXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764967AbYCFXz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 18:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760103AbYCFXzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 18:55:48 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:21040 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996AbYCFXzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 18:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xfwC2f4tlI4UdGLRWvtVEXxvUc9ghRoycg4902yLQqCE/guWB2aPE7O1rwrGEIVfhoY7+p41ozj1oZJ5HpApjl0Umdy57u7DSvNMYxxym6a+/2JtCLQ17NU0vfsZ/fMZ0kqcbH9thIZuSxCNURm2SSp1bXuXWnHtPuKkZvIBjs0=
Message-ID: <47D08478.8010700@gmail.com>
Date: Fri, 07 Mar 2008 08:55:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: ata_ram driver
References: <20080222200951.GI16995@parisc-linux.org>	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com> <1204817301.3062.3.camel@localhost.localdomain>
In-Reply-To: <1204817301.3062.3.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> It's because of the sequence of events.  Currently, driver unload
>> sequence is the same as when the device is hot unplugged.  libata
>> detects that the device is gone and disables it and report it to SCSI
>> layer.  SCSI layer takes over and tries to kill the SCSI device and tell
>> sd to shutdown and sd issues START_STOP to shutdown which fails w/
>> DID_BAD_TARGET because the matching ATA device is already gone.  I've
>> left it that way because I'm not sure whether spinning down the drive on
>> driver unload is the correct thing to do.  The message is annoying tho.
> 
> Um, it's not supposed to happen that way.  Your signal that a disk is
> gone is slave destroy ... and we don't call that until after the target
> has been processed.  Devices are supposed to stay online (if possible)
> from slave alloc to slave destroy.

Currently, it's like the following.

* Explicit unplug request via sysfs or whatever: ATA device stays online
till slave_destroy finishes.

* Hot unplugging: Nothing much libata can do.  ATA device is yanked out
by the user.

* Driver unload: Dealt the same way as hot unplugging.

Making driver unload like explicit unplug request is possible but it
will mean that drives will be spun down on driver unload, which can be
annoying to developers.  In addition, the code path is shared with
controller hot unplug in which case it's probably best not to issue any
new command.  So, I've been reluctant to make the change.  If the change
is required, I think it can be done by adding a few lines at the top of
ata_port_detach().  Jeff, what do you think?

-- 
tejun
