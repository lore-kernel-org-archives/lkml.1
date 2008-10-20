Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYJTQ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYJTQ0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYJTQ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:26:43 -0400
Received: from cnc.isely.net ([64.81.146.143]:58845 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYJTQ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:26:42 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 12:26:41 EDT
Date: Mon, 20 Oct 2008 11:21:10 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0810201119250.12643@cnc.isely.net>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's already a patch coming up through v4l-dvb that should remove the 
need for the reset completely for the pvrusb2 driver.  The reset had 
been there as "chicken soup" previously - it didn't hurt but its 
utility wasn't really that great at the time.  Now that it is hurting, 
I just removed it.

  -Mike


On Mon, 20 Oct 2008, Alan Stern wrote:

> On Mon, 20 Oct 2008, Justin Piszcz wrote:
> 
> > >> http://home.comcast.net/~jpiszcz/20081019/trace_before_trigger.txt
> > >> http://home.comcast.net/~jpiszcz/20081019/trace_after_trigger.txt
> > >
> > > Your trace is incomplete.  You might need to increase the size of the
> > > kernel log buffer (CONFIG_LOG_BUF_SHIFT) or the size of the buffer used
> > > by dmesg (the -s option).
> > >
> > > Alan Stern
> > >
> > 
> > You're right, I set it to 128 KiB and here is the full log, including the 
> > initial dmesg:
> > 
> > http://home.comcast.net/~jpiszcz/20081019/kern.log
> 
> Okay, I see the problem. It's the same as we saw with the speedtouch
> driver last week: The pvrusb2 driver resets its device but doesn't
> define a pre_reset or a post_reset method.  As a result it gets
> disconnected during the reset, and the recursive call causes it to
> hang.
> 
> This patch should fix the problem.  It's not entirely correct, but it 
> should at least allow the driver to work like it did in 2.6.26.
> 
> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
> ===================================================================
> --- usb-2.6.orig/drivers/media/video/pvrusb2/pvrusb2-main.c
> +++ usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
> @@ -68,6 +68,16 @@ static void pvr_setup_attach(struct pvr2
>  #endif /* CONFIG_VIDEO_PVRUSB2_SYSFS */
>  }
>  
> +static int pvr_pre_reset(struct usb_interface *intf)
> +{
> +	return 0;
> +}
> +
> +static int pvr_post_reset(struct usb_interface *intf)
> +{
> +	return 0;
> +}
> +
>  static int pvr_probe(struct usb_interface *intf,
>  		     const struct usb_device_id *devid)
>  {
> @@ -109,7 +119,9 @@ static struct usb_driver pvr_driver = {
>  	.name =         "pvrusb2",
>  	.id_table =     pvr2_device_table,
>  	.probe =        pvr_probe,
> -	.disconnect =   pvr_disconnect
> +	.disconnect =   pvr_disconnect,
> +	.pre_reset =	pvr_pre_reset,
> +	.post_reset =	pvr_post_reset,
>  };
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
