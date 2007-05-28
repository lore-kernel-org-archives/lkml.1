Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXE1VJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXE1VJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXE1VI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:08:59 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:42624 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750934AbXE1VI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:08:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=J+aAhVodR17WiyEFKKQ009+EsxbaVbEmpmJIOctZxW5yhK/gNSXTLKAQ1CMs/Y/fbDyfs7RUyqASLQtWpZUS/3bE+F8J+OKt3bG1e9n1qElkakvW0X16FRb9dnmk8xrwtD7v6Y1f5S3vKrb7Xc7iT8VBfVmNB7aowuaWs+c1Q0Q=  ;
X-YMail-OSG: 9qJCjucVM1m9UBgBoWWF7kvKggv3y8_BQTIlQ9D.DnHO99s6n9Y56d9MTEBZU3nXCJ1L5ebyiQ--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] RTC: Use fallback IRQ if PNP tables don't provide one
Date: Mon, 28 May 2007 14:06:41 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070527190351.GA21387@srcf.ucam.org> <200705271844.54589.david-b@pacbell.net> <20070528172418.GA2076@srcf.ucam.org>
In-Reply-To: <20070528172418.GA2076@srcf.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705281406.44340.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007, Matthew Garrett wrote:
> From: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> Intel Macs (and possibly other machines) provide a PNP entry for the 
> RTC, but provide no IRQ. As a result the rtc-cmos driver doesn't allow 
> wakeup alarms. If the RTC is located at the legacy ioport range, assume 
> that it's on IRQ 8 unless the tables say otherwise.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
> 
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 6085261..e24ea82 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -641,9 +641,16 @@ cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
>  	 * drivers can't provide shutdown() methods to disable IRQs.
>  	 * Or better yet, fix PNP to allow those methods...
>  	 */
> -	return cmos_do_probe(&pnp->dev,
> -			&pnp->res.port_resource[0],
> -			pnp->res.irq_resource[0].start);
> +	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
> +		/* Some machines contain a PNP entry for the RTC, but
> +		 * don't define the IRQ. It should always be safe to
> +		 * hardcode it in these cases
> +		 */
> +		return cmos_do_probe(&pnp->dev, &pnp->res.port_resource[0], 8);
> +	else
> +		return cmos_do_probe(&pnp->dev,
> +				     &pnp->res.port_resource[0],
> +				     pnp->res.irq_resource[0].start);
>  }
>  
>  static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
> 


