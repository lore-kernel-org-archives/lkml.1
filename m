Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZGXSAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZGXSAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZGXSAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:00:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:64098 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbZGXSAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=NNuESGdzjDLum+5Um5Q/R3Ln57RGeQ8o6yJ2wfLdLaOeRJ6Ik6Gl2uMy/AkmhTTa8L
         beq105bZqOjDXwMUxfoH2DoNof+PqQ1hIJsitlkQfDmEb2Bp/pRldFqGzCbej5CNrb6p
         RkgcrxEdGibp4eXFzBbFkTanuUDwmOD2jTTrM=
Date: Fri, 24 Jul 2009 11:00:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [PATCH 2/2] tsc2007: reduced number of I2C transfers
Message-ID: <20090724180022.GA6477@dtor-d630.eng.vmware.com>
References: <4A69DDED.50402@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A69DDED.50402@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 06:14:37PM +0200, Richard Röjfors wrote:
> Decreases the number of I2C transactions transferred by the driver.
> During probe we don't need to ask for the coordinates from the controller.
> When polling the controller we don't need to power down and enable IRQ  
> if we are going to poll again.
>
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> ---
> Index: linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c
> ===================================================================
> --- linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1040)
> +++ linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1053)
> @@ -178,6 +178,12 @@
>  		ts->penstate = PEN_STATE_UP;
>  }
>
> +static void tsc2007_power_down(struct tsc2007 *tsc)
> +{
> +	/* power down */
> +	tsc2007_xfer(tsc, PWRDOWN);
> +}
> +
>  static int tsc2007_read_values(struct tsc2007 *tsc)
>  {
>  	/* y- still on; turn on only y+ (and ADC) */
> @@ -188,11 +194,8 @@
>
>  	/* turn y+ off, x- on; we'll use formula #1 */
>  	tsc->tc.z1 = tsc2007_xfer(tsc, READ_Z1);
> -	tsc->tc.z2 = tsc2007_xfer(tsc, READ_Z2);
> +	tsc->tc.z2 = tsc2007_xfer(tsc, READ_Z2 | TSC2007_POWER_OFF_IRQ_EN);

I think this leaves the controller powered on and with with PENIRQ
disabled.

-- 
Dmitry
