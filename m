Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZEMC0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZEMC0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZEMCZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:25:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38495 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752086AbZEMCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:25:56 -0400
Date: Tue, 12 May 2009 22:25:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>, <oliver@neukum.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb hcd: poll hcd device to force writes
In-Reply-To: <1242167540-23585-2-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0905122218180.7989-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Jason Wessel wrote:

> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue in order to initiate the bulk write call backs.  This
> only happens if the device is a usb serial console device that sets
> the max_in_flight_urbs in the serial device structure.

> +void
> +usb_hcd_poll_urb_irq(struct urb *urb)
> +{
> +	struct usb_hcd *hcd;
> +
> +	if (!urb)
> +		return;

Is this test really needed?  The routine is called from only one spot, 
after all.  It seems more likely that urb will point to deallocated 
memory than that it will be NULL.  Do you protect against this in 
usb_do_console_write?

Maybe you should pass a pointer to a usb_bus structure rather than an
URB.  Then none of these issues would arise.

> +
> +	hcd = bus_to_hcd(urb->dev->bus);
> +	if (hcd)
> +		usb_hcd_irq(0, hcd);

This test too looks strange, since it can never fail.  (See the 
definition of bus_to_hcd to find out why...)

Alan Stern


