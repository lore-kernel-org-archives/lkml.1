Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZBZXPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZBZXPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZBZXP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:15:26 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:28963 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753664AbZBZXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:15:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J+bgmjRyrPciY6Gh5ihQXB3EcyLhOHJTimXqwu7lXvsg+2axahGUOfFYf3eHRKTyF0o+yYL1aNj+FJsT50kkN21RqxICb0UURX7nk5bOIYipWNrkjXtAn6z0v+3vyloZnoqG0n2+rk+SiKfSei7nYINvcjkLKVDHSU07ijcleOg=  ;
X-YMail-OSG: HAu0YOUVM1mOXNL7z0zLFtF8JSBlHIh9Uy.fFCCyYTXe0veFLwBrqSGVjzL5oTbihLqFEduOtlEOIzt_DMeAEvRVawiUNtBXcAAuB128CVPzAEB9EhJFvooqhp46sM3fDeacIqFSa3Ty9rjGZS9WmGJig1pR.HHfEPXkVjjFGjT6yAnzqJpCy9jEbD_54V7wTA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/RESEND 2.6.29-rc3-git] NAND: davinci_nand driver
Date: Thu, 26 Feb 2009 15:15:21 -0800
User-Agent: KMail/1.9.10
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com
References: <200902241509.54649.david-b@pacbell.net> <20090226123341.a2421733.akpm@linux-foundation.org>
In-Reply-To: <20090226123341.a2421733.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261515.22197.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Andrew Morton wrote:

> > + * Copyright (C) 2006 Texas Instruments.
> > + *
> > + * Ported to 2.6.23 Copyright (C) 2008 by
> > + *   Sander Huijsen <Shuijsen@optelecom-nkf.com>
> > + *   Troy Kisky <troy.kisky@boundarydevices.com>
> > + *   Dirk Behme <Dirk.Behme@gmail.com>
> 
> hm.  What's the story with authorship, attributions and signoffs here?

Written by TI (PSP team in India, ISTR) with no individual
authorship credited, and shipped with a MontaVista 2.6.10
kernel.  Ported as noted; I could presumably add my own
copyright given recent updates I've made.  Likewise Felipe
Balbi.  Kevin Hilman has signed off on various patches as
part of merging them to the DaVinci tree.

(To the TI team reading this via the DaVinci list:  I think
Andrew is hinting that a Signed-off-By from a TI person
would be a Nice Thing.  Same for Dirk, and maybe others.)


> > ...
> >
> > +#ifdef CONFIG_MTD_PARTITIONS
> > +static inline int mtd_has_partitions(void) { return 1; }
> > +#else
> > +static inline int mtd_has_partitions(void) { return 0; }
> > +#endif
> > +
> > +#ifdef CONFIG_MTD_CMDLINE_PARTS
> > +static inline int mtd_has_cmdlinepart(void) { return 1; }
> > +#else
> > +static inline int mtd_has_cmdlinepart(void) { return 0; }
> > +#endif
> 
> These definitions shouldn't be buried in a .c file.

I will send along a patch to move them to <linux/mtd/...> headers,
now that there seems to be a bit of recognition that the current
ifdef-centric approach in the MTD mapping drivers is trouble.  ;)


> >
> > ...
> >
> > +static void nand_davinci_hwctl_1bit(struct mtd_info *mtd, int mode)
> > +{
> > +	struct davinci_nand_info *info;
> > +	u32 retval;
> 
> The identifier `retval' is usually used to identify the value which
> this function will return.

True; resolved in the appended fixup patch.


> > +static int nand_davinci_calculate_1bit(struct mtd_info *mtd,
> > +				      const u_char *dat, u_char *ecc_code)
> > +{
> > +	unsigned int ecc_val = nand_davinci_readecc_1bit(mtd);
> > +	unsigned int tmp = (ecc_val & 0x0fff) | ((ecc_val & 0x0fff0000) >> 4);
> 
> argh.

It seems the best-dressed pirates have parrots named "argh"!  ;)


> > +	/* invert so that erased block ecc is correct */
> > +	tmp = ~tmp;
> > +	ecc_code[0] = (u_char)(tmp);
> > +	ecc_code[1] = (u_char)(tmp >> 8);
> > +	ecc_code[2] = (u_char)(tmp >> 16);
> 
> Is there some library facility which is being open-coded here?

I don't know of such a facility:  24-bit integer into 3-byte buffer.


> > +	return 0;
> > +}
> > +
> >
> > ...
> >
> > +static int __init nand_davinci_probe(struct platform_device *pdev)
> > +{
> > +		... deletia ...
> > +
> > +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> > +	if (!info) {
> > +		dev_err(&pdev->dev, "unable to allocate memory\n");
> > +		ret = -ENOMEM;
> > +		goto err_nomem;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, info);
> > +
> > +	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	res2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +	if (!res1 || !res2) {
> > +		dev_err(&pdev->dev, "resource missing\n");
> > +		ret = -EINVAL;
> > +		goto err_res;
> 
> This leaks `info'.
> 
> Please check all the error path unwinding here.

OK -- that does look buggish.

(Kevin -- I suggest you merge this to the DaVinci tree to
make the eventual resync-with-mainline easier.)

=====================
From: David Brownell <dbrownell@users.sourceforge.net>

Minor fixes to the davinci-nand driver patch.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mtd/nand/davinci_nand.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -161,7 +161,7 @@ static inline u32 nand_davinci_readecc_1
 static void nand_davinci_hwctl_1bit(struct mtd_info *mtd, int mode)
 {
 	struct davinci_nand_info *info;
-	u32 retval;
+	u32 nandcfr;
 	unsigned long flags;
 
 	info = to_davinci_nand(mtd);
@@ -172,9 +172,9 @@ static void nand_davinci_hwctl_1bit(stru
 	spin_lock_irqsave(&davinci_nand_lock, flags);
 
 	/* Restart ECC hardware */
-	retval = davinci_nand_readl(info, NANDFCR_OFFSET);
-	retval |= BIT(8 + info->core_chipsel);
-	davinci_nand_writel(info, NANDFCR_OFFSET, retval);
+	nandcfr = davinci_nand_readl(info, NANDFCR_OFFSET);
+	nandcfr |= BIT(8 + info->core_chipsel);
+	davinci_nand_writel(info, NANDFCR_OFFSET, nandcfr);
 
 	spin_unlock_irqrestore(&davinci_nand_lock, flags);
 }
@@ -186,13 +186,13 @@ static int nand_davinci_calculate_1bit(s
 				      const u_char *dat, u_char *ecc_code)
 {
 	unsigned int ecc_val = nand_davinci_readecc_1bit(mtd);
-	unsigned int tmp = (ecc_val & 0x0fff) | ((ecc_val & 0x0fff0000) >> 4);
+	unsigned int ecc24 = (ecc_val & 0x0fff) | ((ecc_val & 0x0fff0000) >> 4);
 
 	/* invert so that erased block ecc is correct */
-	tmp = ~tmp;
-	ecc_code[0] = (u_char)(tmp);
-	ecc_code[1] = (u_char)(tmp >> 8);
-	ecc_code[2] = (u_char)(tmp >> 16);
+	ecc24 = ~ecc24;
+	ecc_code[0] = (u_char)(ecc24);
+	ecc_code[1] = (u_char)(ecc24 >> 8);
+	ecc_code[2] = (u_char)(ecc24 >> 16);
 
 	return 0;
 }
@@ -278,7 +278,7 @@ static int nand_davinci_dev_ready(struct
 
 static void __init nand_dm6446evm_flash_init(struct davinci_nand_info *info)
 {
-	u32 regval, tmp;
+	u32 regval, a1cr;
 
 	/*
 	 * NAND FLASH timings @ PLL1 == 459 MHz
@@ -297,11 +297,11 @@ static void __init nand_dm6446evm_flash_
 		| (3 << 2)            /* turnAround      ?? ns */
 		| (0 << 0)            /* asyncSize       8-bit bus */
 		;
-	tmp = davinci_nand_readl(info, A1CR_OFFSET);
-	if (tmp != regval) {
+	a1cr = davinci_nand_readl(info, A1CR_OFFSET);
+	if (a1cr != regval) {
 		dev_dbg(info->dev, "Warning: NAND config: Set A1CR " \
 		       "reg to 0x%08x, was 0x%08x, should be done by " \
-		       "bootloader.\n", regval, tmp);
+		       "bootloader.\n", regval, a1cr);
 		davinci_nand_writel(info, A1CR_OFFSET, regval);
 	}
 }
@@ -338,7 +338,7 @@ static int __init nand_davinci_probe(str
 	if (!res1 || !res2) {
 		dev_err(&pdev->dev, "resource missing\n");
 		ret = -EINVAL;
-		goto err_res;
+		goto err_nomem;
 	}
 
 	vaddr = ioremap(res1->start, res1->end - res1->start);
@@ -347,7 +347,6 @@ static int __init nand_davinci_probe(str
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -EINVAL;
 		goto err_ioremap;
-
 	}
 
 	info->dev		= &pdev->dev;
@@ -525,16 +524,14 @@ err_clk_enable:
 
 err_ecc:
 err_clk:
+err_ioremap:
 	if (base)
 		iounmap(base);
 	if (vaddr)
 		iounmap(vaddr);
 
-err_ioremap:
-	kfree(info);
-
 err_nomem:
-err_res:
+	kfree(info);
 	return ret;
 }
 

