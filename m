Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYGKVov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYGKVov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbYGKVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:44:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53637 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753872AbYGKVom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:44:42 -0400
From: John Keller <jpk@sgi.com>
Message-Id: <200807112144.m6BLiWIQ414755@fcbayern.americas.sgi.com>
Subject: Re: x86: PCI multi domain/segment config access
To: matthew@wil.cx (Matthew Wilcox)
Date: Fri, 11 Jul 2008 16:44:32 -0500 (CDT)
Cc: jpk@sgi.com (John Keller), linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20080711212117.GW14894@parisc-linux.org> from "Matthew Wilcox" at Jul 11, 2008 03:21:17 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Jul 11, 2008 at 04:13:47PM -0500, John Keller wrote:
> > On x86 PCI Config space access to domains/segments > 0 appears to be broken.
> > The noted patch related to PCI ext config space has all config accesses
> > to offsets < 256 using conf1 if available, which is most likely the case.
> > 
> > This would force usage of conf1 for non-extended config access (< 256) on
> > PCI domains > 0.
> > 
> > Am I missing something, or how would a conf1 access reference a domain
> > other than zero?
> 
> You're correct.  Sorry about that, I wasn't thinking about domains at
> the time I wrote the patch.  Try this:

Yup, just what we were thinking.
Works fine.

Acked-by: John Keller <jpk@sgi.com>



> 
> [X86] Fix PCI config space for domains > 0
> 
> John Keller reports that PCI config space access is broken on machines
> with more than one domain.  conf1 accesses only work for domain 0.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 6e64aaf..fe33533 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -31,7 +31,7 @@ struct pci_raw_ops *raw_pci_ext_ops;
>  int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
>  						int reg, int len, u32 *val)
>  {
> -	if (reg < 256 && raw_pci_ops)
> +	if (domain == 0 && reg < 256 && raw_pci_ops)
>  		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
>  	if (raw_pci_ext_ops)
>  		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
> @@ -41,7 +41,7 @@ int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
>  int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
>  						int reg, int len, u32 val)
>  {
> -	if (reg < 256 && raw_pci_ops)
> +	if (domain == 0 && reg < 256 && raw_pci_ops)
>  		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
>  	if (raw_pci_ext_ops)
>  		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> 

