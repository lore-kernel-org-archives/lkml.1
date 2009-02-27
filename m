Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbZB0W3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbZB0W3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbZB0W3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:29:43 -0500
Received: from mail-fx0-f164.google.com ([209.85.220.164]:54257 "EHLO
	mail-fx0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbZB0W3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:29:42 -0500
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       davinci-linux-open-source@linux.davincidsp.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch/RESEND 2.6.29-rc3-git] NAND: davinci_nand driver
References: <200902241509.54649.david-b@pacbell.net>
	<20090226123341.a2421733.akpm@linux-foundation.org>
	<200902261515.22197.david-b@pacbell.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
In-Reply-To: <200902261515.22197.david-b@pacbell.net> (David Brownell's message of "Thu\, 26 Feb 2009 15\:15\:21 -0800")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Fri, 27 Feb 2009 14:29:32 -0800
Message-ID: <87k57ba4z7.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> writes:

> On Thursday 26 February 2009, Andrew Morton wrote:
>
>> > + * Copyright (C) 2006 Texas Instruments.
>> > + *
>> > + * Ported to 2.6.23 Copyright (C) 2008 by
>> > + *   Sander Huijsen <Shuijsen@optelecom-nkf.com>
>> > + *   Troy Kisky <troy.kisky@boundarydevices.com>
>> > + *   Dirk Behme <Dirk.Behme@gmail.com>
>> 
>> hm.  What's the story with authorship, attributions and signoffs here?
>
> Written by TI (PSP team in India, ISTR) with no individual
> authorship credited, and shipped with a MontaVista 2.6.10
> kernel.  Ported as noted; I could presumably add my own
> copyright given recent updates I've made.  Likewise Felipe
> Balbi.  Kevin Hilman has signed off on various patches as
> part of merging them to the DaVinci tree.
>
> (To the TI team reading this via the DaVinci list:  I think
> Andrew is hinting that a Signed-off-By from a TI person
> would be a Nice Thing.  Same for Dirk, and maybe others.)
>
>
>> > ...
>> >
>> > +#ifdef CONFIG_MTD_PARTITIONS
>> > +static inline int mtd_has_partitions(void) { return 1; }
>> > +#else
>> > +static inline int mtd_has_partitions(void) { return 0; }
>> > +#endif
>> > +
>> > +#ifdef CONFIG_MTD_CMDLINE_PARTS
>> > +static inline int mtd_has_cmdlinepart(void) { return 1; }
>> > +#else
>> > +static inline int mtd_has_cmdlinepart(void) { return 0; }
>> > +#endif
>> 
>> These definitions shouldn't be buried in a .c file.
>
> I will send along a patch to move them to <linux/mtd/...> headers,
> now that there seems to be a bit of recognition that the current
> ifdef-centric approach in the MTD mapping drivers is trouble.  ;)
>
>
>> >
>> > ...
>> >
>> > +static void nand_davinci_hwctl_1bit(struct mtd_info *mtd, int mode)
>> > +{
>> > +	struct davinci_nand_info *info;
>> > +	u32 retval;
>> 
>> The identifier `retval' is usually used to identify the value which
>> this function will return.
>
> True; resolved in the appended fixup patch.
>
>
>> > +static int nand_davinci_calculate_1bit(struct mtd_info *mtd,
>> > +				      const u_char *dat, u_char *ecc_code)
>> > +{
>> > +	unsigned int ecc_val = nand_davinci_readecc_1bit(mtd);
>> > +	unsigned int tmp = (ecc_val & 0x0fff) | ((ecc_val & 0x0fff0000) >> 4);
>> 
>> argh.
>
> It seems the best-dressed pirates have parrots named "argh"!  ;)
>
>
>> > +	/* invert so that erased block ecc is correct */
>> > +	tmp = ~tmp;
>> > +	ecc_code[0] = (u_char)(tmp);
>> > +	ecc_code[1] = (u_char)(tmp >> 8);
>> > +	ecc_code[2] = (u_char)(tmp >> 16);
>> 
>> Is there some library facility which is being open-coded here?
>
> I don't know of such a facility:  24-bit integer into 3-byte buffer.
>
>
>> > +	return 0;
>> > +}
>> > +
>> >
>> > ...
>> >
>> > +static int __init nand_davinci_probe(struct platform_device *pdev)
>> > +{
>> > +		... deletia ...
>> > +
>> > +	info = kzalloc(sizeof(*info), GFP_KERNEL);
>> > +	if (!info) {
>> > +		dev_err(&pdev->dev, "unable to allocate memory\n");
>> > +		ret = -ENOMEM;
>> > +		goto err_nomem;
>> > +	}
>> > +
>> > +	platform_set_drvdata(pdev, info);
>> > +
>> > +	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> > +	res2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> > +	if (!res1 || !res2) {
>> > +		dev_err(&pdev->dev, "resource missing\n");
>> > +		ret = -EINVAL;
>> > +		goto err_res;
>> 
>> This leaks `info'.
>> 
>> Please check all the error path unwinding here.
>
> OK -- that does look buggish.
>
> (Kevin -- I suggest you merge this to the DaVinci tree to
> make the eventual resync-with-mainline easier.)
>

Done.

It also needs this cleanup bit below which is in DaVinci git now that
we've deprecated the use of the davinci cpu_is_* macros in drivers.

This could be just folded into current patch if desired.

Thanks,

Kevin


commit 1bacc33ccc9bd0f3c109bf8a8550e9b6f99397bd
Author: Kevin Hilman <khilman@deeprootsystems.com>
Date:   Thu Feb 26 17:15:18 2009 -0800

    MTD: NAND: drop usage of cpu_is_* macro
    
    Usage of davinci-specific cpu_is macros is not allowed in drivers.
    These options should be passed in through platform_data.
    
    Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index aa70b4e..a2f78ad 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -33,7 +33,6 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-#include <mach/cpu.h>
 #include <mach/nand.h>
 
 #include <asm/mach-types.h>
@@ -392,8 +391,6 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 	/* use board-specific ECC config; else, the best available */
 	if (pdata)
 		ecc_mode = pdata->ecc_mode;
-	else if (cpu_is_davinci_dm355())
-		ecc_mode = NAND_ECC_HW_SYNDROME;
 	else
 		ecc_mode = NAND_ECC_HW;
 
