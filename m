Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZCUOW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZCUOW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCUOWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:22:19 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60584 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZCUOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:22:18 -0400
Subject: Re: Overagressive failing of disk reads, both LIBATA and IDE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mark Lord <liml@rtr.ca>
Cc: Norman Diamond <n0diamond@yahoo.co.jp>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <49C30E67.4060702@rtr.ca>
References: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>
	 <49C30E67.4060702@rtr.ca>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 09:22:13 -0500
Message-Id: <1237645333.4600.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 23:32 -0400, Mark Lord wrote:
> Norman Diamond wrote:
> > For months I was wondering how a disk could do this:
> > dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=4  # succeeds
> > dd if=/dev/hda of=/dev/null bs=512 skip=551544 count=4  # succeeds
> > dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=8  # fails

This basically means the drive doesn't report where in the requested
transfer the error occurred.  If we have that information, we'd return
all sectors up to that LBA as OK and all at or beyond as -EIO, so the
readahead wouldn't matter.

> > It turns out the disk isn't doing that.  Linux is.  The old IDE drivers did
> > it, but with LIBATA the same thing happens to /dev/sda.  In later examples
> > also, the same happens to /dev/sda as /dev/hda.
> ..
> 
> You can blame me for the IDE driver not doing that properly.
> But for libata, it's the SCSI layer.
> 
> I've been patching this for years for my clients,
> and will be updating the patch soon-ish and trying
> again to get it into upstream kernels.
> 
> Here's the (now ancient) 2.6.20 version for SLES10:
> 
> * * *
> 
> Allow SCSI to continue with the remaining blocks of a request
> after encountering a media error.  Otherwise, it may just fail
> the entire request, even though some blocks were fine and needed
> by a completely different process than the one that wanted the bad block(s).
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> --- linux-2.6.16.60-0.6/drivers/scsi/scsi_lib.c	2008-03-10 13:46:03.000000000 -0400
> +++ linux/drivers/scsi/scsi_lib.c	2008-03-21 11:54:09.000000000 -0400
> @@ -888,6 +888,12 @@
>  	 */
>  	if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
> +		case MEDIUM_ERROR:
> +		/* Bad sector.  Fail it, and then continue the rest of the request. */
> +		if (scsi_end_request(cmd, 0, cmd->device->sector_size, 1) == NULL) {
> +			cmd->retries = 0;       // go around again..
> +			return;
> +		}

But we've been over this.  You can't apply something like this because
it ignores retries and chunks up the request a sector at a time.  For
the enterprise that can increase failure time from a few seconds to
hours for 512k transfers.

Using the disk supplied data about where the error occurred (provided
the disk returns it) eliminates all the readahead problems like the one
above.  Perhaps just turning of readahead for disks that don't supply
error location information would be a reasonable workaround?

James


