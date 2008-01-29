Return-Path: <linux-kernel-owner+w=401wt.eu-S1765980AbYA2TKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765980AbYA2TKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYA2TKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:10:39 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30628 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbYA2TKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:10:37 -0500
Message-ID: <479F7A07.8080204@panasas.com>
Date: Tue, 29 Jan 2008 21:09:59 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
In-Reply-To: <20080129183910.GI15220@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2008 19:10:05.0850 (UTC) FILETIME=[8EB8D7A0:01C862AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008 at 20:39 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Jan 29 2008, Jens Axboe wrote:
>> On Tue, Jan 29 2008, Oliver Neukum wrote:
>>> Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
>>>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>>>> On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>>>>>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>>>>>> Greg KH wrote:
>>>  
>>>>>> No difference, still just a lot of resets.
>>>>>>
>>>>> Where you able to figure out which usb storage transport is used?
>>>>>
>>>>> in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
>>>>> functions. I'm not sure if these get stored in sysfs perhaps. This will
>>>>> pinpoint better where to look. Let me research a bit. 
>>>> Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
>>>> transport is 'Bulk'
>>> You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
>>> That should tell the reason for the resets.
>> Sure, I'll do that. Will post the results tonight.
> 
> OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> in the device, waited 10 seconds or so and pulled it out. These are the
> messages.
> 
> It all looks good until the MODE_SENSE command, where it only transfers
> 4 of 192 bytes.
> 
<snip>
> usb-storage: Command MODE_SENSE (6 bytes)
> usb-storage:  1a 00 3f 00 c0 00
> usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
> usb-storage: Status code -121; transferred 4/192
> usb-storage: -- short read transfer
> usb-storage: Bulk data transfer result 0x1
> usb-storage: Attempting to get CSW...
<snip>

I get something similar but better:
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x6 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
usb-storage: Status code -121; transferred 36/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...

So I get 36 bytes, then code goes on into one reset, and every thing is then
fine.

Could you put us out of our mesery and revert that patch:
[SCSI] usb: transport - convert to accessors and !use_sg code path removal
(6d416e6173394defda5933e419e805b696681b7e)

to make sure this is it. I hate to do this to you, but I cannot reproduce the
failure down here. If it works please send a log with the debugs on perhaps
we can compare.

You will need to configure out the CONFIG_USB_STORAG_* they will not compile
you should have only have CONFIG_USB_STORAGE & CONFIG_USB_STORAGE_DEBUG. it should
support your HW.


Thanks Jens
Boaz


