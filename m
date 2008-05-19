Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYESPSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYESPSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYESPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:18:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52769 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751817AbYESPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:18:36 -0400
Date: Mon, 19 May 2008 11:18:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
In-Reply-To: <483058F1.4020601@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Boaz Harrosh wrote:

> Do you mean this diff below:
> 
> @@ -796,133 +789,133 @@ kernel: usb-storage: *** thread awakened
>  kernel: usb-storage: Command MODE_SENSE (6 bytes)
>  kernel: usb-storage:  1a 00 3f 00 c0 00
>  kernel: usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
>  kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
>  kernel: usb-storage: Status code 0; transferred 31/31
>  kernel: usb-storage: -- transfer complete
>  kernel: usb-storage: Bulk command transfer result=0
>  kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
>  kernel: usb-storage: Status code -32; transferred 0/192
>  kernel: usb-storage: clearing endpoint halt for pipe 0xc0008480
>  kernel: usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
>  kernel: usb-storage: usb_stor_clear_halt: result = 0
>  kernel: usb-storage: Bulk data transfer result 0x2
>  kernel: usb-storage: Attempting to get CSW...
>  kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
>  kernel: usb-storage: Status code 0; transferred 13/13
>  kernel: usb-storage: -- transfer complete
>  kernel: usb-storage: Bulk status result = 0
>  kernel: usb-storage: Bulk Status S 0x53425355 T 0x4 R 192 Stat 0x0
>  kernel: usb-storage: scsi cmd done, result=0x0
>  kernel: usb-storage: *** thread sleeping.
> -kernel: sd 2:0:0:0: [sda] Write Protect is off
> -kernel: sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
> +kernel: sd 2:0:0:0: [sda] Write Protect is on
> +kernel: sd 2:0:0:0: [sda] Mode Sense: 09 50 f8 af
>  kernel: sd 2:0:0:0: [sda] Assuming drive cache: write through
>  kernel: usb-storage: queuecommand called
> 
> ("+" is the new kernel and "-" the older one)

That's right.

> It looks like it used to be the same exact return and everything only that at
> old kernel the 4 bytes used to be zero and now they are not.
> 
> So It looks to me that it never used to work (Data was never actually read
> from device) but by luck, the garbage data used to be a better default 
> "Write Protect is off"

Yes, it never worked properly.  But now it fails in a bad way whereas 
before it failed in a benign way.

> I do not think it is legal in scsi to return "Nothing was read" with no
> error condition.

I'm not aware of any part of the spec where it says that.  In any case 
it doesn't matter what the spec says; we ought to be able to drive this 
device even if it isn't compliant with the spec.

> You are probably right that we do not at all check resid
> if status is 0, even though short reads are allowed with out error status
> in some cases, as per command. But this is not the case here here nothing
> was read at all, status must be returned. Or even worse if this command 
> is mandatory by scsi but not supported by some USB devices then it will
> have to be emulated by usb_storage.

The real question is how should we fix the problem.  For the sake of 
argument, let's say that we fix it by changing scsi_mode_sense() -- 
make the routine return 0 if the residue is so large that there isn't 
even a valid header.

But how can this be done?  Should we modify struct scsi_sense_hdr, by 
adding a "residue" field?

Alan Stern

