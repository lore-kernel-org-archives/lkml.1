Return-Path: <linux-kernel-owner+w=401wt.eu-S1765569AbXKOVgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765569AbXKOVgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbXKOVfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:35:30 -0500
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:38780 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbXKOVf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:35:28 -0500
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 16:35:28 EST
Date: Thu, 15 Nov 2007 13:10:16 -0800 (PST)
Subject: Re: [PATCH] keyspan: init termios properly
From: "Lucy McCoy" <lucy@keyspan.com>
To: bbpetkov@yahoo.de
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Reply-To: lucy@keyspan.com
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: 1
Message-ID: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
X-Mailer: webmail6.5.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Actually the 19HS is the usa90 so it is included in the switch but
that isn't a problem.

I'm not familiar with the termios stuff on Linux so can you take a look
at the following modified code to see if this solves your NULL ptr problem?

Also,....

Does cflag need to be set to anything other than CS8?  
Is keyspan_open_port() always followed by a keyspan_set_termios()?

Thanks,

Lucy


static int keyspan_open (struct usb_serial_port *port, struct file *filp)
{
	struct keyspan_port_private 	*p_priv;
	struct keyspan_serial_private 	*s_priv;
	struct usb_serial 		*serial = port->serial;
	const struct keyspan_device_details	*d_details;
	int				i, err;
	struct urb			*urb;
	
	s_priv = usb_get_serial_data(serial);
	p_priv = usb_get_serial_port_data(port);
	d_details = p_priv->device_details;
	
	dbg("%s - port%d.", __FUNCTION__, port->number); 

	/* Set some sane defaults */
	p_priv->rts_state = 1;
	p_priv->dtr_state = 1;
	p_priv->baud = 9600;

	/* set CTS/RTS handshake etc. */
	p_priv->cflag = CS8;   /* 8/N/1  */
	p_priv->flow_control = flow_none;

	/* force baud and lcr to be set on open */
	p_priv->old_baud = 0;
	p_priv->old_cflag = 0;

	p_priv->out_flip = 0;
	p_priv->in_flip = 0;

	/* Reset low level data toggle and start reading from endpoints */
	for (i = 0; i < 2; i++) {
		if ((urb = p_priv->in_urbs[i]) == NULL)
			continue;
		urb->dev = serial->dev;

		/* make sure endpoint data toggle is synchronized with the device */
		
		usb_clear_halt(urb->dev, urb->pipe);

		if ((err = usb_submit_urb(urb, GFP_KERNEL)) != 0) {
			dbg("%s - submit urb %d failed (%d)", __FUNCTION__, i, err);
		}
	}

	/* Reset low level data toggle on out endpoints */
	for (i = 0; i < 2; i++) {
		if ((urb = p_priv->out_urbs[i]) == NULL)
			continue;
		urb->dev = serial->dev;
		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), usb_pipeout(urb->pipe), 0); */
	}

	keyspan_send_setup(port, 1);
	//mdelay(100);
	//keyspan_set_termios(port, NULL);

	return (0);
}


Lucy McCoy
lucy@keyspan.com

-----Original Message-----
From: Borislav Petkov <bbpetkov@yahoo.de>
Sent: Thursday, November 15, 2007 12:40pm
To: Lucy McCoy <lucy@keyspan.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] keyspan: init termios properly

On Thu, Nov 15, 2007 at 09:49:22AM -0800, Lucy McCoy wrote:
> Greg & Boris,
>
> I've been out of town and just saw this.
>
> This patch will work with the 19HS but WILL BREAK all other Keyspan
> adapters.  It will take me a few days to get to looking at a correct fix but
> that keyspan_send_setup(port, 1) (and the '1' is the important part) must 
> happen once
> when the port is first opened.  The cflag can just be set to whatever the 
> normal default
> is for your serial environment.  What are the defaults?

Hi Lucy,

sorry but i don't have the other usb-to-serial models to test them too, i guess
you're in the position to do that :) Well, from what i've unterstood from
reading the code, you can still do the keyspan_send_setup() call since the
switch-case-statement is not handling the 19s series so while this call won't have any
influence on them, it'll still init the others properly, no? Anyway, you can send me your
fix for testing.

Thanks.

-- 
Regards/Gruß,
    Boris.


