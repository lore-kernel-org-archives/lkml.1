Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYIZIJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYIZIJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYIZIJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:09:13 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:35006 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYIZIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:09:10 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 04:09:10 EDT
Date: Fri, 26 Sep 2008 13:31:26 +0530
From: Amit Kumar Sharma <amitsharma.9@samsung.com>
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
To: dedekind@infradead.org, Kyungmin Park <kmpark@infradead.org>
Cc: apgmoorthy <moorthy.apg@samsung.com>, linux-mtd@lists.infradead.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       lkml <linux-kernel@vger.kernel.org>
Message-id: <A09E9029F2344F78959A3E36179C468E@sisodomain.com>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
X-RFC2646: Format=Flowed; Original
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
 <1222404711.5012.5.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem

we have following erro message  if we maintain 64 bytes 
eccpos.

/flash_eraseall -j /dev/mtd4
./flash_eraseall: /dev/mtd4: unable to get NAND oobinfo

./nandwrite -j /dev/mtd2 /jffs2.img
MEMSETOOBSEL: Inappropriate ioctl for device

but i think as OneNAND has hw ecc controller so Jffs2 will 
not face any problem
still i think mtd should consider for 128 bytes eccpos for 
4K page size.

Rgs
Amit

----- Original Message ----- 
From: "Artem Bityutskiy" <dedekind@infradead.org>
To: "Kyungmin Park" <kmpark@infradead.org>
Cc: "apgmoorthy" <moorthy.apg@samsung.com>; 
<linux-mtd@lists.infradead.org>; "Kyungmin Park" 
<kyungmin.park@samsung.com>; "lkml" 
<linux-kernel@vger.kernel.org>
Sent: Friday, September 26, 2008 10:21 AM
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD 
Driver available.


>
> On Fri, 2008-09-26 at 09:31 +0900, Kyungmin Park wrote:
>> Hi,
>>
>> A few comments
>>
>> >
>> > Signed-off-by: Vishak G <vishak.g@samsung.com>
>> > Signed-off-by: Rohit Hagargundgi <h.rohit@samsung.com>
>>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> > ---
>> > diff -uprN a/drivers/mtd/onenand/onenand_base.c
>> > b/drivers/mtd/onenand/onenand_base.c
>> > --- a/drivers/mtd/onenand/onenand_base.c 
>> > 2008-09-16
>> > 20:48:12.000000000 +0530
>> > +++ b/drivers/mtd/onenand/onenand_base.c 
>> > 2008-09-24
>> > 17:51:34.000000000 +0530
>> > @@ -9,6 +9,10 @@
>> >  *     auto-placement support, read-while load support, 
>> > various fixes
>> >  *     Copyright (C) Nokia Corporation, 2007
>> >  *
>> > + *     Vishak G <vishak.g@samsung.com>, Rohit 
>> > Hagargundgi
>> > <h.rohit@samsung.com>
>> > + *     Flex-OneNAND support
>> > + *     Copyright (C) Samsung Electronics, 2008
>> > + *
>> >  * This program is free software; you can redistribute 
>> > it and/or modify
>> >  * it under the terms of the GNU General Public License 
>> > version 2 as
>> >  * published by the Free Software Foundation.
>> > @@ -27,6 +31,37 @@
>> >
>> >  #include <asm/io.h>
>> >
>> > +const static int boundary[] = {
>> > +       FLEXONENAND_DIE0_BOUNDARY,
>> > +       FLEXONENAND_DIE1_BOUNDARY,
>> > +};
>> > +
>> > +const static int lock[] = {
>> > +       FLEXONENAND_DIE0_ISLOCKED,
>> > +       FLEXONENAND_DIE1_ISLOCKED,
>> > +};
>> > +
>>
>> static const as others.
>>
>>
>> > diff -uprN a/include/mtd/mtd-abi.h 
>> > b/include/mtd/mtd-abi.h
>> > --- a/include/mtd/mtd-abi.h     2008-09-16 
>> > 20:48:12.000000000 +0530
>> > +++ b/include/mtd/mtd-abi.h     2008-09-24 
>> > 14:09:06.000000000 +0530
>> > @@ -102,7 +102,11 @@ struct nand_oobinfo {
>> >        uint32_t useecc;
>> >        uint32_t eccbytes;
>> >        uint32_t oobfree[8][2];
>> > +#ifdef CONFIG_MTD_ONENAND
>> > +       uint32_t eccpos[128];
>> > +#else
>> >        uint32_t eccpos[32];
>> > +#endif
>> >  };
>> >
>> >  struct nand_oobfree {
>> > @@ -117,7 +121,11 @@ struct nand_oobfree {
>> >  */
>> >  struct nand_ecclayout {
>> >        uint32_t eccbytes;
>> > +#ifdef CONFIG_MTD_ONENAND
>> > +       uint32_t eccpos[128];
>> > +#else
>> >        uint32_t eccpos[64];
>> > +#endif
>> >        uint32_t oobavail;
>> >        struct nand_oobfree 
>> > oobfree[MTD_MAX_OOBFREE_ENTRIES];
>> >  };
>
> I do not think stuff like this is going to be accepted 
> because you
> change ABI. You should instead introduce new ioctls or add 
> sysfs
> support and expose this information via sysfs. This is 
> much bigger
> work, but it is needed.
>
> -- 
> Best regards,
> Artem Bityutskiy (???????? ?????)
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 


