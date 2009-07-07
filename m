Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZGGPYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZGGPYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZGGPYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:24:01 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:32833 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbZGGPYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:24:00 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 10:23:21 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071105561.4175-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907071105561.4175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071023.24243.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Alan Stern wrote:
> On Tue, 7 Jul 2009, Oliver Neukum wrote:
> 
> > Am Dienstag, 7. Juli 2009 11:13:01 schrieb Jiri Kosina:
> > > [ adding linux-usb to CC ]
> > >
> > > On Sun, 5 Jul 2009, Michael S. Zick wrote:
> > > > Anyone with suggestions about this one?
> > 
> > Looks like we should test for presence before we switch off
> > autosuspend for khubd. Please test this diagnostic patch if this is
> > repeatable.
> 
> That patch won't fix the problem.  This issue is not that hdev is NULL; 
> the problem is that the hub driver isn't bound to hdev and as a result, 
> the hdev_to_hub routine fails.
> 
> This patch may work better.
> 

Got it.
Anything that gives me something other than a dead machine
with a glowing power-on light is forward progress.

Will give this patch a try today and report back.

At the moment am running the machine without either USB driver loaded.
Just to see if they are contributing to the problems.

Mike
> Alan Stern
> 
> 
> Index: usb-2.6/drivers/usb/core/hub.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/core/hub.c
> +++ usb-2.6/drivers/usb/core/hub.c
> @@ -163,8 +163,10 @@ static inline char *portspeed(int portst
>  }
>  
>  /* Note that hdev or one of its children must be locked! */
> -static inline struct usb_hub *hdev_to_hub(struct usb_device *hdev)
> +static struct usb_hub *hdev_to_hub(struct usb_device *hdev)
>  {
> +	if (!hdev || !hdev->actconfig)
> +		return NULL;
>  	return usb_get_intfdata(hdev->actconfig->interface[0]);
>  }
>  
> @@ -385,8 +387,10 @@ static void kick_khubd(struct usb_hub *h
>  
>  void usb_kick_khubd(struct usb_device *hdev)
>  {
> -	/* FIXME: What if hdev isn't bound to the hub driver? */
> -	kick_khubd(hdev_to_hub(hdev));
> +	struct usb_hub *hub = hdev_to_hub(hdev);
> +
> +	if (hub)
> +		kick_khubd(hub);
>  }
>  
>  
> 
> 
> 


