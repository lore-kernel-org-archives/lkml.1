Return-Path: <linux-kernel-owner+w=401wt.eu-S1764055AbXGOAlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764055AbXGOAlG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbXGOAkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:40:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47516 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXGOAkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:40:55 -0400
Message-ID: <46996D12.40501@garzik.org>
Date: Sat, 14 Jul 2007 20:40:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/12] drivers/isdn/hisax/avm_pci.c: replace pci_find_device
 with pci_get_device
References: <200707140144.20855.caglar@pardus.org.tr>
In-Reply-To: <200707140144.20855.caglar@pardus.org.tr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> @@ -858,5 +858,10 @@ ready:
>  	cs->irq_func = &avm_pcipnp_interrupt;
>  	cs->writeisac(cs, ISAC_MASK, 0xFF);
>  	ISACVersion(cs, (cs->subtyp == AVM_FRITZ_PCI) ? "AVM PCI:" : "AVM PnP:");
> +	pci_dev_put(dev_avm);
>  	return (1);
> +
> +dev_avm_cleanup:
> +	pci_dev_put(dev_avm);
> +	return (0);
>  }


NAK -- every single one of these patches is wrong.  All you did was make 
the warning go away, while INTRODUCING new lifetime problems.

The ISDN PCI driver obviously continues execution after the setup 
function ends, yet you pci_dev_put() the device at the end of setup.  As 
a result, no reference is held even though we continue using the device.

	Jeff


