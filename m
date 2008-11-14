Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYKNWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYKNWHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKNWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:07:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:3301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYKNWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S6UqzCcW2RUGSaWhi6xeVfmxEkel7YIRxV3gxGSVFIZNgeSUr2yFcpIKVlwRyBtMa5
         2wWrpfAvLScrQ3wJ08HM0MrQhcVnPKRmw+iZXyUEn2lIjLVh8Y1rfpMyYsgQqeG+lzE9
         aLd1DTd+ahVkMEVy89+RYHoDoTI0t2Zd+74cc=
Message-ID: <8bd0f97a0811141407nde33c5tb90536c4983b53b4@mail.gmail.com>
Date: Fri, 14 Nov 2008 17:07:38 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mtd/physmap: use parse_mtd()
Cc: "Mike Frysinger" <vapier@gentoo.org>, linux-mtd@lists.infradead.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081114134116.972fce2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	 <1226533189-8492-1-git-send-email-vapier@gentoo.org>
	 <20081114134116.972fce2f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 16:41, Andrew Morton wrote:
> On Wed, 12 Nov 2008 18:39:48 -0500
> Mike Frysinger <vapier@gentoo.org> wrote:
>> Call parse_mtd() to handle partition/device registration rather than doing
>> it all ourself.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>>  drivers/mtd/maps/physmap.c |   21 +--------------------
>>  1 files changed, 1 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
>> index 42d844f..9b87fd8 100644
>> --- a/drivers/mtd/maps/physmap.c
>> +++ b/drivers/mtd/maps/physmap.c
>> @@ -84,9 +84,6 @@ static int physmap_flash_remove(struct platform_device *dev)
>>  }
>>
>>  static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", "map_rom", NULL };
>> -#ifdef CONFIG_MTD_PARTITIONS
>> -static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
>> -#endif
>>
>>  static int physmap_flash_probe(struct platform_device *dev)
>>  {
>> @@ -170,23 +167,7 @@ static int physmap_flash_probe(struct platform_device *dev)
>>       if (err)
>>               goto err_out;
>>
>> -#ifdef CONFIG_MTD_PARTITIONS
>> -     err = parse_mtd_partitions(info->cmtd, part_probe_types, &info->parts, 0);
>> -     if (err > 0) {
>> -             add_mtd_partitions(info->cmtd, info->parts, err);
>> -             return 0;
>> -     }
>> -
>> -     if (physmap_data->nr_parts) {
>> -             printk(KERN_NOTICE "Using physmap partition information\n");
>> -             add_mtd_partitions(info->cmtd, physmap_data->parts,
>> -                                physmap_data->nr_parts);
>> -             return 0;
>> -     }
>> -#endif
>> -
>> -     add_mtd_device(info->cmtd);
>> -     return 0;
>> +     return parse_mtd(info->cmtd, NULL, physmap_data->parts, physmap_data->nr_parts);
>>
>>  err_out:
>>       physmap_flash_remove(dev);
>
> This didn't apply due to
> physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch.  I
> just smashed it in anyway.  Should I drop
> physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
> instead?  Your changelog mentioned nothing about leak-fixing?

i'd like feedback from the main mtd guy(s) first, but if you're going
to queue things, it should be with v2 that i posted rather than this
set.

while mine doesnt explicitly mention leak fixing, it does fix it in
the process of moving code about.  so if you do add v2, you can safely
drop the leak fix.
-mike
