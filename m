Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZDOPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZDOPDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZDOPDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:03:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38630 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752790AbZDOPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:03:07 -0400
Date: Wed, 15 Apr 2009 16:01:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415160153.485c2095@lxorguk.ukuu.org.uk>
In-Reply-To: <49E5EE41.3090505@rtr.ca>
References: <49E4FAC6.1030400@garzik.org>
	<20090415014930.GA29413@kroah.com>
	<49E5480F.10501@garzik.org>
	<20090415050947.GB3462@kroah.com>
	<49E5EE41.3090505@rtr.ca>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SATA drives also take variable amounts of time to "show up" at boot.
> Perhaps Jeff should customize libata for your and Arjan's exact setups,
> just to help with understanding the point here.  :)

Actually I would argue the reverse. The sooner we can push this so that
libata isn't blocking mounting the rootfs the better.

> The speed ups are fine (and welcome), but we really now need
> Arjan to follow-up with a patch to have the kernel *by default*
> wait a little longer for the rootfs to show up.
> 
> Not forever, just a few seconds to compensate for the regression.

Why should every user suffer a slower boot and a poorer resume time ?

Instead make the root fs mounting look like this


	while(my_rootfs_hasnt_appeared_and_i_am_sad()) {
		wait_on(&new_disk_discovery);
	}

and poke the queue whenever we add a relevant device.

That way if you are booting off an initrd you can finish the SATA probe
in parallel to getting userspace ticking over.

On what is nowdays essentially a hot plug system it all needs turning
this way up - eg RAID volumes should assemble and come online as the
drives are discovered not at some fixed point later in userspace.

Alan
