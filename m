Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXJITAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXJITAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXJIS7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:59:53 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:46510 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751126AbXJIS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:59:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=TFHHZ7jA+IPldQqZb5jqk96GO9gKNxuBJ9tuy1z7Hp28ui0O0NjcXZbtvYAmcTiw+PRQlpIm8KeyIH+rF33OM9iOgMHyhB/z4MGVMnsmOEU2bxIA78RW85W1HIyRrt8nHVr7CX60Hp+BGvTZ/M4IL47FKgup0ZQBLZCkaUUCJBg=  ;
X-YMail-OSG: 5EIwS5wVM1m.58RZ3_at0S5dELeYkgJY0dO4Z85plT1xhjvSDpstefXI1KINtHpg_oZ6FHuFPQ--
Date: Tue, 09 Oct 2007 11:59:57 -0700
From: David Brownell <david-b@pacbell.net>
To: stern@rowland.harvard.edu, greg@kroah.com
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       davem@davemloft.net
References: <Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009185957.94150236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is a proposed patch.  I haven't tried running it, but it compiles 
> okay.

Looks about right, too; thanks.  Minor comments:

> --- usb-2.6.orig/drivers/usb/core/hcd.h
> +++ usb-2.6/drivers/usb/core/hcd.h
> @@ -470,5 +472,9 @@ static inline void usbmon_urb_complete(s
>  		: (in_interrupt () ? "in_interrupt" : "can sleep"))
>  
>  
> -#endif /* __KERNEL__ */
> +/* Mutual exclusion for EHCI CF initialization.  This interferes with
> + * port reset on some companion controllers.
> + */
> +extern struct rw_semaphore ehci_cf_port_reset_rwsem;

You have two copies of that comment; I'd drop this one, and add a
better one around CF initialization.

What I'd have here is a comment that this symbol is exported ONLY
for use by the EHCI driver, trespassers will be violated, etc.


> --- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
> +++ usb-2.6/drivers/usb/host/ehci-hcd.c
> @@ -646,9 +646,11 @@ static int ehci_run (struct usb_hcd *hcd
>  	 * involved with the root hub.  (Except where one is integrated,
>  	 * and there's no companion controller unless maybe for USB OTG.)
>  	 */
> +	down_write(&ehci_cf_port_reset_rwsem);
>  	hcd->state = HC_STATE_RUNNING;
>  	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
>  	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
> +	up_write(&ehci_cf_port_reset_rwsem);

That deserves a comment about how CF and companion port resets
don't mix well.

... assuming this does check out as the problem, which I expect
it will.

- Dave

>  
>  	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
>  	ehci_info (ehci,
>
