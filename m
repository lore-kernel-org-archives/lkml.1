Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYDAB6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYDAB6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYDAB6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:58:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2154 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751682AbYDAB6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:58:32 -0400
Date: Mon, 31 Mar 2008 21:58:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sergey Dolgov <solkaa@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <20080401011837.GA5385@slk.laptop>
Message-ID: <Pine.LNX.4.44L0.0803312143180.14330-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Sergey Dolgov wrote:

> On Mon, Mar 31, 2008 at 02:32:12AM +0400, Sergey Dolgov wrote:
> > On Sun, Mar 30, 2008 at 02:59:49PM -0400, Alan Stern wrote:
> > > On Sun, 30 Mar 2008, Sergey Dolgov wrote:
> > > 
> > > Can you build both 2.6.24.4 and 2.6.25-rc7 with
> > > CONFIG_USB_STORAGE_DEBUG enabled, and post the dmesg logs from both
> > > kernels showing what happens when the SDHC card is probed during boot?
> > > Comparing the two logs should indicate where the crucial difference 
> > > lies.
> > 
> > The dmesg output for 2.6.25-rc7 with USB storage debugging enabled is
> > attached. I hope to produce the same for 2.6.24.4 on Monday.
> > 
> 
> Here goes...

The difference is interesting.  Here's the version that works:

[   23.902571] usb-storage: Command READ_10 (10 bytes)
[   23.902575] usb-storage:  28 00 00 ee f3 f8 00 00 08 00
[   23.902591] usb-storage: Bulk Command S 0x43425355 T 0x16 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.902598] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.902704] usb-storage: Status code 0; transferred 31/31
[   23.902709] usb-storage: -- transfer complete
[   23.902713] usb-storage: Bulk command transfer result=0
[   23.902720] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.903337] usb-storage: Status code 0; transferred 4096/4096
[   23.903343] usb-storage: -- transfer complete
[   23.903349] usb-storage: Bulk data transfer result 0x0
[   23.903354] usb-storage: Attempting to get CSW...
[   23.903359] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.903448] usb-storage: Status code 0; transferred 13/13
[   23.903453] usb-storage: -- transfer complete
[   23.903457] usb-storage: Bulk status result = 0
[   23.903463] usb-storage: Bulk Status S 0x53425355 T 0x16 R 0 Stat 0x0
[   23.903469] usb-storage: scsi cmd done, result=0x0

And here's the version that fails:

[   10.760357] usb-storage: Command READ_10 (10 bytes)
[   10.760361] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.760376] usb-storage: Bulk Command S 0x43425355 T 0x16 L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.760384] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.760466] usb-storage: Status code 0; transferred 31/31
[   10.760471] usb-storage: -- transfer complete
[   10.760475] usb-storage: Bulk command transfer result=0
[   10.760482] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.761089] usb-storage: Status code 0; transferred 3584/3584
[   10.761094] usb-storage: -- transfer complete
[   10.761099] usb-storage: Bulk data transfer result 0x0
[   10.761104] usb-storage: Attempting to get CSW...
[   10.761109] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.761214] usb-storage: Status code -32; transferred 0/13
[   10.761220] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.761231] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.761337] usb-storage: usb_stor_clear_halt: result = 0
[   10.761342] usb-storage: Attempting to get CSW (2nd try)...
[   10.761348] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.761461] usb-storage: Status code 0; transferred 13/13
[   10.761466] usb-storage: -- transfer complete
[   10.761470] usb-storage: Bulk status result = 0
[   10.761477] usb-storage: Bulk Status S 0x53425355 T 0x16 R 0 Stat 0x1
[   10.761483] usb-storage: -- transport indicates command failure

The difference is that the first reads 8 sectors starting 8 sectors 
from the end of the device, whereas the second reads only 7 sectors 
starting from the same place.  There's no reason this should fail; the 
device reports sense key = 4, ASC = 0x11, ASCQ = 0, which means 
Hardware error, Unrecoverable Read Error.  Of course that is nonsense.

Nevertheless, it's clear that the problem has nothing to do with the 
USB stack.  The real source of the problem lies in the device itself, 
for reporting a bogus error when in fact nothing went wrong.  That may 
also explain why you don't always see the problem -- sometimes the 
device works the way it ought to.

It's being triggered by a change in some other part of the system.  I
don't know who is responsible for those reads at the end of the device.
It could be the partition detection code (EFI GUID does that sort of
thing), or it could even be a userspace program (part of udev perhaps; 
I think /lib/udev/vol_id reads strange parts of a disk).

Alan Stern

