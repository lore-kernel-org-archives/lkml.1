Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXKSTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXKSTFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXKSTEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:04:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57770 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751853AbXKSTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:04:52 -0500
Date: Mon, 19 Nov 2007 14:04:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: stable@kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <gregkh@suse.de>, <zwane@arm.linux.org.uk>, <tytso@mit.edu>,
       <torvalds@linux-foundation.org>, <reviews@ml.cw.f00f.org>,
       <rdunlap@xenotime.net>, <mkrufky@linuxtv.org>, <jmforbes@linuxtx.org>,
       <dely.l.sy@intel.com>, <davem@davemloft.net>, <davej@redhat.com>,
       <chuckw@quantumlinux.com>, <cebbert@redhat.com>, <cavokz@gmail.com>,
       <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 19/26] USB: mutual exclusion for EHCI init and port resets
In-Reply-To: <20071119184128.E43D423C403@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0711191403400.3005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, David Brownell wrote:

> Still needs the following update, IMO ... 
> 
> ======	CUT HERE
> A recent patch added software synchronization during EHCI startup,
> so ports aren't switched away from the companion controllers after
> resets have started.  This patch adds a short delay letting hardware
> get a chance to finish that port switching before any new resets begin.
> 
> That is, both sides of that hardware race window need to be closed.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/usb/host/ehci-hcd.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- g26.orig/drivers/usb/host/ehci-hcd.c	2007-11-13 16:07:12.000000000 -0800
> +++ g26/drivers/usb/host/ehci-hcd.c	2007-11-13 16:13:01.000000000 -0800
> @@ -594,12 +594,15 @@ static int ehci_run (struct usb_hcd *hcd
>  	 * from the companions to the EHCI controller.  If any of the
>  	 * companions are in the middle of a port reset at the time, it
>  	 * could cause trouble.  Write-locking ehci_cf_port_reset_rwsem
> -	 * guarantees that no resets are in progress.
> +	 * guarantees that no resets are in progress.  After we set CF,
> +	 * a short delay lets the hardware catch up; new resets shouldn't
> +	 * start before the port switching actions complete.
>  	 */
>  	down_write(&ehci_cf_port_reset_rwsem);
>  	hcd->state = HC_STATE_RUNNING;
>  	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
>  	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
> +	msleep(5);
>  	up_write(&ehci_cf_port_reset_rwsem);
>  
>  	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));

This addition certainly won't hurt.  Did we ever get any feedback as to 
whether it actually helped?

Alan Stern

