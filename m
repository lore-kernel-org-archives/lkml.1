Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYLVXok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYLVXok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYLVXo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:44:28 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:65402 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYLVXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:44:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AEOn1/xRI4NWvgQWCd1aEBfhkcS4pylBrALaytCRpO5mcWJJj3wfP39FaTZ5ATU8r1
         XICXYV5+NqycitILO1pcPYxwWwiJCftUkBc7Qh/iSfTo6QNIorgH26q7izaRcoWTm1hG
         f8T1eHsW96IRLx1zSr2ZRHut6QMRpFZRkLCRY=
Message-ID: <a01a16b50812221544x45c3559ap808ac0095ee8f01@mail.gmail.com>
Date: Tue, 23 Dec 2008 00:44:25 +0100
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [PATCH 02/27] drivers/net: fix sparse warnings: make do-while a compound statement
Cc: "Hannes Eder" <hannes@hanneseder.net>, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m3hc4voo2a.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	 <20081222191507.11807.50794.stgit@vmbox.hanneseder.net>
	 <m3hc4voo2a.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBMNiiki024762

2008/12/22 Krzysztof Halasa <khc@pm.waw.pl>:>> --- a/drivers/net/starfire.c>> +++ b/drivers/net/starfire.c>> @@ -882,9 +882,9 @@ static int mdio_read(struct net_device *dev, int phy_id, int location)>>       void __iomem *mdio_addr = np->base + MIICtrl + (phy_id<<7) + (location<<2);>>       int result, boguscnt=1000;>>       /* ??? Should we add a busy-wait here? */>> -     do>> +     do {>>               result = readl(mdio_addr);>> -     while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);>> +     } while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);>>       if (boguscnt == 0)>>               return 0;>>       if ((result & 0xffff) == 0xffff)>>> I don't know how one could think the above is an improvement.
For this specific issue the important aspect is to improve readability(and not just eventually satisfy some warning from a tool), which Iassume there is no disagrement on. Now what constitutes improvedreadbility on the other hand is another issue, and I guess there arenext to as many oppinions as developers... :)I would most certainly prefer to have code look consistently and alwayshave brackets, even in the case of just one body line.
Of secondary importance is the benefit that always using bracketsmakes them much more merge friendly. Consider the following scenario:
Common base:        do                result = readl(mdio_addr);        while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);
Branch 1        do {                result = readl(mdio_addr);                do_something();        } while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);
Branch 2        do                result = readl(mdio_addr);        while (NOT_OK(result) && --boguscnt > 0);
In this case if both branch 1 and 2 are merged, there will be a merge conflictthat has to be resolved manually. If the brackets had been in place from thestart tools should be able to resolv this automatically.
BR HÃ¥kon LÃ¸vdalÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
