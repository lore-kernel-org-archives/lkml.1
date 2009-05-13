Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbZEMEls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbZEMEls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZEMElf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:41:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43473 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZEMEle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:41:34 -0400
Message-ID: <4A0A4F4A.7030101@jp.fujitsu.com>
Date: Wed, 13 May 2009 13:40:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix MSI-X with NIU cards
References: <20090508131333.GV8112@parisc-linux.org> <1242004911.7767.26.camel@concordia> <4A0A472A.8090301@jp.fujitsu.com>
In-Reply-To: <4A0A472A.8090301@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> It seems that this issue was introduced by Matthew's commit:
> commit f2440d9acbe866b917b16cc0f927366341ce9215
> <quote>
> @@ -435,11 +432,12 @@ static int msix_capability_init(struct pci_dev *dev,
>                 entry->msi_attrib.is_msix = 1;
>                 entry->msi_attrib.is_64 = 1;
>                 entry->msi_attrib.entry_nr = j;
> -               entry->msi_attrib.maskbit = 1;
> -               entry->msi_attrib.masked = 1;
>                 entry->msi_attrib.default_irq = dev->irq;
>                 entry->msi_attrib.pos = pos;
>                 entry->mask_base = base;
> +               entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
> +                                       PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> +               msix_mask_irq(entry, 1);
> 
>                 list_add_tail(&entry->list, &dev->msi_list);
>         }
> </quote>
> 
> I'm not sure why Matthew changed it to read/write...

Sorry, I got it.

The problem is not the bit[0] for mask, but the reserved bits[31::01].
According to the Spec:
"31::01 Reserved 
  After reset, the state of these bits must be 0.
  However, for potential future use, software must preserve the value of
  these reserved bits when modifying the value of other Vector Control bits.
  If software modifies the value of these reserved bits, the result is
  undefined."

I'll post a revised fix soon.

Thanks,
H.Seto

