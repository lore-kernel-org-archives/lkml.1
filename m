Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273Ab0AGUhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0AGUhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050Ab0AGUhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:37:12 -0500
Received: from mailgw5.ericsson.se ([193.180.251.36]:53989 "EHLO
	mailgw5.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0AGUhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:37:10 -0500
X-AuditID: c1b4fb24-b7bb6ae000001052-ec-4b4645f385c8
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] i2c: Add support for Ux500/Nomadik I2C controller
Date: Thu, 7 Jan 2010 21:37:04 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E30CDB5@eseldmw101.eemea.ericsson.se>
In-Reply-To: <27f8aa32bf40c690930a76ce5e1ee82cec86b248.1262870858.git.srinidhi.kasagar@stericsson.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] i2c: Add support for Ux500/Nomadik I2C controller
Thread-Index: AcqPnz3/mkHzCQXOSGmLNSZpe5Ik/QANsR2A
References: <27f8aa32bf40c690930a76ce5e1ee82cec86b248.1262870858.git.srinidhi.kasagar@stericsson.com>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Srinidhi KASAGAR" <srinidhi.kasagar@stericsson.com>,
       <linux-i2c@vger.kernel.org>
Cc: <ben-linux@fluff.org>, <linux-kernel@vger.kernel.org>,
       <STEricsson_nomadik_linux@list.st.com>, <sachin.verma@st.com>,
       <andrea.gallo@stericsson.com>
X-OriginalArrivalTime: 07 Jan 2010 20:37:07.0706 (UTC) FILETIME=[2E1195A0:01CA8FD9]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinidhi, great work!

Just a few quickies, if you fix these it's
Acked-by: Linus Walleij <linus.walleij@stericsson.com> 

> diff --git a/arch/arm/plat-nomadik/include/plat/i2c.h 
> b/arch/arm/plat-nomadik/include/plat/i2c.h
> +enum i2c_freq_mode {
> +	I2C_FREQ_MODE_STANDARD,		/* up to 100 Kb/s */
> +	I2C_FREQ_MODE_FAST,		/* up to 400 Kb/s */
> +	I2C_FREQ_MODE_FAST_PLUS,	/* up to 1 Mb/s */
> +	I2C_FREQ_MODE_HIGH_SPEED	/* up to 3.4 Mb/s */
> +};
> +
> +enum i2c_addr_mode {
> +	I2C_7_BIT_ADDRESS = 0x1,
> +	I2C_10_BIT_ADDRESS = 0x2
> +};

Which field in the struct will use this? Can't
I2C_FUNC_10BIT_ADDR and I2C_M_TEN from include/linux/i2c.h (and
siblings) be used for this instead? Leftover?

You have this later:

(...)
+		if (unlikely(msgs[i].flags & I2C_M_TEN)) {
+			dev_err(&dev->pdev->dev, "10 bit addressing"
+					"not supported\n");
+			return -EINVAL;
(...)

Hmmmm?

> +
> +struct nmk_i2c_controller {

Please use kerneldoc for these comments.
(see Documentation/kernel-doc-nano-HOWTO.txt)

> +	unsigned long	clk_freq;
> +	unsigned short	slsu;	/* slave data set up time */

Comment which unit this is in. (Nanosecs I think?)

> +	unsigned char 	tft;	/* Tx FIFO Threshold */
> +	unsigned char 	rft;	/* Rx FIFO Threshold */

In bytes?

> +	unsigned short	sm;	/* speed mode */

Shouldn't this last element be 
enum i2c_freq_mode sm
then?

> +++ b/drivers/i2c/busses/i2c-nmk.c
(...)
> +	dev->irq = platform_get_irq(pdev, 0);
> +	ret = request_irq(dev->irq, i2c_irq_handler, IRQF_DISABLED,
> +				DRIVER_NAME, dev);

Since I2C IRQs can be a bit tedious, could this be converted
to a request_threaded_irq()? OK I know that is probably a bit
intrusive and can very well be done later (so no blocker) but
think about it.

Linus Walleij
