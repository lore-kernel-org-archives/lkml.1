Return-Path: <linux-kernel-owner+w=401wt.eu-S1761014AbZEMQ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014AbZEMQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbZEMQzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:55:46 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:44565 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760926AbZEMQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:55:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KhO8TyFFe8OpnLZhl7UmlLPs3fHQJb9cQBQQA5lQEs0wz0XyaaWHnSxBdxFc4ylsIH/QsB1b1NqZ8I8/06xI4iwx44F6DmISAtW2VFEeaoFBirf8E2riBLOWApZ1sCUi;
Date: Wed, 13 May 2009 09:55:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
Message-ID: <20090513095535.140134e1@jbarnes-g45>
In-Reply-To: <1242164891-3859-7-git-send-email-jeremy@goop.org>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>
	<1242164891-3859-7-git-send-email-jeremy@goop.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 14:48:07 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Alex Nixon <alex.nixon@citrix.com>
> 
> Xen may want to enable scanning of all pci functions - if for example
> the device at function 0 is not passed through to the guest, but the
> device at function 1 is.
> 
> [Impact: allow passthrough of just some PCI functions.]
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  arch/x86/include/asm/pci.h |    8 +++++++-
>  arch/x86/pci/common.c      |    1 +
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index b51a1e8..092706e 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -21,6 +21,7 @@ struct pci_sysdata {
>  extern int pci_routeirq;
>  extern int noioapicquirk;
>  extern int noioapicreroute;
> +extern int pci_scan_all_fns;
>  
>  /* scan a bus after allocating a pci_sysdata for it */
>  extern struct pci_bus *pci_scan_bus_on_node(int busno, struct
> pci_ops *ops, @@ -48,7 +49,11 @@ extern unsigned int
> pcibios_assign_all_busses(void); #else
>  #define pcibios_assign_all_busses()	0
>  #endif
> -#define pcibios_scan_all_fns(a, b)	0
> +
> +static inline int pcibios_scan_all_fns(struct pci_bus *bus, int
> devfn) +{
> +	return pci_scan_all_fns;
> +}
>  
>  extern unsigned long pci_mem_start;
>  #define PCIBIOS_MIN_IO		0x1000
> @@ -130,6 +135,7 @@ extern void pci_iommu_alloc(void);
>  
>  /* generic pci stuff */
>  #include <asm-generic/pci.h>
> +#undef pcibios_scan_all_fns

This is a little gross... But then I don't see any places where it's
actually defined to something true either.  Maybe it should be a weak
function or a new HAVE_FOO define instead.

-- 
Jesse Barnes, Intel Open Source Technology Center
