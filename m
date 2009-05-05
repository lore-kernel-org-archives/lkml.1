Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZEEEbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZEEEbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZEEEbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:31:40 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:52823 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZEEEbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yrr1IqBcSIx42lEDk5FLkFoVUiKZ3YvQ2GrUj2XMoO6UBrxl67/pEynS8OWvhPoArk
         TWmkIBklOom+6tG6rmJP2+yThI4eB3QGSaDTdgDUPrfFf/QBkf4B1qFzDTGmp//djnLO
         s8w9Y3EC5ii/KzyLoBidJrXq0uVEkjebn8vi4=
MIME-Version: 1.0
In-Reply-To: <da824cf30905041858t2cbd0fa2x4075f387973e2700@mail.gmail.com>
References: <egHshlwQQFE.A.8CD.mpE9JB@chimera>
	 <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030904280218v61fded68rc585ce9c58ba1cce@mail.gmail.com>
	 <20090428184431Z.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
	 <da824cf30905041858t2cbd0fa2x4075f387973e2700@mail.gmail.com>
Date: Mon, 4 May 2009 21:31:39 -0700
Message-ID: <b1bc6a000905042131t3656f14arc98dc4a518543a86@mail.gmail.com>
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: adam radford <aradford@gmail.com>
To: Grant Grundler <grundler@google.com>
Cc: =?KOI8-U?B?5MHOyczBIPbVy8/Dy8nK?= <optimusgd@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=KOI8-U
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/4 Grant Grundler <grundler@google.com>:
> 2009/5/3 Данила Жукоцкий <optimusgd@gmail.com>:
> ...
>> WARNING: at lib/dma-debug.c:607 check_unmap+0x542/0x610()
>> Hardware name: HP xw9400 Workstation
>> 3w-9xxx 0001:45:00.0: DMA-API: device driver tries to free DMA memory
>> it has not allocated [device address=0x0000000000000000] [size=36
>> bytes]
>
> This is definitely a driver bug. Just follow the stack trace back to
> the device driver.
>

I think this is a regression from the scsi_dma_map()/unmap() changes a while
back.

Can you try this patch?

Thanks,

-Adam

diff -Naur linux-2.6.30-rc4/drivers/scsi/3w-9xxx.c
linux-2.6.30-rc4.new/drivers/scsi/3w-9xxx.c
--- linux-2.6.30-rc4/drivers/scsi/3w-9xxx.c	2009-05-04 21:19:49.000000000 -0700
+++ linux-2.6.30-rc4.new/drivers/scsi/3w-9xxx.c	2009-05-04
21:23:59.000000000 -0700
@@ -1978,7 +1978,8 @@
 {
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];

-	scsi_dma_unmap(cmd);
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
 } /* End twa_unmap_scsi_data() */

 /* scsi_host_template initializer */
