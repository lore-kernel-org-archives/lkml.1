Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZEZQvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZEZQvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZEZQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:51:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33606 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754058AbZEZQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:51:34 -0400
Date: Tue, 26 May 2009 12:51:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
In-Reply-To: <20090526160343.GA9842@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0905261248430.9278-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Michael S. Tsirkin wrote:

> > They would know.  But it's easy enough to find out.  (Looks through 
> > the SCSI code...)  Here we go.  scsi_io_completion() contains this:
> > 
> > 		case ILLEGAL_REQUEST:
> > 			/* If we had an ILLEGAL REQUEST returned, then
> > 			 * we may have performed an unsupported
> > 			 * command.  The only thing this should be
> > 			 * would be a ten byte read where only a six
> > 			 * byte read was supported.  Also, on a system
> > 			 * where READ CAPACITY failed, we may have
> > 			 * read past the end of the disk.
> > 			 */
> > 			if ((cmd->device->use_10_for_rw &&
> > 			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
> > 			    (cmd->cmnd[0] == READ_10 ||
> > 			     cmd->cmnd[0] == WRITE_10)) {
> > 				/* This will issue a new 6-byte command. */
> > 				cmd->device->use_10_for_rw = 0;
> > 				action = ACTION_REPREP;
> > 			} else if (sshdr.asc == 0x10) /* DIX */ {
> > 				description = "Host Data Integrity Failure";
> > 				action = ACTION_FAIL;
> > 				error = -EILSEQ;
> > 			} else
> > 				action = ACTION_FAIL;
> > 			break;
> 
> Which kernel version is this? I see different code in 2.6.30-rc7.

I don't.  It looks exactly the same as this (this was taken from 
2.6.30-rc6).  Look starting at line 844 of drivers/scsi/scsi_lib.c.

Alan Stern

