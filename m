Return-Path: <linux-kernel-owner+w=401wt.eu-S935482AbYEUNdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935482AbYEUNdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933095AbYEUNdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:33:07 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60451 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761986AbYEUNdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:33:04 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
Date: Wed, 21 May 2008 15:32:59 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz> <200805211521.01435.oliver@neukum.org> <Pine.LNX.4.64.0805211524130.6718@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0805211524130.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211533.00221.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 15:27:50 schrieb Jiri Kosina:
> On Wed, 21 May 2008, Oliver Neukum wrote:
> 
> > > hcd_urb_list_lock is used for synchronization between IRQ and non-IRQ 
> > > contexts, so the non-IRQ context has to disable IRQs in order to prevent 
> > > deadlocking with IRQ context.
> > Which non-irq context is that?
> 
> One example -- assume usb_submit_urb() called from non-IRQ context. Then
> 
> usb_hcd_submit_urb() -> rh_urb_enqueue() -> rh_queue_status() -> 
> usb_hcd_link_urb_to_ep().
> 

This turns out not to be the case. Interrupts are disabled.

static int rh_queue_status (struct usb_hcd *hcd, struct urb *urb)
{
	int		retval;
	unsigned long	flags;
	int		len = 1 + (urb->dev->maxchild / 8);

	spin_lock_irqsave (&hcd_root_hub_lock, flags);
	if (hcd->status_urb || urb->transfer_buffer_length < len) {
		dev_dbg (hcd->self.controller, "not queuing rh status urb\n");
		retval = -EINVAL;
		goto done;
	}

	retval = usb_hcd_link_urb_to_ep(hcd, urb);

I'll investigate.

	Regards
		Oliver
