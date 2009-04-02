Return-Path: <linux-kernel-owner+w=401wt.eu-S935221AbZDBKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935221AbZDBKyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZDBKyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:54:05 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:34401 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752445AbZDBKyB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:54:01 -0400
X-BigFish: VPS-33(z34a4jz1432R98dR936eQ1805M936fK10d1Izz1202hzzz32i6bh43j)
X-FB-SS: 5,
X-WSS-ID: 0KHGZLG-04-0T5-01
Date: Thu, 2 Apr 2009 12:54:15 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Dave Jones <davej@redhat.com>, <tglx@linuxtronix.de>, <mingo@redhat.com>,
       <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
	frees DMA memory with different size
Message-ID: <20090402105415.GD21083@amd.com>
References: <20090401172708.GA11941@redhat.com> <20090401110245.4d1ddf72@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090401110245.4d1ddf72@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Apr 2009 10:53:42.0177 (UTC) FILETIME=[497BC110:01C9B381]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 11:02:45AM -0700, Stephen Hemminger wrote:
> 
> The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
> platforms are meaningless so they are stubbed out. 
> Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.

As far as I know the VT-d driver is available on 32 bit x86 too. So this should
not always be a nop.
The other question is why pci_unmap_* functions are not defined as a nop too
and call dma_unmap_* instead? This looks inconsisent to me.

> ========================================================
> Unstub pci_unmap macros if doing DMA-API checks
> 
> If doing device driver DMA-API tests then need to keep track of address/length
> even on 32-bit x86 where the information is not normally needed.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> 
> --- a/arch/x86/include/asm/pci_32.h	2009-04-01 10:52:07.117504355 -0700
> +++ b/arch/x86/include/asm/pci_32.h	2009-04-01 10:56:02.249066174 -0700
> @@ -17,16 +17,25 @@ struct pci_dev;
>   */
>  #define PCI_DMA_BUS_IS_PHYS	(1)
>  
> +#ifdef CONFIG_DMA_API_DEBUG
> +/* keep real values */
> +#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
> +#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
> +#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
> +#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
> +#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
> +#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
> +#else
>  /* pci_unmap_{page,single} is a nop so... */
>  #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
> -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
> -#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
> +#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME[0];
> +#define pci_unmap_addr(PTR, ADDR_NAME)		sizeof((PTR)->ADDR_NAME)
>  #define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
>  	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
>  #define pci_unmap_len(PTR, LEN_NAME)		sizeof((PTR)->LEN_NAME)
>  #define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
>  	do { break; } while (pci_unmap_len(PTR, LEN_NAME))
> -
> +#endif

I think we need another solution which takes into account that there might be
VT-d enabled and which defines the pci_unmap_* functions also as a nop when it
is not. I suggest to make a CONFIG option for these functions nit being a nop
and let DMA_API_DEBUG select it on x86. So we get proper checking for drivers
on 32bit x86 too which helps other architectures where these drivers can be
used.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

