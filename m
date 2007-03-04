Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbXCDXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbXCDXZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXCDXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:25:48 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52528 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXCDXZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:25:47 -0500
Date: Sun, 04 Mar 2007 17:25:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: CK804 SATA Errors (still got them)
In-reply-to: <200703021547.09121.s0348365@sms.ed.ac.uk>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Message-id: <45EB555C.9050606@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200703011339.52895.s0348365@sms.ed.ac.uk>
 <200703020120.52879.s0348365@sms.ed.ac.uk> <45E78E8A.2090202@shaw.ca>
 <200703021547.09121.s0348365@sms.ed.ac.uk>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
>> Can you try reverting commit 721449bf0d51213fe3abf0ac3e3561ef9ea7827a
>> (link below) and see what effect that has?
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h
>> =721449bf0d51213fe3abf0ac3e3561ef9ea7827a
> 
> Obviously, I'll let you know if it happens again, but I've reverted this 
> commit and transferred 22.5GB over 45 minutes onto a RAID5 with 4 HDs on an 
> NVIDIA sata controller, and this error hasn't appeared.
> 
> So I'm inclined to (very unscientifically) say that this brings it back to 
> 2.6.20's level of stability.

Interesting. Can you try un-reverting that patch, and applying this one?

The reading of the status register is something that was part of the original
NVidia code, which I'm not really sure why is there. Given that reading
the status register clears the drive's interrupt status, that might be
causing some wierd interaction with the ADMA controller. Also, I added in
a printk for cases where notifiers are triggered but the command doesn't
indicate completion - if you still get problems, let me know if you see
that message.

--- linux-2.6.21-rc2-git3/drivers/ata/sata_nv.c	2007-03-04 14:44:05.000000000 -0600
+++ linux-2.6.21-rc2-git3edit/drivers/ata/sata_nv.c	2007-03-04 17:09:06.000000000 -0600
@@ -745,10 +745,10 @@
 			/* Grab the ATA port status for non-NCQ commands.
 			   For NCQ commands the current status may have nothing to do with
 			   the command just completed. */
-			if (qc->tf.protocol != ATA_PROT_NCQ) {
+/*			if (qc->tf.protocol != ATA_PROT_NCQ) {
 				u8 ata_status = readb(pp->ctl_block + (ATA_REG_STATUS * 4));
 				qc->err_mask |= ac_err_mask(ata_status);
-			}
+			}*/
 			DPRINTK("Completing qc from tag %d with err_mask %u\n",cpb_num,
 				qc->err_mask);
 			ata_qc_complete(qc);
@@ -764,6 +764,9 @@
 			ata_port_freeze(ap);
 			return 1;
 		}
+	} else {
+		ata_port_printk(ap, KERN_WARNING, "notifier for tag %d but not complete?\n",
+			cpb_num);
 	}
 	return 0;
 }
