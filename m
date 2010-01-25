Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535Ab0AYUDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0AYUDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299Ab0AYUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:03:14 -0500
Received: from smtp109.biz.mail.mud.yahoo.com ([68.142.201.178]:20791 "HELO
	smtp109.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752207Ab0AYUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:03:13 -0500
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: KQxhn7QVM1kinnMoqHHZhClocyiu8X_O3jXqT0ilO.o6VuTsvTAC5xMPxkqd8yx3DhxiVHnbBTLIFeteT80HgZNqTONw.eeKymci3Gup.WVPDtfS0djfk6Bd9ZyQ1i84vmh8KygC57CCD0NulnMZOVz7whMnTVDZYt2o41vM153XsTRP2PeMB_550.vbs9aREf4Qke1J6lUl0oRV_0QQGup_U_ZtB6GvNUA948V_GJyynciQylzzWVFRjpTXKmvMMRGrNtyl3q8bBufwMe9fQip5NaF0Shb_Q3sMXQevPOWfpvPSmQrJwHcpMjZZQEDVfd69Ky51sT.ulvfcYt7jE6o764ItbLF.BhsSiSpTIxbyVvbpFJinZl3ZM3xD_tSkobWWMPad
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH v2] m68knommu: driver for Freescale Coldfire I2C controller.
Date: Mon, 25 Jan 2010 11:56:30 -0800
User-Agent: KMail/1.9.9
Cc: Jean Delvare <khali@linux-fr.org>, gerg@snapgear.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dev@uclinux.org
References: <201001101600.41932.sfking@fdwdc.com> <201001111024.05506.sfking@fdwdc.com> <20100124151519.GB28675@fluff.org.uk>
In-Reply-To: <20100124151519.GB28675@fluff.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001251156.31110.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010 07:15:19 you wrote:
> On Mon, Jan 11, 2010 at 10:24:05AM -0800, Steven King wrote:
> > Changes for this version:
> > 	rename drivers/i2c/busses/i2c-mcf.c to drivers/i2c/busses/i2c-coldfire.c
> > 	use I2C_COLDFIRE in drivers/i2c/busses/{Kconfig,Makefile}
> >
> > ------
> >
> > Add support for the I2C controller used on Freescale/Motorola Coldfire
> > MCUs.
> >
> > Signed-off-by: Steven King <sfking@fdwdc.com>
>
> The commit messsage should go first, the changelog and other stuff
> that won't go in should go beflore the --- line.

My bad, I think I was paying more attention to making sure this mailer didn't 
line wrap on me.  I can repost if you want.

> > +static irqreturn_t mcfi2c_irq_handler(int this_irq, void *dev_id)
> > +{
> > +	struct mcfi2c *mcfi2c = dev_id;
> > +
> > +	/* clear interrupt */
> > +	mcfi2c_wr_sr(mcfi2c, 0);
> > +	complete(&mcfi2c->completion);
> > +
> > +	return IRQ_HANDLED;
> > +}
>
> I'm interested in why you don't just handle the interrupt here and
> wake the thread once all the data is handled?

No particular reason; when I started working on this I looked at how some of 
the other drivers in drivers/i2c/busses were implemented, found one whose 
workings I could understand without knowing anything about that particular 
SoC (which one I don't remember) and used it as a model to adapt the i2c code 
I use with other Freescale/Motorola MCUs that don't run linux (there is very 
little difference in the i2c controller on an 8-bit hc08, 16 bit hc11/12, 
32bit Coldfire v1 and the Coldfire v2[+] that are currently supported).  So 
other than having easy to understand (for me atleast) code that shared a lot 
of similarity with the code I use for the some of the other  systems I code 
for, no real reason.  That and I find statefull irq handlers disconcerting.

> > +	status = request_irq(mcfi2c->irq, mcfi2c_irq_handler, IRQF_DISABLED,
> > +			     pdev->name, mcfi2c);
>
> do you really need IRQF_DISABLED here? your irq handler hardly does
> anything.

Yes, without it, I was getting a spurious interrupt (been there, done that).

> > +	if (status) {
> > +		dev_dbg(&pdev->dev, "request_irq failed\n");
> > +		goto fail2;
> > +	}
> > +
> > +	mcfi2c->clk = clk_get(&pdev->dev, "i2c_clk");
>
> hmm, think the default device clock should be findable by clk_get(dev,
> NULL).

Interesting.   Again, I had looked at the existing code in drivers/i2c/busses 
to see what the other drivers were doing and most were passing an id string.

Its a trivial change so its no big deal, but I'm curious, absent anything in 
Documentation, if the bulk of the existing code isn't documentation for the 
correct use of an api, then what is?

-- 
Steven King -- sfking at fdwdc dot com
