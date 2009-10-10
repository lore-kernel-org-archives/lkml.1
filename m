Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbZJJWS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbZJJWS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbZJJWS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:18:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:34574 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbZJJWSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:18:24 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <1255209617.3387.9.camel@pasglop>
References: <Pine.LNX.4.44L0.0910101637030.6451-100000@netrider.rowland.org>
	 <1255209617.3387.9.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 09:17:01 +1100
Message-Id: <1255213021.2192.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 08:20 +1100, Benjamin Herrenschmidt wrote:

> Yes, that works, you can see the ttyUSBx ports showing up. It looks like
> it may just be the resets coming from usb-storage that are breaking
> things.

Ok so I did a quick hack to usb-storage, basically put the block that
tests for the response size and sets USB_FL_SANE_SENSE into an #if 0 :

(This is 2.6.31.2 since that's what I have a built source at hand
right now)

#if 0
		/* If the sense data returned is larger than 18-bytes then we
		 * assume this device supports requesting more in the future.
		 * The response code must be 70h through 73h inclusive.
		 */
		if (srb->sense_buffer[7] > (US_SENSE_SIZE - 8) &&
		    !(us->fflags & US_FL_SANE_SENSE) &&
		    (srb->sense_buffer[0] & 0x7C) == 0x70) {
			US_DEBUGP("-- SANE_SENSE support enabled\n");
			us->fflags |= US_FL_SANE_SENSE;

			/* Indicate to the user that we truncated their sense
			 * because we didn't know it supported larger sense.
			 */
			US_DEBUGP("-- Sense data truncated to %i from %i\n",
			          US_SENSE_SIZE,
			          srb->sense_buffer[7] + 8);
			srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
		}
#endif

Now, the result in the dmesg log is :

Oct 11 09:04:05 pasglop kernel: [   52.916100] usb 4-1: new full speed USB device using uhci_hcd and address 2
Oct 11 09:04:05 pasglop kernel: [   53.076402] usb 4-1: configuration #1 chosen from 1 choice
Oct 11 09:04:06 pasglop kernel: [   53.104090] Initializing USB Mass Storage driver...
Oct 11 09:04:06 pasglop kernel: [   53.105405] scsi2 : SCSI emulation for USB Mass Storage devices
Oct 11 09:04:06 pasglop kernel: [   53.105585] usbcore: registered new interface driver usb-storage
Oct 11 09:04:06 pasglop kernel: [   53.105589] USB Mass Storage support registered.
Oct 11 09:04:06 pasglop kernel: [   53.107164] usb-storage: device found at 2
Oct 11 09:04:06 pasglop kernel: [   53.107167] usb-storage: waiting for device to settle before scanning
Oct 11 09:04:06 pasglop kernel: [   53.224104] usb 4-1: USB disconnect, address 2
Oct 11 09:04:06 pasglop kernel: [   53.960100] usb 4-1: new full speed USB device using uhci_hcd and address 3
Oct 11 09:04:11 pasglop kernel: [   54.121941] usb 4-1: configuration #1 chosen from 1 choice
Oct 11 09:04:11 pasglop kernel: [   54.140861] scsi6 : SCSI emulation for USB Mass Storage devices
Oct 11 09:04:11 pasglop kernel: [   54.143007] usb-storage: device found at 3
Oct 11 09:04:11 pasglop kernel: [   54.143010] usb-storage: waiting for device to settle before scanning
Oct 11 09:04:11 pasglop kernel: [   59.141422] usb-storage: device scan complete
Oct 11 09:04:11 pasglop kernel: [   59.144370] scsi 6:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
Oct 11 09:04:11 pasglop kernel: [   59.147379] scsi 6:0:0:1: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
Oct 11 09:04:11 pasglop kernel: [   59.169383] sr1: scsi-1 drive

At which point nothing happens for a while (and no serial stuff shows up).

If I yank the device, I then see:

Oct 11 09:05:28 pasglop kernel: [   59.169494] sr 6:0:0:0: Attached scsi CD-ROM sr1
Oct 11 09:05:28 pasglop kernel: [   59.169563] sr 6:0:0:0: Attached scsi generic sg2 type 5
Oct 11 09:05:28 pasglop kernel: [   59.169668] sd 6:0:0:1: Attached scsi generic sg3 type 0
Oct 11 09:05:28 pasglop kernel: [   59.227809] sd 6:0:0:1: [sdb] Attached SCSI removable disk
Oct 11 09:05:28 pasglop kernel: [   71.048322] ISO 9660 Extensions: Microsoft Joliet Level 1
Oct 11 09:05:28 pasglop kernel: [   71.057316] ISOFS: changing to secondary root
Oct 11 09:05:28 pasglop kernel: [  128.369159] usb 4-1: USB disconnect, address 3
Oct 11 09:05:28 pasglop kernel: [  128.429675] scsi 6:0:0:0: rejecting I/O to dead device

However, if I put it back in later on ... it works. The storage shows up
and the modem too.

Weird. I'll have to reboot to try to reproduce with usbmon logging.

Cheers,
Ben.


