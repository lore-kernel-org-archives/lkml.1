Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZEZQE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZEZQE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZEZQEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:04:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42393 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZEZQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:04:47 -0400
Date: Tue, 26 May 2009 19:03:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090526160343.GA9842@redhat.com>
References: <20090525212325.GD6856@redhat.com> <Pine.LNX.4.44L0.0905260958400.3584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905260958400.3584-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 10:04:01AM -0400, Alan Stern wrote:
> On Tue, 26 May 2009, Michael S. Tsirkin wrote:
> 
> > On Mon, May 25, 2009 at 05:08:12PM -0400, Alan Stern wrote:
> > > On Mon, 25 May 2009, Michael S. Tsirkin wrote:
> > > 
> > > > > So apparently this is a bug in the device; it doesn't respond correctly
> > > > > to the first READ command.  But since it does respond correctly to 
> > > > > later commands, everything works okay thereafter.  You ought to be able 
> > > > > to recover from the error by running
> > > > > 
> > > > > 	blockdev --rereadpt /dev/sdb
> > > > > 
> > > > > manually.
> > > > 
> > > > Yes, this helps.
> > > > Would it make sense for kernel to retry automatically?
> > > > Why doesn't it?
> > > 
> > > I don't know the details in this case.  Most likely the error code 
> > > (Logical Block Address Out of Range) is interpreted as a fatal 
> > > non-retryable error.  For other sorts of errors, the kernel does retry.
> > 
> > Who would know? The scsi crowd?
> 
> They would know.  But it's easy enough to find out.  (Looks through 
> the SCSI code...)  Here we go.  scsi_io_completion() contains this:
> 
> 		case ILLEGAL_REQUEST:
> 			/* If we had an ILLEGAL REQUEST returned, then
> 			 * we may have performed an unsupported
> 			 * command.  The only thing this should be
> 			 * would be a ten byte read where only a six
> 			 * byte read was supported.  Also, on a system
> 			 * where READ CAPACITY failed, we may have
> 			 * read past the end of the disk.
> 			 */
> 			if ((cmd->device->use_10_for_rw &&
> 			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
> 			    (cmd->cmnd[0] == READ_10 ||
> 			     cmd->cmnd[0] == WRITE_10)) {
> 				/* This will issue a new 6-byte command. */
> 				cmd->device->use_10_for_rw = 0;
> 				action = ACTION_REPREP;
> 			} else if (sshdr.asc == 0x10) /* DIX */ {
> 				description = "Host Data Integrity Failure";
> 				action = ACTION_FAIL;
> 				error = -EILSEQ;
> 			} else
> 				action = ACTION_FAIL;
> 			break;

Which kernel version is this? I see different code in 2.6.30-rc7.

> Since the Sense Key value was ILLEGAL_REQUEST and the ASC value wasn't 
> 0x10 or 0x20, action gets set to ACTION_FAIL.  Hence the command is not 
> retried.
> 
> In the end, there's a limit to how far the kernel should go in 
> compensating for buggy devices.  Your device may well have passed that 
> limit.
> 
> Alan Stern

Let's see, hope to find a workaround that isn't too ugly to be included.

-- 
MST
