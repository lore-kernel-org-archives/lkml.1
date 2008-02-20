Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbYBTQWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbYBTQWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765416AbYBTQLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:11:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47140 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765057AbYBTQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:10:04 -0500
Date: Wed, 20 Feb 2008 11:10:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: David Miller <davem@davemloft.net>, <andre@tomt.net>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <200802191619.55207.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0802201106100.4828-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, David Brownell wrote:

> Please try that diagnostic patch I sent ... with CONFIG_USB_DEBUG.
> 
> Near as I can tell this is caused by some hardware oddity that needs
> to be worked around.  We seem to be at stage where we've fixed some
> problems, nudging code paths around so another one shows up, and have
> incidentally had a new silicion-specific hardware erratum reported
> in this area.  So more info is needed...
> 
> A quick anti-oops patch is appended, it should work OK on top of that
> diagnostic patch, but won't necessarily resolve the underlying problem.
> 
> - Dave
> 
> 
> --- g26.orig/drivers/usb/host/ehci-q.c	2008-02-19 16:15:04.000000000 -0800
> +++ g26/drivers/usb/host/ehci-q.c	2008-02-19 16:15:59.000000000 -0800
> @@ -993,6 +993,11 @@ static void end_unlink_async (struct ehc
>  
>  	iaa_watchdog_done(ehci);
>  
> +	if (!qh) {
> +		WARN_ON(1);
> +		return;
> +	}
> +

It will be interesting to see the stack dump.  As far as I can tell,
there are two pathways which could lead qh being NULL.  One is the IAA
hardware peculiarity (setting the status bit very late, after the
watchdog timer has already expired), and the other is in unlink_async()  
if the controller isn't running.  That second one may be just a simple
bug -- I doubt it would show up unless the controller got a fatal 
error and stopped.

Alan Stern

