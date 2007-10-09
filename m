Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXJIEn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXJIEn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXJIEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:43:19 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:48730 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751037AbXJIEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:43:18 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 00:43:18 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=WnS5mrK1TXbwx/RBMvoUMcsvsJoQvrRSNeKCg5JHnSdmjAnsZ4jlMbQNd4IUPJZTeNFGFQNhXSTJD1RS2c4uEt3G9pbY6WbEMGIN5jk39Ssj5XcdKBfBzb4oe4dye9dE708FePqH1OBbJL1KPJBlWj0ZFmhtRRD7TTQf0xjESak=  ;
X-YMail-OSG: LIT0L8AVM1nljh4VxtChUU5.gq5urQDb5Pnt2VvFbuCuPRnw77Why.1xEy7LcR.WB_FxOyxIEA--
Date: Mon, 08 Oct 2007 21:36:43 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
References: <20071006.235358.104048815.davem@davemloft.net>
 <20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071007.005156.85395415.davem@davemloft.net>
 <20071008.165420.42793456.davem@davemloft.net>
In-Reply-To: <20071008.165420.42793456.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Regardless, here is a patch that hardens the OHCI reset handling
> loops so that they break out instead of hanging the entire system
> should this condition occur.  It's at least better than what the
> code does to a user right now which is hang the box completely:
>
> [USB] ohci: Do not hang the system if port reset does not complete.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
> index bb9cc59..77ae5b4 100644
> --- a/drivers/usb/host/ohci-hub.c
> +++ b/drivers/usb/host/ohci-hub.c
> @@ -563,14 +563,19 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
>  	u32	temp;
>  	u16	now = ohci_readl(ohci, &ohci->regs->fmnumber);
>  	u16	reset_done = now + PORT_RESET_MSEC;
> +	int	limit_1;
>  
>  	/* build a "continuous enough" reset signal, with up to
>  	 * 3msec gap between pulses.  scheduler HZ==100 must work;
>  	 * this might need to be deadline-scheduled.
>  	 */
> -	do {
> +	limit_1 = 100;
> +	while (--limit_1 >= 0) {

Don't need this "limit_1" timeout; "reset_done" handles all
the timeout needed there.  The regs->fmnumber is essentially
a millisecond counter.


> +		int limit_2;
> +
>  		/* spin until any current reset finishes */
> -		for (;;) {
> +		limit_2 = PORT_RESET_MSEC * 2;

This is the loop that didn't terminate for you, right?
PORT_RESET_HW_MSEC is the ceiling you should use here,
not PORT_RESET_MSEC.


> +		while (--limit_2 >= 0) {
>  			temp = ohci_readl (ohci, portstat);
>  			/* handle e.g. CardBus eject */
>  			if (temp == ~(u32)0)
> @@ -579,6 +584,10 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
>  				break;
>  			udelay (500);
>  		}
> +		if (limit_2 < 0) {
> +			ohci_warn(ohci, "Root port inner-loop reset timeout, "
> +				  "portstat[%08x]\n", temp);
> +		}

What values do you see for "portstat"?

I suspect there will be some flag set which would allow a more
immediate exit from that loop.  RH_PS_CCS might clear, for example.

And in any case, if that fails I don't see any reason not to just
break, and return immediately.

>  
>  		if (!(temp & RH_PS_CCS))
>  			break;
> @@ -589,7 +598,14 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
>  		ohci_writel (ohci, RH_PS_PRS, portstat);
>  		msleep(PORT_RESET_HW_MSEC);
>  		now = ohci_readl(ohci, &ohci->regs->fmnumber);
> -	} while (tick_before(now, reset_done));
> +		if (!tick_before(now, reset_done))
> +			break;
> +	}
> +	if (limit_1 < 0) {
> +		ohci_warn(ohci, "Root port outer-loop reset timeout, "
> +			  "now[%04x] reset_done[%04x]\n",
> +			  now, reset_done);
> +	}
>  	/* caller synchronizes using PRSC */
>  
>  	return 0;
>
