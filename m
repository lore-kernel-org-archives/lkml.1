Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZAMIAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZAMIAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZAMIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:00:24 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:59561 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZAMIAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F7b9GjG5BsrG2kpRvVN99MMo7fWgihxPgHq4EVS0EvoDrnTrcF0aV5dYDLXiHIanTB
         SbvgUwb1xEek2ObvBhgn+WB4OMkxucdY0UzgOUCs73ud4WQu92hBSrxvZAnv9PUgJFEw
         1J9/8hzoLUTQaZKZ50vxOis3UjCO01uD2vfLM=
MIME-Version: 1.0
In-Reply-To: <20090112162044.2bc12cef@mjolnir.drzeus.cx>
References: <a0e7fce50901081953h7ae152a7y557794c07fbb843b@mail.gmail.com>
	 <20090112162044.2bc12cef@mjolnir.drzeus.cx>
Date: Tue, 13 Jan 2009 16:00:21 +0800
Message-ID: <a0e7fce50901130000u36528132jc3a9ecbd9084b043@mail.gmail.com>
Subject: Re: [BUG] MMC/SD: SDHC card capacity not correct
From: yi li <liyi.dev@gmail.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:20 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
>
> Odd. Is the entire device accessible? (I.e. is it just a printk
> problem?)
>

It is a printk problem.

> Could you give me a dmesg dump with MMC_DEBUG turned on in Kconfig?
>

I did debug on my side (I think it is more easy to reproduce here :-)
).  The issue is in mmc/card/block.c: mmc_block_probe().

"string_get_size(get_capacity(md->disk) << 9, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
"
get_capacity() returns a type "sector_t" value, since I am working on
a 32-bit processor (Analog Devices BF537),
and I did not enable CONFIG_LBD, "sector_t" is actually a 32-bit
"unsigned long".  So  "get_capacity(md->disk) << 9" loses the MSB.

I can think of two fixes:

1. Set CONFIG_LBD
2. Fix like this:
--- card/block.c	2009-01-13 15:56:05.000000000 +0800
+++ card/block.c.new	2009-01-13 15:53:45.000000000 +0800
@@ -514,7 +514,7 @@ static int mmc_blk_probe(struct mmc_card
 	if (err)
 		goto out;

-	string_get_size(get_capacity(md->disk) << 9, STRING_UNITS_2,
+	string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
 	printk(KERN_INFO "%s: %s %s %s %s\n",
 		md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),

I prefer the second fix, what do you think?

Regards,

-Li Yi
