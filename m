Return-Path: <linux-kernel-owner+w=401wt.eu-S1161200AbXCNMRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161200AbXCNMRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161208AbXCNMRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:17:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:62277 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161200AbXCNMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OvA+b+QSBcOlLx12vOKd64ugFD3eha2HHQaiDmEayfym7DFt2Vs5N/BPOctpoH2c7zKRfT2OeHZvtqMnczkYjmInNwg6grQEXX1xU99FwUR5aDBKKXRVN0S3VVfxTwKLM6t5PTZTN+62bbVWjedpOxxOpW9nxM2zRRyr03pwM+Y=
Message-ID: <45F7E7E9.6010703@gmail.com>
Date: Wed, 14 Mar 2007 21:17:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>
In-Reply-To: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Conke Hu wrote:
>    When there is no media in SATA CD/DVD drive or media is not ready,
> AHCI controller fails to execute the ATAPI commands TEST_UNIT_READY,
> READ_CAPACITY or READ_TOC and reports PORT_IRQ_TF_ERR. But ATI SB600
> SATA controller sets SERR_INTERNAL bit in the error register at the
> same time, which is not necessary. This patch is just to ignore the
> INTERNAL ERROR in such case. Without this patch, ahci error handler
> will report many errors as below:

Whoa, SERR_INTERNAL on ATAPI check condition?  Just for fun, here's what
the spec says about SERR_INTERNAL.

E  Internal error: The host bus adapter experienced an internal error
that caused the operation to fail and may have put the host bus adapter
into an error state. Host software should reset the interface before
re-trying the operation. If the condition persists, the host bus adapter
may suffer from a design issue rendering it incompatible with the
attached device.

Anyways thanks for fixing this.  Just a few comments.

> --- linux-2.6.21-rc3-git8/drivers/ata/ahci.c.orig    2007-03-25
> 20:57:31.000000000 +0800
> +++ linux-2.6.21-rc3-git8/drivers/ata/ahci.c    2007-03-25
> 21:03:54.000000000 +0800
> @@ -80,6 +80,7 @@ enum {
>     board_ahci_pi        = 1,
>     board_ahci_vt8251    = 2,
>     board_ahci_ign_iferr    = 3,
> +    board_ahci_ati    = 4,
> 
>     /* global controller registers */
>     HOST_CAP        = 0x00, /* host capabilities */
> @@ -168,6 +169,7 @@ enum {
>     AHCI_FLAG_NO_NCQ        = (1 << 24),
>     AHCI_FLAG_IGN_IRQ_IF_ERR    = (1 << 25), /* ignore IRQ_IF_ERR */
>     AHCI_FLAG_HONOR_PI        = (1 << 26), /* honor PORTS_IMPL */
> +    AHCI_FLAG_TF_ERR_FIX    = (1 << 27), /* ignore INTERNAL ERROR on
> IRQ_TF_ERROR */

Can we use board_ahci_ign_interr and AHCI_FLAG_IGN_SERR_INTERNAL to keep
it more consistent with the other IGN flag?

> -    { PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
> +    { PCI_VDEVICE(ATI, 0x4380), board_ahci_ati }, /* ATI SB600 non-raid */
>     { PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */

4381 isn't affected while 4380 is?

Hmmm... Okay, this is weird.  I'm feeling very strong deja vu.

Well, I must be getting alzheimer.  I did almost the same patch a month
ago and was waiting for verification to properly submit the patch.

  http://thread.gmane.org/gmane.linux.ide/16049/focus=16437

Anyways, Conke Hu, can you please take a look at my patch from a month
ago?  It's almost identical but SERR_INTERNAL is always ignored on both
SB600 PCI IDs, which I think is safer.  Does this fix what you're seeing?

Thanks.

-- 
tejun
