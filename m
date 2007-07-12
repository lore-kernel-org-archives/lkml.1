Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXGLOg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXGLOg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbXGLOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:36:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49700 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762056AbXGLOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:36:19 -0400
Date: Thu, 12 Jul 2007 10:36:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Piotr Muszynski <piotr@itg.hitachi.co.jp>
cc: Chuck Ebbert <cebbert@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] REQUEST_SENSE and ide-cd.c
In-Reply-To: <4695550C.7040501@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0707121022380.11819-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Chuck Ebbert wrote:

> On 07/11/2007 04:30 AM, Piotr Muszynski wrote:
> 
> [cc: linux-usb, linux-ide]

Thank you.  Piotr, you might have considered asking the person who
wrote the USB Mass Storage gadget driver...

> > I am adding transparent ATAPI capability to USB gadget Mass Storage
> > driver. The idea is to pass USB traffic to block device queue as packet
> > requests. At the end of the queue, the requests are handled by ide-cd.c
> > driver.

First, I'm not so sure it's a good idea to depend on the ide-cd driver.  
The entire IDE infrastructure is currently being changed.

Second, if you're designing an ATAPI pass-through driver, why restrict
yourself to CD devices?  Why not do a general ATAPI or even SCSI
pass-through?

Third, you shouldn't do this by adding SCSI/ATAPI capability to 
g_file_storage.  Instead you should write a completely new driver, 
since its operation will be quite different.  (I thought of doing this 
myself some time ago, but never felt the need.)  You could call it 
g_scsi_storage, for "SCSI-backed Storage driver".

> > It breaks when the ide-cd.c driver unconditionally generates
> > REQUEST_SENSE for requests that ended in unit attention condition.
> > 
> > By clearing the drive's unit attention condition, this additional
> > REQUEST_SENSE confuses the host, which fires it's own REQUEST_SENSE
> > packet, to which the drive replies with NO SENSE.
> > 
> > I can see three solutions:
> > 
> > 1. Intercept the sense data returned by ide-cd.c and emulate unit
> > attention condition in file_storage.c driver;

Correct except for the word "emulate": This would be a real Unit 
Attention condition.  Your driver would then have to return the sense 
data in response to the next REQUEST SENSE command from the host.

> > 2. Introduce a new request flag causing ide-cd.c to skip calling
> > cdrom_queue_request_sense() for flagged requests, like below:
> > 
> >     cdrom_decode_status() 2.6.12:
> >     -    if (stat & ERR_STAT) {
> >     +    if (stat & ERR_STAT && !(rq->flags & REQ_NO_AUTOSENSE)) {
> >              spin_lock_irqsave(&ide_lock, flags);
> >              blkdev_dequeue_request(rq);
> >              HWGROUP(drive)->rq = NULL;
> >              spin_unlock_irqrestore(&ide_lock, flags);
> >              cdrom_queue_request_sense(drive, rq->sense, rq);
> >          } else
> >              cdrom_end_request(drive, 0);

No.  You have to expect and allow for autosensing.

> > 3. Acknowledge that ide-cd.c was not meant to work as in (2) and search
> > for another mechanism. Where?

The SCSI-generic driver has a pass-through mechanism.  It is intended 
to be called from userspace, but you probably could use it from another 
driver too.  However you would still face the same problem.

> > (1) would unnecessarily duplicate the drive's state. I'd rather do (3).
> > 
> > So far, the (2) works well, but how bad is it?
> > I'd greatly appreciate any critical feedback.

Here's some more critical feedback: What you want to do is essentially
impossible, because it would require your driver to have unbounded
memory buffer space.  The host can transfer as much data as it likes
(up to 4 GB) and your driver would need to buffer all that data before
initiating the underlying ATAPI/SCSI command.

Unless you know of some mechanism I'm not aware of, whereby ide-cd or 
some other driver will allow you to provide the transfer data in pieces 
over a long period of time?

Alan Stern

