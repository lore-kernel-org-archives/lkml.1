Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0BIPM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:12:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52187 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754411Ab0BIPM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:12:56 -0500
Date: Tue, 9 Feb 2010 10:12:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roel Kluin <roel.kluin@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <sarah.a.sharp@linux.intel.com>,
       <linux-usb@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if usb_control_msg()
 fails in usb_reset_configuration()
In-Reply-To: <4B715C55.5090102@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010, Roel Kluin wrote:

> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
> break occurred, i equals config->desc.bNumInterfaces. so if
> usb_control_msg() failed then after goto reset_old_alts we read from
> config->interface[config->desc.bNumInterfaces].

You correctly identified a problem, but your fix is wrong -- or at 
least, it is much too complicated.  The proper fix goes like this:

 	/* If not, reinstate the old alternate settings */
 	if (retval < 0) {
 reset_old_alts:
-		for (; i >= 0; i--) {
+		for (i--; i >= 0; i--) {
 			struct usb_interface *intf = config->interface[i];
 			struct usb_host_interface *alt;
 

Alan Stern

