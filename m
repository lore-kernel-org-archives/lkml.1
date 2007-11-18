Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbXKRRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbXKRRTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXKRRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:19:12 -0500
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:47999 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751058AbXKRRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:19:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=FDWTN9hw0nl3oD5eJ7LiBsK1NXJZsZobv3rpKazMbDro/kHb4/Isx8eJZwO5A57vSgHaeme6VIdsnp3CBhd8JfYOz1MslAD8PclvyiyCtdRGk6OKTNtplArrVKTyzmWmaFEAhPAyhF5d7suFrK0BXclxyi/dM0mqh1Mk/UynALo=  ;
X-YMail-OSG: 3Fge69YVM1kxVDi0PHI6JFRLYMqTEV2QVKvMReR13vND.2y5P8Sv11xGVfbfQ7Nq9NjA3LLR1Q--
Date: Sun, 18 Nov 2007 14:11:30 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Lucy McCoy <lucy@keyspan.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071118131130.GA3991@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:10:16PM -0800, Lucy McCoy wrote:
 
> static int keyspan_open (struct usb_serial_port *port, struct file *filp)
> {
> 	struct keyspan_port_private 	*p_priv;
> 	struct keyspan_serial_private 	*s_priv;
> 	struct usb_serial 		*serial = port->serial;
> 	const struct keyspan_device_details	*d_details;
> 	int				i, err;
> 	struct urb			*urb;
> 	
> 	s_priv = usb_get_serial_data(serial);
> 	p_priv = usb_get_serial_port_data(port);
> 	d_details = p_priv->device_details;
> 	
> 	dbg("%s - port%d.", __FUNCTION__, port->number); 
> 
> 	/* Set some sane defaults */
> 	p_priv->rts_state = 1;
> 	p_priv->dtr_state = 1;
> 	p_priv->baud = 9600;
> 
> 	/* set CTS/RTS handshake etc. */
> 	p_priv->cflag = CS8;   /* 8/N/1  */
> 	p_priv->flow_control = flow_none;
> 
> 	/* force baud and lcr to be set on open */
> 	p_priv->old_baud = 0;
> 	p_priv->old_cflag = 0;
> 
> 	p_priv->out_flip = 0;
> 	p_priv->in_flip = 0;
> 
> 	/* Reset low level data toggle and start reading from endpoints */
> 	for (i = 0; i < 2; i++) {
> 		if ((urb = p_priv->in_urbs[i]) == NULL)
> 			continue;
> 		urb->dev = serial->dev;
> 
> 		/* make sure endpoint data toggle is synchronized with the device */
> 		
> 		usb_clear_halt(urb->dev, urb->pipe);
> 
> 		if ((err = usb_submit_urb(urb, GFP_KERNEL)) != 0) {
> 			dbg("%s - submit urb %d failed (%d)", __FUNCTION__, i, err);
> 		}
> 	}
> 
> 	/* Reset low level data toggle on out endpoints */
> 	for (i = 0; i < 2; i++) {
> 		if ((urb = p_priv->out_urbs[i]) == NULL)
> 			continue;
> 		urb->dev = serial->dev;
> 		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), usb_pipeout(urb->pipe), 0); */
> 	}
> 
> 	keyspan_send_setup(port, 1);
> 	//mdelay(100);
> 	//keyspan_set_termios(port, NULL);
> 
> 	return (0);
> }
> 

yes, after testing this i can confirm that this one fixes the NULL ptr
problem here so you might want to submit a proper patch to Greg.

-- 
Regards/Gruﬂ,
    Boris.
