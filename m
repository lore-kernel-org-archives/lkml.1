Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXKZWT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXKZWT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbXKZWS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:18:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143AbXKZWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:18:56 -0500
Date: Mon, 26 Nov 2007 14:18:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: lucy@keyspan.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
Message-Id: <20071126141852.a609cdb6.akpm@linux-foundation.org>
In-Reply-To: <20071118131130.GA3991@gollum.tnic>
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
	<20071118131130.GA3991@gollum.tnic>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 14:11:30 +0100
Borislav Petkov <bbpetkov@yahoo.de> wrote:

> On Thu, Nov 15, 2007 at 01:10:16PM -0800, Lucy McCoy wrote:
>  
> > static int keyspan_open (struct usb_serial_port *port, struct file *filp)
> > {
> > 	struct keyspan_port_private 	*p_priv;
> > 	struct keyspan_serial_private 	*s_priv;
> > 	struct usb_serial 		*serial = port->serial;
> > 	const struct keyspan_device_details	*d_details;
> > 	int				i, err;
> > 	struct urb			*urb;
> > 	
> > 	s_priv = usb_get_serial_data(serial);
> > 	p_priv = usb_get_serial_port_data(port);
> > 	d_details = p_priv->device_details;
> > 	
> > 	dbg("%s - port%d.", __FUNCTION__, port->number); 
> > 
> > 	/* Set some sane defaults */
> > 	p_priv->rts_state = 1;
> > 	p_priv->dtr_state = 1;
> > 	p_priv->baud = 9600;
> > 
> > 	/* set CTS/RTS handshake etc. */
> > 	p_priv->cflag = CS8;   /* 8/N/1  */
> > 	p_priv->flow_control = flow_none;
> > 
> > 	/* force baud and lcr to be set on open */
> > 	p_priv->old_baud = 0;
> > 	p_priv->old_cflag = 0;
> > 
> > 	p_priv->out_flip = 0;
> > 	p_priv->in_flip = 0;
> > 
> > 	/* Reset low level data toggle and start reading from endpoints */
> > 	for (i = 0; i < 2; i++) {
> > 		if ((urb = p_priv->in_urbs[i]) == NULL)
> > 			continue;
> > 		urb->dev = serial->dev;
> > 
> > 		/* make sure endpoint data toggle is synchronized with the device */
> > 		
> > 		usb_clear_halt(urb->dev, urb->pipe);
> > 
> > 		if ((err = usb_submit_urb(urb, GFP_KERNEL)) != 0) {
> > 			dbg("%s - submit urb %d failed (%d)", __FUNCTION__, i, err);
> > 		}
> > 	}
> > 
> > 	/* Reset low level data toggle on out endpoints */
> > 	for (i = 0; i < 2; i++) {
> > 		if ((urb = p_priv->out_urbs[i]) == NULL)
> > 			continue;
> > 		urb->dev = serial->dev;
> > 		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), usb_pipeout(urb->pipe), 0); */
> > 	}
> > 
> > 	keyspan_send_setup(port, 1);
> > 	//mdelay(100);
> > 	//keyspan_set_termios(port, NULL);
> > 
> > 	return (0);
> > }
> > 
> 
> yes, after testing this i can confirm that this one fixes the NULL ptr
> problem here so you might want to submit a proper patch to Greg.

I'll merge revert-keyspan-init-termios-properly.patch soon, but afaik we
are still awaiting the real fix for this problem?  
