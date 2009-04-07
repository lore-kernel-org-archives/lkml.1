Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZDGGFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZDGGFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZDGGF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:05:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:40246 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZDGGFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:05:25 -0400
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407055245.GA10406@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407053739.GA10500@elte.hu>
	 <1239083045.22733.383.camel@macbook.infradead.org>
	 <20090407054818.GA5557@elte.hu>  <20090407055245.GA10406@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Apr 2009 23:04:40 -0700
Message-Id: <1239084280.22733.404.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 07:52 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Tue, 2009-04-07 at 07:37 +0200, Ingo Molnar wrote:
> > > > I suspect these bits are the ones that broke the upstream build:
> > > > 
> > > >  drivers/pci/dmar.c:47: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> > > > ‘__attribute__’ before ‘dmar_tbl_size’
> > > >  drivers/pci/dmar.c:62: warning: ‘struct acpi_dmar_device_scope’
> > > > declared inside parameter list
> > > >  drivers/pci/dmar.c:62: warning: its scope is only this definition or
> > > > declaration, which is probably not what you want
> > > 
> > > Yeah, <acpi/acpi.h> was being included implicitly for me, but 
> > > certain configs don't do that. Alexander Beregalov sent a patch 
> > > for that, which I added to my tree before Linus pulled it.
> > > 
> > > Commit 46f06b72378d3187f0d12f7a60d020676bfbf332 is the fix.
> > 
> > No, that does not fix it - it's still broken with 
> > v2.6.29-9854-gd508afb. Try the config i sent.
> 
> The problem is INTR_REMAP. That brings in DMAR but not ACPI.

Er, ...

config INTR_REMAP
	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL

> The patch below fixes it, but it is only an ugly workaround: we 
> really dont want 'depends on ACPI' dependencies to spread like that.

It _does_ depend on ACPI. Much as I wish it didn't, it's fundamentally
tied to it for now.

> ACPI is a hardware discovery mechanism. It might be the only way to 
> discover these pieces of hardware at the moment, but we should not 
> tie method of discovery to hardware support. I'd suggest a 
> dmar_acpi.c splitout of the ACPI bits.

As I said, DMAR is the name of an ACPI table. If we ever manage to get
non-ACPI discovery of the hardware, we can write new code which mentions
_neither_ DMAR nor ACPI. And at that point, we can talk about moving any
generic parts out of the existing 'dmar.c'. Perhaps into intel-iommu.c?

It's a bit premature to do that now, though -- especially given the
unfortunate likelihood that a sensible discovery method will never
happen.


I think the problem here is actually the fact that we used 'select'
instead of proper dependencies. I wouldn't normally have used the
abomination that is 'select', but since I was just moving things around
I ended up doing so by accident.

X2APIC currently selects INTR_REMAP, and the bug would never have
happened if we'd made X2APIC _depend_ on INTR_REMAP instead.

This is a better fix:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4b34082..bc25b9f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -252,17 +252,13 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64
-	select INTR_REMAP
+	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
 	  This allows 32-bit apic IDs (so it can support very large systems),
 	  and accesses the local apic via MSRs not via mmio.
 
-	  ( On certain CPU models you may need to enable INTR_REMAP too,
-	    to get functional x2apic mode. )
-
 	  If you don't know what to do here, say N.
 
 config SPARSE_IRQ



-- 
dwmw2

