Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbXESTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbXESTcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbXESTbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:31:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50739 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbXESTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:31:53 -0400
Date: Sat, 19 May 2007 12:33:07 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Indan Zupancic <indan@nul.nu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: 2.6.22-rc2] SLAB doesn't like usb_get_configuration()
Message-ID: <20070519193307.GA26156@kroah.com>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org> <3642.81.207.0.53.1179584891.squirrel@secure.samage.net> <Pine.LNX.4.64.0705191119460.17008@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705191119460.17008@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 11:20:44AM -0700, Christoph Lameter wrote:
> On Sat, 19 May 2007, Indan Zupancic wrote:
> 
> > I had two SLAb related bugs, both with usb_get_configuration()
> > near the end of the backtrace. First one was with git between
> > rc1 and rc2, but very close to rc2, second one was with rc2,
> > both at bootup.
> 
> Well usb_get_configuration seems to do a kmalloc(0) which is a bit 
> strange and this is why we flagged the allocation in the slab allocators. 
> Is there some way to avoid allocating an object of zero length?

Can you try the patch below and let me know if it fixes the issue for
you or not?

thanks,

greg k-h


From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] USB: don't try to kzalloc 0 bytes

This patch (as907) prevents us from trying to allocate 0 bytes
when an interface has no endpoint descriptors.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

--- usb-2.6.orig/drivers/usb/core/config.c
+++ usb-2.6/drivers/usb/core/config.c
@@ -185,10 +185,12 @@ static int usb_parse_interface(struct de
 		num_ep = USB_MAXENDPOINTS;
 	}
 
-	len = sizeof(struct usb_host_endpoint) * num_ep;
-	alt->endpoint = kzalloc(len, GFP_KERNEL);
-	if (!alt->endpoint)
-		return -ENOMEM;
+	if (num_ep > 0) {	/* Can't allocate 0 bytes */
+		len = sizeof(struct usb_host_endpoint) * num_ep;
+		alt->endpoint = kzalloc(len, GFP_KERNEL);
+		if (!alt->endpoint)
+			return -ENOMEM;
+	}
 
 	/* Parse all the endpoint descriptors */
 	n = 0;

