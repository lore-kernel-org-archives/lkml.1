Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbXLLISs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbXLLISs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbXLLISk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:18:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:39566 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbXLLISj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:18:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cJ8pOzjeMcVNc0XP3jg4s1W7dZNzLBbXRJoWDuij1D9zaBteB3OuZ2iEZKBL1JvzCUUpBaAQXFpAHilsKRmycx8ECragrI9DhpSli2x5gfWbmtoXfCvE0I6Ze3OiFnIkY+ahok9g+hFX2j/0pEt7Yrcz+KZ+fnwygq9VkC4aqT4=
Message-ID: <475F994B.9090505@gmail.com>
Date: Wed, 12 Dec 2007 17:18:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kuan Luo <kluo@nvidia.com>
CC: Jeff Garzik <jeff@garzik.org>, peer chen <peerchen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv,adma: fix error when rmmod sata_nv
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org> <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com> <47181CE1.4000802@garzik.org> <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com> <47185BFD.2010909@garzik.org> <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com> <47352DD8.6040607@garzik.org> <47353AE8.5050900@garzik.org> <4735FFE6.6020705@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AAB@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AAB@hkemmail01.nvidia.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> hi,
> The below error happens when i rmmod sata_nv in adma mode on ck804
> chipset with 2.6.24 kernel.
> I traced the code and found that the driver attempts to write device mem
> that has been unmapped.
> 
> Only simply removing the code" writew(0, mmio + NV_ADMA_CTL);" in the
> nv_adma_port_stop function or remove .port_stop field in nv_adma_ops,
> rmmod is ok.
> 
> static void nv_adma_port_stop(struct ata_port *ap)
> {
> 	struct nv_adma_port_priv *pp = ap->private_data;
> 	void __iomem *mmio = pp->ctl_block;
> 
> 	VPRINTK("ENTER\n");
> -	writew(0, mmio + NV_ADMA_CTL);
> }
> 
> Or
>  Place pcim_iomap_regions before ata_pci_prepare_native_host in
> nv_init_one function.
> This can guarantee that the code "writew(0, mmio + NV_ADMA_CTL) " write
> device mem before the device mem is unmapped.

Which kernel version are you using?  The following commit should have
fixed the problem.  Please give a shot at 2.6.24-rc5.  Thanks.

commit 32ebbc0c0d5d18c0135b55d1eb0029f48c54aff0
Author: Tejun Heo <htejun@gmail.com>
Date:   Thu Nov 8 13:09:00 2007 +0900

libata: port and host should be stopped before hardware resources are
released

-- 
tejun
