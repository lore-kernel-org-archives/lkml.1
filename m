Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZG1MKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZG1MKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZG1MKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:10:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54136 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZG1MKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:10:12 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: manual merge of the ttydev tree with the usb.current tree
Date: Tue, 28 Jul 2009 14:10:40 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au> <20090728112608.09a494e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090728112608.09a494e0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281410.41449.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 28. Juli 2009 12:26:08 schrieb Alan Cox:
> On Tue, 28 Jul 2009 14:01:10 +1000
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Alan,
> >
> > Today's linux-next merge of the ttydev tree got a conflict in
> > drivers/usb/serial/usb-serial.c between commit
> > a00b8d98aca97bfb6fa983f41dae25b424058592 ("USB: fix usage count in usb
> > serial generic open regarding autoresume") from the usb.current tree	
>
> That looks wrong. The extra fiddling with port.count looks both unsafe
> and incorrect. I've never seen the "autoresume" patch referred to so I've
> no idea what it is trying to do

The problem is subdrivers looking at port->count to determine
whether URBs have to be resubmitted. That must happen once.
Therefore if serial_open() needs to do it itself it must make sure
resume() runs without port->count already incremented.

As serial_open() takes the lock, resume() must not do so.
If however, remote wakeup is used a lock must be taken
to look at port->count reliably. As this is impossible, the patch
implementing use of remote wakeup for the option driver
implements a private flag for opened ports.

This code from option_resume():

for (i = 0; i < serial->num_ports; i++) {
		/* walk all ports */
		port = serial->port[i];
		portdata = usb_get_serial_port_data(port);
		mutex_lock(&port->mutex);

		/* skip closed ports */
		if (!port->port.count) {
			mutex_unlock(&port->mutex);
			continue;
		}

		for (j = 0; j < N_IN_URB; j++) {
			urb = portdata->in_urbs[j];
			err = usb_submit_urb(urb, GFP_NOIO);
			if (err < 0) {
				mutex_unlock(&port->mutex);
				err("%s: Error %d for bulk URB %d",
					 __func__, err, i);
				return err;
			}
		}
		mutex_unlock(&port->mutex);

must not take the port->mutex.

Unfortunately I have no access to my trees today and yesterday.

	Regards
		Oliver

