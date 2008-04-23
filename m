Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYDWM1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYDWM1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYDWM1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:27:30 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:42208 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYDWM13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:27:29 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH] pci_try_set_mwi() in sata_promise
Date: Wed, 23 Apr 2008 15:31:20 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
References: <200804222126.56321.mitov@issp.bas.bg> <18446.60365.156326.246875@harpo.it.uu.se>
In-Reply-To: <18446.60365.156326.246875@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231531.20803.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.4.2008, Mikael Pettersson wrote:
> Marin Mitov writes:
>  > Hi all,
>  > 
>  > The BIOS (Asus A8V Deluxe) is setting incorrectly PCI
>  > Cache Line Size Register (as seen in lspci -vvv output), 
>  > so try to correct it by pci_try_set_mwi(pdev).
>  > 
>  > Marin Mitov
>  > ----------------------------------------------------------
>  > Enable Memory-Write-and-Invalidate in sata_promise driver and 
>  > get rid of strange BIOS-set value for cache line size register.
>  > 
>  > According to Documentation/pci.txt:  "This enables...
>  > ...and also ensures that the cache line size register
>  > is set correctly".
>  > 
>  > Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
>  > ----------------------------------------------------------
>  > --- a/drivers/ata/sata_promise.c	2008-04-22 13:09:15.000000000 +0300
>  > +++ b/drivers/ata/sata_promise.c	2008-04-22 13:11:01.000000000 +0300
>  > @@ -1114,6 +1114,7 @@ static int pdc_ata_init_one(struct pci_d
>  > 
>  >  	/* start host, request IRQ and attach */
>  >  	pci_set_master(pdev);
>  > +	pci_try_set_mwi(pdev);
>  >  	return ata_host_activate(host, pdev->irq, pdc_interrupt, IRQF_SHARED,
>  >  				 &pdc_ata_sht);
>  >  }
>  > 
> 
> Not enough information here.
> 
> 0. Please post lspci -vvvx including all PCI devices.
Here it is:


> 1. What consequence does the incorrect cache line size setting have?

None if MWI is not enabled.

> 2. What improvement does that pci_try_set_mwi() cause? Speed? Fewer errors?

May be speed, but practicaly hardly observable. It is described in PCI specs. 
If the hardware has this property why not using it? In any case that does not hurt.

> 3. Why call pci_try_set_mwi()? Can't you set the cache line size directly?

pci_set_cacheline_size() is NOT exported, while pci_try_set_mwi() is and
sets (as a side effect) the cache line size.

> 4. You write "try to correct it". So the "fix" might not work? Then what?

It fails only if cache line size cannot be set. Then MWI is not enabled.
The device continues to work (nicely) as it did up to now.

> 5. Is the problem specific for the Promise chip? That is:
>    a) are any other built-in PCI devices affected by this BIOS bug?
>    b) if you add a PCI card (of any kind), does it also
>       get the incorrect cache line size setting?
> 6. Are you running the latest BIOS?
> 
> To me it sounds like this is a generic PCI bug on that
> machine, and so should be handled by the kernel's PCI layer.
> But if the problem really is specific to the built-in Promise
> chip on that machine, then I can see why a workaround in
> sata_promise could be appropriate.
> 
> /Mikael
> 


