Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXBSRGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXBSRGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbXBSRGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:06:36 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:20304 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932429AbXBSRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:06:35 -0500
Date: Mon, 19 Feb 2007 12:06:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: linux-kernel@vger.kernel.org, <jens.axboe@oracle.com>,
       <James.Bottomley@steeleye.com>, <dougg@torque.net>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <45d9cb72.je+WdtrFM7WV89m8%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.44L0.0702191148421.13197-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Joerg Schilling wrote:

> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Well, if Doug wants to reduce the value returned by SG_GET_RESERVED_SIZE, 
> > it's okay with me.  An advantage of doing this is that older versions of 
> > cdrecord would then work correctly.
> >
> > However you don't seem to realize that people can use programs like
> > cdrecord with devices whose drivers don't support SG_GET_RESERVED_SIZE --
> > because that ioctl works only with sg.  Programs would have to try
> > SG_GET_RESERVED_SIZE and if it faied, then try BLKSECTGET.
> 
> Is there any reason not to have one single ioctl for one basic feature?

Indeed there is not.  That's what I wrote in an earlier email:

  "There should be one single ioctl which can be applied uniformly to all
  CD-type devices (in fact, to all devices using a request_queue) to learn
  max_sectors.  This rules out using SG_GET_RESERVED_SIZE."

> > Remember also, the "reserved size" is _not_ the maximum allowed size of a
> > DMA transfer.  Rather, it is the size of an internal buffer maintained by
> > sg.  It's legal to do an I/O transfer larger than the "reserved size", but 
> > it is not legal to do an I/O transfer larger than max_sectors.
> 
> At the time the call SG_GET_RESERVED_SIZE has been discussed/defined, we did 
> originally agree that the max value should be limited to what the HW allows
> as DMA size. This is why I did originally files a bug against 
> SG_GET_RESERVED_SIZE.

How do you feel about the patch below, either in addition to or instead of 
the previous patch?

Alan Stern



Index: usb-2.6/drivers/scsi/sg.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sg.c
+++ usb-2.6/drivers/scsi/sg.c
@@ -917,6 +917,8 @@ sg_ioctl(struct inode *inode, struct fil
 			return result;
                 if (val < 0)
                         return -EINVAL;
+		if (val > sdp->device->request_queue->max_sectors * 512)
+			return -EOVERFLOW;
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;
@@ -925,7 +927,8 @@ sg_ioctl(struct inode *inode, struct fil
 		}
 		return 0;
 	case SG_GET_RESERVED_SIZE:
-		val = (int) sfp->reserve.bufflen;
+		val = min_t(int, sfp->reserve.bufflen,
+				sdp->device->request_queue->max_sectors * 512);
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);

