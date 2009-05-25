Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZEYWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZEYWBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZEYWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:01:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:49413 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZEYWBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:01:02 -0400
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0905251116250.23874-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0905251116250.23874-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 08:00:36 +1000
Message-Id: <1243288836.2858.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 11:17 -0400, Alan Stern wrote:
> On Mon, 25 May 2009, Benjamin Herrenschmidt wrote:
> 
> > Found it. Patch below.
> > 
> > usb-serial: Fix crash when sub-driver attach() returns positive value
> > 
> > This fixes a crash in usb-serial that typically happens with keyspan USB
> > devices, though it would happen potentially with anything that returns
> > a positive value from the subdriver's attach() method to indicate that
> > a FW was loaded and the device will disconnect and reconnect.
> > 
> > What happens is that we haven't yet initialized the struct device embedded
> > inside the struct usb_serial_port when we call "exit:" and return
> > from probe().
> > 
> > Later, when we get the disconnect() call, usb_serial_disconnect() tries
> > to do a device_del() and put_device() on all the ports, despite the fact
> > that in this case, the struct device wasn't initialized. This causes the
> > device core to crash (right, it should be more robust).
> 
> Very clever.  Does this simpler patch also fix the problem?

Well, both our patches are bogus in the sense that they will leak
the stuff in the port structure.

The right patch would be I think something like that (typing straight
in the mailer, I can do a "proper" patch later):

> Index: usb-2.6/drivers/usb/serial/usb-serial.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/serial/usb-serial.c
> +++ usb-2.6/drivers/usb/serial/usb-serial.c
> @@ -974,6 +974,7 @@ int usb_serial_probe(struct usb_interfac
>  		if (retval > 0) {
>  			/* quietly accept this device, but don't bind to a
>  			   serial port as it's about to disappear */
> +                       for (i = 0; i < serial->num_ports; i++) {
> +                               port_free(serial->port[i]);
> +                               serial_port[i] = NULL;
> +                       }
> +			serial->num_ports = 0;
>  			goto exit;
>  		}
>  	}

Cheers,
Ben.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

