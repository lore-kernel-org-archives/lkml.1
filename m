Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbZCTKNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbZCTKNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbZCTKGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:06:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760318AbZCTKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:06:51 -0400
Date: Fri, 20 Mar 2009 03:00:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <liml@rtr.ca>
Cc: Norman Diamond <n0diamond@yahoo.co.jp>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Overagressive failing of disk reads, both LIBATA and IDE
Message-Id: <20090320030012.2f19f709.akpm@linux-foundation.org>
In-Reply-To: <49C30E67.4060702@rtr.ca>
References: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>
	<49C30E67.4060702@rtr.ca>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 23:32:55 -0400 Mark Lord <liml@rtr.ca> wrote:

> Norman Diamond wrote:
> > For months I was wondering how a disk could do this:
> > dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=4  # succeeds
> > dd if=/dev/hda of=/dev/null bs=512 skip=551544 count=4  # succeeds
> > dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=8  # fails
> > 
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
>  		case UNIT_ATTENTION:
>  			if (cmd->device->removable) {
>  				/* Detected disc change.  Set a bit

Once upon a time the VFS would fall back to single page reads when a large
readahead request failed.  That's probably still the case.

It was more by accident than by design, but it had (has) the desired effect?
