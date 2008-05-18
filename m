Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYERQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYERQ2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 12:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYERQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:28:10 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19978 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752251AbYERQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:28:08 -0400
Message-ID: <483058F1.4020601@panasas.com>
Date: Sun, 18 May 2008 19:27:29 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
References: <Pine.LNX.4.44L0.0805170933530.22979-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805170933530.22979-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 May 2008 16:27:33.0505 (UTC) FILETIME=[134F9710:01C8B904]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Summary: 2.6.26-rc2 doesn't detect a USB drive's write-protect setting 
> correctly.
> 
> On Sat, 17 May 2008, Maciej Rutecki wrote:
> 
>> 2.6.25.4 (works fine):
>> http://unixy.pl/maciek/download/kernel/2.6.25.4/syslog_debug.txt
>> http://unixy.pl/maciek/download/kernel/2.6.25.4/usbmon.txt
>>
>> 2.6.26-rc2 ("write protect is on" problem; can't mount device):
>> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/syslog_debug.txt
>> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/usbmon.txt
> 
> I'm not sure exactly what changed to cause this regression, but the 
> problem lies in the SCSI layer, not the USB layer.
> 
> The logs show that in response to the 192-byte MODE SENSE command (used
> to read the write-protect status), the device sends back no data, good
> status, and Residue = 192.  The SCSI core ignores the Residue and
> thinks that the old left-over data in the buffer (in this case left
> over from the READ CAPACITY command) actually indicates the
> write-protect status -- which it obviously doesn't.
> 
> Boaz, is scsi_mode_sense() the right place to check for this sort of 
> thing?  It probably should be treated the same as an Illegal Request 
> error.
> 
> Alan Stern
> 

Do you mean this diff below:

@@ -796,133 +789,133 @@ kernel: usb-storage: *** thread awakened
 kernel: usb-storage: Command MODE_SENSE (6 bytes)
 kernel: usb-storage:  1a 00 3f 00 c0 00
 kernel: usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
 kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
 kernel: usb-storage: Status code 0; transferred 31/31
 kernel: usb-storage: -- transfer complete
 kernel: usb-storage: Bulk command transfer result=0
 kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
 kernel: usb-storage: Status code -32; transferred 0/192
 kernel: usb-storage: clearing endpoint halt for pipe 0xc0008480
 kernel: usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
 kernel: usb-storage: usb_stor_clear_halt: result = 0
 kernel: usb-storage: Bulk data transfer result 0x2
 kernel: usb-storage: Attempting to get CSW...
 kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
 kernel: usb-storage: Status code 0; transferred 13/13
 kernel: usb-storage: -- transfer complete
 kernel: usb-storage: Bulk status result = 0
 kernel: usb-storage: Bulk Status S 0x53425355 T 0x4 R 192 Stat 0x0
 kernel: usb-storage: scsi cmd done, result=0x0
 kernel: usb-storage: *** thread sleeping.
-kernel: sd 2:0:0:0: [sda] Write Protect is off
-kernel: sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
+kernel: sd 2:0:0:0: [sda] Write Protect is on
+kernel: sd 2:0:0:0: [sda] Mode Sense: 09 50 f8 af
 kernel: sd 2:0:0:0: [sda] Assuming drive cache: write through
 kernel: usb-storage: queuecommand called

("+" is the new kernel and "-" the older one)

It looks like it used to be the same exact return and everything only that at
old kernel the 4 bytes used to be zero and now they are not.

So It looks to me that it never used to work (Data was never actually read
from device) but by luck, the garbage data used to be a better default 
"Write Protect is off"

I do not think it is legal in scsi to return "Nothing was read" with no
error condition. You are probably right that we do not at all check resid
if status is 0, even though short reads are allowed with out error status
in some cases, as per command. But this is not the case here here nothing
was read at all, status must be returned. Or even worse if this command 
is mandatory by scsi but not supported by some USB devices then it will
have to be emulated by usb_storage.

My $0.017
Boaz
