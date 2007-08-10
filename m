Return-Path: <linux-kernel-owner+w=401wt.eu-S936442AbXHJUbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936442AbXHJUbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbXHJUay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:30:54 -0400
Received: from mailhub.lawrence.edu ([143.44.0.14]:54795 "EHLO lawrence.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759569AbXHJUax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:30:53 -0400
Message-ID: <46BCCADD.1040501@gmail.com>
Date: Fri, 10 Aug 2007 16:30:21 -0400
From: Dan Zwell <dzwell@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: USB hard disk broken
References: <Pine.LNX.4.44L0.0708101010170.3722-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708101010170.3722-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
>> [  126.512815] usb 1-1: usb auto-resume
>> [  126.543447] uhci_hcd 0000:00:1f.2: port 1 portsc 00a5,01
>> [  126.559426] usb 1-1: finish resume
>> [  126.561435] usb 1-1: gone after usb resume? status -19
>> [  126.561445] usb 1-1: can't resume, status -19
>> [  126.561451] hub 1-0:1.0: logical disconnect on port 1
>> [  126.562486] sd 5:0:0:0: [sdb] Result: hostbyte=DID_ERROR 
>> driverbyte=DRIVER_OK,SUGGEST_OK
> 
> This suggests a bug in the device's firmware, probably it sends a 
> 1-byte Device-Status reply instead of a 2-byte reply as required by the 
> USB spec.  You could find out for certain by using usbmon.
> 
> But if that is indeed the problem, the patch below should help.  I've 
> seen it before; perhaps we should adopt this workaround permanently.
> 
>> Relevant info:
>> -obviously, I'm using uhci
>> -the drive is SATA, connected to USB with a SATA/IDE to USB adapter
>> -this problem does not occur with a USB flash drive
>> -reverting the commit that introduced auto-suspend prevents this error.
> 
> If necessary you could disable autosuspend for your drive.  But first 
> test this patch.
> 
> Alan Stern
> 
> 
> 
> Index: 2.6.23-rc1/drivers/usb/core/hub.c
> ===================================================================
> --- 2.6.23-rc1.orig/drivers/usb/core/hub.c
> +++ 2.6.23-rc1/drivers/usb/core/hub.c
> @@ -1644,9 +1644,10 @@ static int finish_port_resume(struct usb
>  	 * and device drivers will know about any resume quirks.
>  	 */
>  	if (status == 0) {
> +		devstatus = 0;
>  		status = usb_get_status(udev, USB_RECIP_DEVICE, 0, &devstatus);
>  		if (status >= 0)
> -			status = (status == 2 ? 0 : -ENODEV);
> +			status = (status > 0 ? 0 : -ENODEV);
>  	}
>  
>  	if (status) {
> 
> 

Alan,

Yes, that patch worked, and dmesg now shows the device auto-suspending 
and resuming every few seconds. Thanks a lot. I hope you do merge this 
patch or a workaround like it.

Dan
