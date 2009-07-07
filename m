Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZGGV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZGGV2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZGGV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:28:12 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47889 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZGGV2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WlG6YFQimbuilGHlGHkzzCdJ6apDaihX9b6FpXplB3OUkwkWQUeO62X5KCgqnnECJy
         gZzv3nx2ObazENnzQ0P5XAZK+4ZXrXzHY8YoeSS/kbpElUGggLlwUJrk6fZslPXSTHVy
         /iUuhotMWxSwR66HCWq5Qt8cbbfR9GV1IbYOY=
Date: Tue, 7 Jul 2009 23:26:40 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: 2.6.31-rc2 warning in drivers/usb/host/ehci-hcd.c
Message-ID: <20090707212640.GA11178@Pilar.aei.mpg.de>
References: <20090707182903.GA12101@Pilar.aei.mpg.de> <Pine.LNX.4.44L0.0907071554150.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0907071554150.8221-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  7.Jul'09 at 15:58:24 -0400, Alan Stern wrote:
> > PS: I don't know if it is related, but I can't connect anymore
> > after s2ram. 'draknetcenter' says that /dev/ttyUSB1 could not
> > be openned (but I need to make more tests to provide more info)...
> 
> That's a separate issue.  We can explore it in greater depth if you 
> want.
> 
> For now, here's a patch to fix the driver.  I don't know why the 
> usb_clear_halt call was in there; it doesn't appear to serve any useful 
> purpose.  Let me know how well the patch works.

The patch works fine and the warning is gone now. Consider it tested.

Furthermore it also fixed somehow the non-working state
after s2ram! I suspended to RAM while it was connected and
it resumed just fine, no warnings and it was still connected.

Thank you very much for your fix^2!

> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/usb/serial/option.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/serial/option.c
> +++ usb-2.6/drivers/usb/serial/option.c
> @@ -931,23 +931,11 @@ static int option_open(struct tty_struct
>  
>  	dbg("%s", __func__);
>  
> -	/* Reset low level data toggle and start reading from endpoints */
> +	/* Start reading from the IN endpoint */
>  	for (i = 0; i < N_IN_URB; i++) {
>  		urb = portdata->in_urbs[i];
>  		if (!urb)
>  			continue;
> -		if (urb->dev != serial->dev) {
> -			dbg("%s: dev %p != %p", __func__,
> -				urb->dev, serial->dev);
> -			continue;
> -		}
> -
> -		/*
> -		 * make sure endpoint data toggle is synchronized with the
> -		 * device
> -		 */
> -		usb_clear_halt(urb->dev, urb->pipe);
> -
>  		err = usb_submit_urb(urb, GFP_KERNEL);
>  		if (err) {
>  			dbg("%s: submit urb %d failed (%d) %d",
> @@ -956,16 +944,6 @@ static int option_open(struct tty_struct
>  		}
>  	}
>  
> -	/* Reset low level data toggle on out endpoints */
> -	for (i = 0; i < N_OUT_URB; i++) {
> -		urb = portdata->out_urbs[i];
> -		if (!urb)
> -			continue;
> -		urb->dev = serial->dev;
> -		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe),
> -				usb_pipeout(urb->pipe), 0); */
> -	}
> -
>  	option_send_setup(port);
>  
>  	return 0;
