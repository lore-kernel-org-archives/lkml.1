Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZDUReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZDUReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZDURe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:34:27 -0400
Received: from exchtp08.via.com.tw ([61.66.243.7]:57810 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZDURe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:34:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [Patch 1/1 v5] via-sdmmc: VIA MSP card reader driver support
Date: Wed, 22 Apr 2009 01:35:29 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8090CA2D4@exchtp03.taipei.via.com.tw>
In-Reply-To: <20090410203520.6e43acb2@mjolnir.ossman.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 1/1 v5] via-sdmmc: VIA MSP card reader driver support
Thread-Index: Acm6CyT5VMNQxz3VRLiv1sXGebe4MgIm4GYA
From: <JosephChan@via.com.tw>
To: <drzeus-mmc@drzeus.cx>
Cc: <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <ben-linux@fluff.org>
X-OriginalArrivalTime: 21 Apr 2009 17:34:24.0570 (UTC) FILETIME=[69B709A0:01C9C2A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3LHYequ030542

Pierre,

Sorry for the late reply due to my HDD was crashed few days ago.
We will do what you suggest in next release. Please also see the reply in lines. 
Thanks.

BRs,
Joseph 

-----Original Message-----
From: Pierre Ossman [mailto:drzeus-mmc@drzeus.cx] 
>> +nodata:
>> +	if (cmd->opcode == MMC_STOP_TRANSMISSION)
>> +		cmdctrl |= VIA_CRDR_SDCTRL_STOP;
> >+

>I didn't check this part properly the last time. I'm assuming you're telling the hardware that this is a command that terminates a data transmission? If so, you cannot check the opcode like that. There might be other stop commands.
>What you need to do is to either pass another parameter to your function when you're calling it with data->stop, or simply have a test in there if cmd == data->stop (or mrq->stop, whichever is most convenient).

OK, we will change to 
       if(cmd == host->mrq->stop)
             cmdctrl |= VIA_CRDR_SDCTRL_STOP;

>> +	else if (ios->clock >=  5000000)
>> +		clock = PCI_CLK_8M;
>>+	else
>>+		clock = PCI_CLK_375K;
>>+

> This looks a bit strange. Why are you not comparing with the clock frequency you'll be setting?

Do you mean that we should check the current clock frequency before setting?  But our engineer thinks that the following lines can do that work normally too:
Any comment? 

              else if (ios->clock >=  5000000)
                     clock = PCI_CLK_8M;
              else
                     clock = PCI_CLK_375K;

              addrbase = host->pcictrl_mmiobase; 

              if (readb(addrbase + VIA_CRDR_PCISDCCLK) != clock)
                     writeb(clock, addrbase + VIA_CRDR_PCISDCCLK);


>> +
>> +	mmc->f_min = VIA_CRDR_MIN_CLOCK;
>> +	mmc->f_max = VIA_CRDR_MAX_CLOCK;
>> +	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34 | MMC_VDD_165_195;
>> +	mmc->caps = MMC_CAP_4_BIT_DATA;

> You also need to set the bits stating if the controller supports the high-speed SD and/or MMC mode, otherwise the core won't go over 25/20 MHz.


OK, we will add the following line in the via_init_mmc_host function:

       mmc->caps |= MMC_CAP_MMC_HIGHSPEED |MMC_CAP_SD_HIGHSPEED;

And, we will add the following source code to the via_sdc_set_ios function: 

       org_data = readl(addrbase + VIA_CRDR_SDEXTCTRL);

       if ((ios->timing == MMC_TIMING_SD_HS) || (ios->timing == MMC_TIMING_MMC_HS))
              org_data |= VIA_CRDR_SDEXTCTRL_HISPD;
       else
              org_data &= ~VIA_CRDR_SDEXTCTRL_HISPD;

       writel(org_data, addrbase + VIA_CRDR_SDEXTCTRL);       
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
