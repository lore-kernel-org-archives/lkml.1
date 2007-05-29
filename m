Return-Path: <linux-kernel-owner+w=401wt.eu-S1763042AbXE2Rhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042AbXE2Rhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbXE2Rh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:37:26 -0400
Received: from rtr.ca ([64.26.128.89]:3148 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbXE2RhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:37:24 -0400
Message-ID: <465C64D1.3030604@rtr.ca>
Date: Tue, 29 May 2007 13:37:21 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org> <465C608E.3040303@rtr.ca>
In-Reply-To: <465C608E.3040303@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>..
> 7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend 
> workqueue thread freezable
> ef7f6c7084b333c7524dcd297e0578d43733a2a2 USB: more autosuspend timer stuff
> 
> I yanked them both, as they appeared to be releated based on the titles.
> Reverting this pair of commits fixes the USB suspend/resume regression.

Okay, just to make it trivial,
I've narrowed it down to only this commit from Alan Stern:

7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend workqueue thread freezable
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> Date: Tue, 22 May 2007 13:38:39 +0000 (-0400)
> Subject: USB: make the autosuspend workqueue thread freezable
> 
> USB: make the autosuspend workqueue thread freezable
> 
> This patch (as881b) makes the ksuspend_usb_wq workqueue freezable.  We
> don't want a rogue workqueue thread running around, unexpectedly
> suspending or resuming USB devices in the middle of a system sleep
> transition.
> 
> This fixes Bugzilla #8498.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> 
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index 18ddc5e..80627b6 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -205,7 +205,11 @@ struct device_type usb_device_type = {
>  
>  static int ksuspend_usb_init(void)
>  {
> -	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
> +	/* This workqueue is supposed to be both freezable and
> +	 * singlethreaded.  Its job doesn't justify running on more
> +	 * than one CPU.
> +	 */
> +	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
>  	if (!ksuspend_usb_wq)
>  		return -ENOMEM;
>  	return 0;
> 
