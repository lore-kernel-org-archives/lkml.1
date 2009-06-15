Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbZFOSkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbZFOSkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZFOSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:39:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZFOSj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:39:57 -0400
Date: Mon, 15 Jun 2009 20:39:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] WARN(): add a \n to the message printk
Message-ID: <20090615183940.GF11248@elte.hu>
References: <20090615000822.6e6bf282@infradead.org> <alpine.LFD.2.01.0906150933330.3305@localhost.localdomain> <alpine.LFD.2.01.0906150945490.3305@localhost.localdomain> <alpine.LFD.2.01.0906151048380.6276@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151048380.6276@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 15 Jun 2009, Linus Torvalds wrote:
> > 
> > NOTE! This is, of course, totally untested. And we're bound to have 
> > continuation printk's that don't have the KERN_CONT at front, and need 
> > them added, but I think this is generally a saner model than what we have 
> > now, or your suggested explicit addition of '\n'.
> 
> Ok, it's tested now.
> 
> It works, and yes, it does show cases of insanity: both missing KERN_CONT 
> (common), and _extra_ KERN_CONT (odd).
> 
> For example, the ACPI printk's seem to have pointless KERN_CONT's in them, 
> an I get printouts like:
> 
> 	[    0.000000] <c>ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
> 	[    0.000000] <c>ACPI: XSDT 00000000bf7fe120 0006C (v01 INTEL  DX58SO   0000084F      01000013)
> 	[    0.000000] <c>ACPI: FACP 00000000bf7fd000 000F4 (v03 INTEL  DX58SO   0000084F MSFT 0100000D)
> 	...
> 
> where that "<c>" is just because ACPI does something odd and pointless.
> 
> The lack of KERN_CONT shows up in printouts like
> 
> 	[   26.626492] CPU: L1 I cache: 32K
> 	[   26.626492] , L1 D cache: 32K
> 	...
> 	[   26.826201] ACPI: (supports S0
> 	[   26.826243]  S5
> 	[   26.826326] )
> 	...
> 	[   26.839617] ACPI: PCI Interrupt Link [LNKA] (IRQs
> 	[   26.839660]  3
> 	[   26.839741]  4
> 	[   26.839823]  5
> 	[   26.839904]  6
> 	[   26.839985]  7
> 	[   26.840067]  9
> 	[   26.840148]  10
> 	[   26.840230]  *11
> 	[   26.840313]  12
> 	[   26.840395]  14
> 	[   26.840476]  15
> 	[   26.840558] )
> 	...
> 	[   26.964999] ACPI: CPU0 (power states:
> 	[   26.965040]  C1[C1]
> 	[   26.965123]  C2[C3]
> 	[   26.965205] )
> 	...
> 	[   27.231268] ata_piix 0000:00:1f.5: MAP [
> 	[   27.231309]  P0
> 	[   27.231390]  --
> 	[   27.231472]  P1
> 	[   27.231553]  --
> 	[   27.231635]  ]
> 	...
> 	[   28.092534]  sda:
> 	[   28.092820]  sda1
> 	[   28.092910]  sda2
> 	...
> 
> where the kernel now added a newline because they were separate 
> printk's and didn't have KERN_CONT on the continuation.
> 
> But despite seeing these kinds of things, I do think the patch is 
> the right thing to do. It just shows that since KERN_CONT didn't 
> use to _do_ anything, people obviously mis-used it. It's the old 
> "if it wasn't tested, it's buggy" thing, but none of these look in 
> the least like serious problems to the approach.
> 
> Comments? We could make it remove the unnecessary '<c>' things (so 
> that you can always add KERN_CONT if you _want_ to), but the patch 
> as-is will show them because I think it's useful to see them.

I like this - it makes KERN_CONT truly functional. (Should have 
thought of that myself when i added KERN_CONT in 474925277.)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
