Return-Path: <linux-kernel-owner+w=401wt.eu-S1764875AbXFEOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764875AbXFEOYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763744AbXFEOYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:24:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35745 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762931AbXFEOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:24:17 -0400
Date: Tue, 5 Jun 2007 10:24:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michael Hanselmann <linux-kernel@hansmi.ch>
cc: linux-kernel@vger.kernel.org, <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@killerfox.forkbomb.ch>
Subject: Re: [linux-usb-devel] [PATCH] Fix NEC OHCI chip silicon bug
In-Reply-To: <20070604210555.GB12676@hansmi.ch>
Message-ID: <Pine.LNX.4.44L0.0706051018360.3662-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Michael Hanselmann wrote:

> On Sat, Jun 02, 2007 at 10:49:44AM -0400, Alan Stern wrote:
> > Then later on, when the hub driver is resumed it will see the flag and
> > disconnect all the devices below the root hub.
> 
> > For instance, you could force ohci-hcd to report connect-change events
> > on all the ports. Perhaps it does something like that anyway, in which
> > case you wouldn't have to worry about it.
> 
> After studying the code for two evenings, I'm quite sure it does that
> already.
> 
> A comment in ohci-hcd.c:ohci_restart reads:
>   /* mark any devices gone, so they do nothing till khubd disconnects.
>    * recycle any "live" eds/tds (and urbs) right away.
>    * later, khubd disconnect processing will recycle the other state,
>    * (either as disconnect/reconnect, or maybe someday as a reset).
>    */

Don't believe everything you read in comments.  That one is very out of 
date.  It should be removed.

> usb_root_hub_lost_power marks the ports as gone, khubd will disconnect them.

Wrong.  usb_root_hub_lost_power does _not_ mark the ports as gone, and 
it does _not_ tell khubd to disconnect them.  (Depending on which 
version of the kernel you are looking at -- I'm referring to the latest 
development kernel including the gregkh-all patch set.  Earlier 
versions did behave the way you describe.)

> After restarting the chip, khubd will cause them to be detected again.
> 
> This is also what I can watch in the logs:
>   ohci_hcd 0001:10:15.1: OHCI Unrecoverable Error, scheduling NEC chip restart
>   usb usb2: root hub lost power or was reset
>   usb 2-2: USB disconnect, address 2
>   input: appletouch disconnected
>   usb 2-2: new full speed USB device using ohci_hcd and address 3
>   usb 2-2: configuration #1 chosen from 1 choice
>   input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input16 on usb-0001:10:15.1-2
>   input: appletouch as /class/input/input17
>   input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input18 on usb-0001:10:15.1-2
> 
> (Actually, I added some code to trigger the error handling code, reliably
> reproducing it otherwise is impossible.)

So the system is behaving the way you want, but not for the reason you 
think.  I bet you could remove the call to usb_root_hub_lost_power() 
entirely and it wouldn't make any difference at all.

Alan stern

