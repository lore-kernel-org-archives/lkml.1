Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYDBQsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYDBQsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYDBQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:48:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51609 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753503AbYDBQsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:48:37 -0400
Date: Wed, 2 Apr 2008 12:48:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: David Brownell <david-b@pacbell.net>, <pavel@suse.cz>, <oliver@neukum.org>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jikos@suse.cz>, <gregkh@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
In-Reply-To: <47F3B235.4000103@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0804021244230.5042-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Mark Lord wrote:

> Yup, that does indeed cure it.
> Here's a patch, in case you didn't already generate one:
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> --- rc8/drivers/usb/host/ehci-hcd.c	2008-03-11 11:18:40.000000000 -0400
> +++ linux/drivers/usb/host/ehci-hcd.c	2008-04-02 12:16:40.000000000 -0400
> @@ -289,9 +289,7 @@
>  	 * (a) SMP races against real IAA firing and retriggering, and
>  	 * (b) clean HC shutdown, when IAA watchdog was pending.
>  	 */
> -	if (ehci->reclaim
> -			&& !timer_pending(&ehci->iaa_watchdog)
> -			&& HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
> +	if (ehci->reclaim && !timer_pending(&ehci->iaa_watchdog)) {
>  		u32 cmd, status;
>  
>  		/* If we get here, IAA is *REALLY* late.  It's barely

Okay, I'm puzzled.  How could this make any difference?  
ehci_bus_suspend() calls end_unlink_async() anyway, whenever reclaim is 
set.

Is the real problem that it does so before calling ehci_work() instead 
of after calling ehci_halt()?

Mark, if you want to experiment some more, try reverting your patch 
above and moving:

	if (ehci->reclaim)
		end_unlink_async(ehci);

in ehci-hub.c:ehci_bus_suspend() to just after the line saying:

	hcd->state = HC_STATE_SUSPENDED;

Alan Stern

