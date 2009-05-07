Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbZEGAGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbZEGAGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbZEGAGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:06:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60435 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882AbZEGAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:06:13 -0400
Date: Thu, 7 May 2009 01:06:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>,
       Jason Wessel <jason.wessel@windriver.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
Message-ID: <20090507010634.52bef075@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org>
References: <200905061917.09454.oliver@neukum.org>
	<Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     Write routine:
> 	Copy bytes into the available URB buffers, submitting URBs as 
> 	they get filled.  At the end, if the next URB is partially full 
> 	then submit it only if NIF < P.

There are good known algorithms for this and essentially the logic is
about speed and time estimation. You don't need to queue a partially
filled URB until you reach the time point that the hardware is in danger
of having sent everything already queued. So under load once you've
stuffed 4K down the pipe you know at 38400 baud that you can relax for
quite some time.

You could even entirely decouple write() from sending URBs.

>     Completion routine:
> 	If the next URB to send is partially filled, submit it.
> 
>     write_room routine:
> 	Return the actual number of bytes remaining in the available 
> 	URBs, but no more than (N-P)*B.

Providing your URBs can be allocated to say 512 bytes an URB then it'll
work fine to simply return the bytes left in the last URB (max the bytes
in the last URB). The tty code will then end up going

	room ?
		512 bytes
		fire away
	room ? 
		512 bytes
		fire away
	room ?
		...

until you run short of space

> 
> How does that sound?  Converting \n to \r\n will add some complication 
> but not too much.  
> 
> Allocating URBs on the fly adds a lot of complication.  There has to be 
> a minimum number of pre-allocated URBs; otherwise write_room could 
> never return a positive value.  If you allocate additional URBs 
> later on, when would you free them?

write_room can allocate URBs I think (would need to be atomic allocations)

	write_room()
		if no_urbs && urbs_queued < max_queued
			allocate an urb
		return space_in_last_urb;


