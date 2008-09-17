Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYIQUI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYIQUI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYIQUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:08:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:47621 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYIQUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xH2RbzBB8viY5vdgCofvYcJATMMK8aI7jZAa0TqmFKk9J3alWXPIgrwawkuMUFFSbh
         FdtKTj4nJ5+84KQwYMA8atdaBcvHEFuGPtBkJvGNW3d2l/D/8rbBi/Q7VLPh4+UsRQ8O
         VbhXExNCucP0paV7FTp9SX23iWYXB+qiNs7Wg=
Message-ID: <5767b9100809171308j58d05b36i453badc96e1e668c@mail.gmail.com>
Date: Thu, 18 Sep 2008 04:08:47 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] s3c24xx nand: add command line partition table parsing support
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-arm@vger.kernel.org, ben@simtec.co.uk
In-Reply-To: <20080917175838.GA5475@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100809171032g197771dfv5374b7358b9b7210@mail.gmail.com>
	 <20080917175838.GA5475@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, Russell
then I'd sent it to linux-arm-kernel@lists.arm.linux.org.uk &
ben-linux@fluff.org, right?
I am subscribing linux-arm-kernel@lists.arm.linux.org.uk :)

regards,
Conke

On Thu, Sep 18, 2008 at 1:58 AM, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> By sending this to the linux-arm list at vger, you're missing out the
> majority of the ARM community.  Please use the proper (listed) mailing
> list in MAINTAINERS.
>
> On Thu, Sep 18, 2008 at 01:32:16AM +0800, Conke Hu wrote:
>> Add mtd id and  command line partition table parsing support for
>> s3c24xx nand driver.
>>
>> Signed-off-by: Conke Hu <conke.hu@gmail.com>
>> Signed-off-by: Linke Wang <linke.wang@gmail.com>
>> ------------------
>> diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
>> index 556139e..bab7216 100644
>> --- a/drivers/mtd/nand/s3c2410.c
>> +++ b/drivers/mtd/nand/s3c2410.c
>> @@ -48,6 +48,8 @@
>>  #include <asm/plat-s3c/regs-nand.h>
>>  #include <asm/plat-s3c/nand.h>
>>
>> +#define S3C_NAND_NAME_LEN 16
>> +
>>  #ifdef CONFIG_MTD_NAND_S3C2410_HWECC
>>  static int hardware_ecc = 1;
>>  #else
>> @@ -60,6 +62,9 @@ static int clock_stop = 1;
>>  static const int clock_stop = 0;
>>  #endif
>>
>> +#ifdef CONFIG_MTD_PARTITIONS
>> +static const char *s3c_part_probes[] = {"cmdlinepart", NULL};
>> +#endif
>>
>>  /* new oob placement block for use with hardware ecc generation
>>   */
>> @@ -649,6 +654,15 @@ static int s3c2410_nand_add_partition(struct
>> s3c2410_nand_info *info,
>>                                     struct s3c2410_nand_mtd *mtd,
>>                                     struct s3c2410_nand_set *set)
>>  {
>> +#ifdef CONFIG_MTD_CMDLINE_PARTS
>> +     int nr_parts;
>> +     struct mtd_partition *partitions;
>> +
>> +     nr_parts = parse_mtd_partitions(&mtd->mtd, s3c_part_probes, &partitions, 0);
>> +     if (nr_parts > 0 && partitions != NULL)
>> +             return add_mtd_partitions(&mtd->mtd, partitions, nr_parts);
>> +#endif
>> +
>>       if (set == NULL)
>>               return add_mtd_device(&mtd->mtd);
>>
>> @@ -808,6 +822,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,
>>       int size;
>>       int nr_sets;
>>       int setno;
>> +     char *name;
>>
>>       pr_debug("s3c2410_nand_probe(%p)\n", pdev);
>>
>> @@ -875,7 +890,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev,
>>
>>       /* allocate our information */
>>
>> -     size = nr_sets * sizeof(*info->mtds);
>> +     size = nr_sets * (sizeof(*info->mtds) + S3C_NAND_NAME_LEN);
>>       info->mtds = kmalloc(size, GFP_KERNEL);
>>       if (info->mtds == NULL) {
>>               dev_err(&pdev->dev, "failed to allocate mtd storage\n");
>> @@ -888,10 +903,15 @@ static int s3c24xx_nand_probe(struct
>> platform_device *pdev,
>>       /* initialise all possible chips */
>>
>>       nmtd = info->mtds;
>> +     name = (char *)(info->mtds + nr_sets);
>>
>>       for (setno = 0; setno < nr_sets; setno++, nmtd++) {
>>               pr_debug("initialising set %d (%p, info %p)\n", setno, nmtd, info);
>>
>> +             sprintf(name, "s3c_nand%d", setno);
>> +             nmtd->mtd.name = name;
>> +             name += S3C_NAND_NAME_LEN;
>> +
>>               s3c2410_nand_init_chip(info, nmtd, sets);
>>
>>               nmtd->scan_res = nand_scan_ident(&nmtd->mtd,
>
> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>
