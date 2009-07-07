Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZGGOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZGGOc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZGGOcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:32:51 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:37996 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbZGGOcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:32:50 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 09:32:44 -0500
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <200907051720.45819.lkml@morethan.org> <alpine.LRH.2.00.0907071111210.27150@twin.jikos.cz> <200907071608.11050.oliver@neukum.org>
In-Reply-To: <200907071608.11050.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907070932.47441.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Oliver Neukum wrote:
> Am Dienstag, 7. Juli 2009 11:13:01 schrieb Jiri Kosina:
> > [ adding linux-usb to CC ]
> >
> > On Sun, 5 Jul 2009, Michael S. Zick wrote:
> > > Anyone with suggestions about this one?
> 
> Looks like we should test for presence before we switch off
> autosuspend for khubd. Please test this diagnostic patch if this is
> repeatable.
> 

Super!  Will give it a try in todays build/testing and get back.

Note: If I understand the directions with this debug_vmalloc option,
this dump was caused by reference to a vmalloc'd page that had since
been freed.  I have a copy of the dmesg at boot and the /sys/kernel/debug
list of PTE entries - - if that would help to know what cr2=0..50 was
pointing at.

Mike
> 	Regards
> 		Oliver
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 2af3b4f..c5b3929 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -371,11 +371,16 @@ static void kick_khubd(struct usb_hub *hub)
>  {
>  	unsigned long	flags;
>  
> -	/* Suppress autosuspend until khubd runs */
> -	to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
> +	if (!hub) {
> +		BUG();
> +		return;
> +	}
>  
>  	spin_lock_irqsave(&hub_event_lock, flags);
>  	if (!hub->disconnected && list_empty(&hub->event_list)) {
> +		/* Suppress autosuspend until khubd runs */
> +		to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
> +
>  		list_add_tail(&hub->event_list, &hub_event_list);
>  		wake_up(&khubd_wait);
>  	}
> @@ -384,6 +389,11 @@ static void kick_khubd(struct usb_hub *hub)
>  
>  void usb_kick_khubd(struct usb_device *hdev)
>  {
> +	if (!hdev) {
> +		BUG();
> +		return;
> +	}
> +
>  	/* FIXME: What if hdev isn't bound to the hub driver? */
>  	kick_khubd(hdev_to_hub(hdev));
>  }
> 
> 
> 


