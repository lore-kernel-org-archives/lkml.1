Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYG3VHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYG3VHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYG3VHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:07:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44444 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752706AbYG3VHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:07:30 -0400
Date: Wed, 30 Jul 2008 17:07:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Hancock <hancockr@shaw.ca>
cc: Tomas Styblo <tripie@cpan.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <4890C72D.7040604@shaw.ca>
Message-ID: <Pine.LNX.4.44L0.0807301700310.2322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Robert Hancock wrote:

> > I suppose in such cases we could simply report that the command failed
> > completely.
> 
> I think that is what we need to do. The SCSI/block layers should retry 
> the command or report a failure to userspace. Above all else we can't 
> just continue on our merry way and assume success, otherwise data will 
> get silently corrupted.
> 
> It could be that's what Windows is doing, and it's just silently 
> retrying commands. Though, some people have reported corruption on these 
> chipsets on Windows too, so maybe it has the same issue.

It's probably a combination of problems.

> Is that SCSI/USB underflow fix from 
> http://bugzilla.kernel.org/show_bug.cgi?id=9638 being pushed forward by 
> anybody? If not, I can try and cook up a patch to take care of that as 
> well as the non-underflow failed CSW/no sense data issue.

The patch situation is a little confused.  The change to the SCSI stack
are already present in 2.6.27-rc1.  I am not pushing the added delay
patch; I want to do some testing of my own and hear from other people
about it before submitting it.

The USB change discussed there is written but not yet submitted.  It
also needs testing.  Would you like to try it under 2.6.27-rc1?  Here
it is.

Alan Stern


Index: usb-2.6/drivers/usb/storage/transport.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/transport.c
+++ usb-2.6/drivers/usb/storage/transport.c
@@ -663,7 +663,7 @@ void usb_stor_invoke_transport(struct sc
 	}
 
 	/* Did we transfer less than the minimum amount required? */
-	if (srb->result == SAM_STAT_GOOD &&
+	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
 			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
 		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
 

