Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZJKOqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZJKOqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZJKOqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:46:11 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42949 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754259AbZJKOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:46:10 -0400
Date: Sun, 11 Oct 2009 10:45:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
In-Reply-To: <1255213021.2192.9.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910111038310.25068-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009, Benjamin Herrenschmidt wrote:

> On Sun, 2009-10-11 at 08:20 +1100, Benjamin Herrenschmidt wrote:
> 
> > Yes, that works, you can see the ttyUSBx ports showing up. It looks like
> > it may just be the resets coming from usb-storage that are breaking
> > things.
> 
> Ok so I did a quick hack to usb-storage, basically put the block that
> tests for the response size and sets USB_FL_SANE_SENSE into an #if 0 :

> Now, the result in the dmesg log is :
> 
> Oct 11 09:04:05 pasglop kernel: [   52.916100] usb 4-1: new full speed USB device using uhci_hcd and address 2
> Oct 11 09:04:05 pasglop kernel: [   53.076402] usb 4-1: configuration #1 chosen from 1 choice
> Oct 11 09:04:06 pasglop kernel: [   53.104090] Initializing USB Mass Storage driver...
> Oct 11 09:04:06 pasglop kernel: [   53.105405] scsi2 : SCSI emulation for USB Mass Storage devices
> Oct 11 09:04:06 pasglop kernel: [   53.105585] usbcore: registered new interface driver usb-storage
> Oct 11 09:04:06 pasglop kernel: [   53.105589] USB Mass Storage support registered.
> Oct 11 09:04:06 pasglop kernel: [   53.107164] usb-storage: device found at 2
> Oct 11 09:04:06 pasglop kernel: [   53.107167] usb-storage: waiting for device to settle before scanning
> Oct 11 09:04:06 pasglop kernel: [   53.224104] usb 4-1: USB disconnect, address 2
> Oct 11 09:04:06 pasglop kernel: [   53.960100] usb 4-1: new full speed USB device using uhci_hcd and address 3
> Oct 11 09:04:11 pasglop kernel: [   54.121941] usb 4-1: configuration #1 chosen from 1 choice
> Oct 11 09:04:11 pasglop kernel: [   54.140861] scsi6 : SCSI emulation for USB Mass Storage devices
> Oct 11 09:04:11 pasglop kernel: [   54.143007] usb-storage: device found at 3
> Oct 11 09:04:11 pasglop kernel: [   54.143010] usb-storage: waiting for device to settle before scanning
> Oct 11 09:04:11 pasglop kernel: [   59.141422] usb-storage: device scan complete
> Oct 11 09:04:11 pasglop kernel: [   59.144370] scsi 6:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
> Oct 11 09:04:11 pasglop kernel: [   59.147379] scsi 6:0:0:1: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
> Oct 11 09:04:11 pasglop kernel: [   59.169383] sr1: scsi-1 drive
> 
> At which point nothing happens for a while (and no serial stuff shows up).
> 
> If I yank the device, I then see:
> 
> Oct 11 09:05:28 pasglop kernel: [   59.169494] sr 6:0:0:0: Attached scsi CD-ROM sr1
> Oct 11 09:05:28 pasglop kernel: [   59.169563] sr 6:0:0:0: Attached scsi generic sg2 type 5
> Oct 11 09:05:28 pasglop kernel: [   59.169668] sd 6:0:0:1: Attached scsi generic sg3 type 0
> Oct 11 09:05:28 pasglop kernel: [   59.227809] sd 6:0:0:1: [sdb] Attached SCSI removable disk
> Oct 11 09:05:28 pasglop kernel: [   71.048322] ISO 9660 Extensions: Microsoft Joliet Level 1
> Oct 11 09:05:28 pasglop kernel: [   71.057316] ISOFS: changing to secondary root
> Oct 11 09:05:28 pasglop kernel: [  128.369159] usb 4-1: USB disconnect, address 3
> Oct 11 09:05:28 pasglop kernel: [  128.429675] scsi 6:0:0:0: rejecting I/O to dead device

The printk timestamps indicate that the first four lines above happened
before you unplugged the device.  Maybe the first six.  But evidently
the syslogd process was blocked.

> 
> However, if I put it back in later on ... it works. The storage shows up
> and the modem too.
> 
> Weird. I'll have to reboot to try to reproduce with usbmon logging.

You might have to get a stack trace (Alt-SysRq-T) as well.  It sounds 
like something important got hung up somewhere.  Perhaps the usb-serial 
modules couldn't be loaded for that reason.

Alan Stern

