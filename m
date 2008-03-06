Return-Path: <linux-kernel-owner+w=401wt.eu-S1764622AbYCFP2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764622AbYCFP2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYCFP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:28:28 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51853 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbYCFP20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:28:26 -0500
Subject: Re: ata_ram driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47CFA9A6.2040506@gmail.com>
References: <20080222200951.GI16995@parisc-linux.org>
	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 09:28:21 -0600
Message-Id: <1204817301.3062.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 17:21 +0900, Tejun Heo wrote:
> Mark Lord wrote:
> > Matthew Wilcox wrote:
> >> I've ported the scsi_ram driver [1] to libata.  It could use a lot more
> >> work -- there's a lot of stuff in the identify page that I haven't
> >> filled in, and there's a lot of commands it doesn't even try to execute.
> >>
> >> For example, when you unload the driver, you get the mildly disturbing
> >> messages:
> >>
> >> sd 12:0:0:0: [sdb] Stopping disk
> >> sd 12:0:0:0: [sdb] START_STOP FAILED
> >> sd 12:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
> >> driverbyte=DRIVER_OK,SUGGEST_OK
> >>
> > ..
> > 
> > I see messages like those with *established* libata drivers from time to
> > time.
> > It could just be a bug in the shutdown sequence, somewhere between libata,
> > SCSI, block layer, and the device model in general.  Or not.
> 
> It's because of the sequence of events.  Currently, driver unload
> sequence is the same as when the device is hot unplugged.  libata
> detects that the device is gone and disables it and report it to SCSI
> layer.  SCSI layer takes over and tries to kill the SCSI device and tell
> sd to shutdown and sd issues START_STOP to shutdown which fails w/
> DID_BAD_TARGET because the matching ATA device is already gone.  I've
> left it that way because I'm not sure whether spinning down the drive on
> driver unload is the correct thing to do.  The message is annoying tho.

Um, it's not supposed to happen that way.  Your signal that a disk is
gone is slave destroy ... and we don't call that until after the target
has been processed.  Devices are supposed to stay online (if possible)
from slave alloc to slave destroy.

James


