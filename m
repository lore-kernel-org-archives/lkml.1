Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbYLPTQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbYLPTQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLPTQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:16:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41859 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYLPTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:16:20 -0500
Date: Tue, 16 Dec 2008 20:28:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Martin Steigerwald <ms@teamix.de>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: physical memory limit of 64-bit linux
Message-ID: <20081216192826.GZ25779@one.firstfloor.org>
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl> <20081216184742.GL11683@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216184742.GL11683@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 07:47:42PM +0100, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 16 of December 2008, Martin Steigerwald wrote:
> > > 
> > > Hi!
> > > 
> > > What is the physical memory limit for 64-bit Linux? I read about 40 
> > > bit address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4 
> > > (256 TB).
> > > 
> > > Is 64-bit linux able to use that amount - provided that one would 
> > > manage to build it into a machine? Or does it have a lower limit?
> > > 
> > > Looking into the Google crystal ball gives unclear pictures... I tend 
> > > to assume that Linux would handle it, but I am not sure.
> > 
> > IIRC, the current maximal virtual memory space size of the kernel on 
> > x86_64 is 2^46.
> 
> Almost: the real current upstream kernel hard memory limit on x86-64 is 44 
> bits, i.e. 16 TB.
> 
> There's a couple of limits to consider here.

Good point.

> 
> So in reality MAXMEM should be limited to the max sparsemem-covered 
> physical memory range, via the patch below.

I think the SPARSMEM limit problem only happens in the !VMEMMAP case.
It might be better to just disable the config option for !VMEMMAP,
afaik on 64bit NUMA you always want to have VMEMMAP enabled anyways.
That would avoid that particular limit at least and be in general 
more efficient.

Like in this patch.

-Andi

---

Always enable vmemmap on x86-64 NUMA

To my knowledge vmemap is the most efficient option on x86-64, so there's no
sense in supporting old style non virtual sparsemem too. On 32bit x86
it still makes some sense due to the limited address space.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig |    1 +
 mm/Kconfig       |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.28-rc4-test/arch/x86/Kconfig
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/Kconfig	2008-11-10 08:50:23.000000000 +0100
+++ linux-2.6.28-rc4-test/arch/x86/Kconfig	2008-12-16 20:12:48.000000000 +0100
@@ -1060,6 +1060,7 @@
 	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_GENERICARCH
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
+	select SPARSEMEM_VMEMMAP_FORCE if X86_64
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
Index: linux-2.6.28-rc4-test/mm/Kconfig
===================================================================
--- linux-2.6.28-rc4-test.orig/mm/Kconfig	2008-10-24 13:35:09.000000000 +0200
+++ linux-2.6.28-rc4-test/mm/Kconfig	2008-12-16 20:13:11.000000000 +0100
@@ -115,8 +115,11 @@
 config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
+config SPARSEMEM_VMEMMAP_FORCE
+	bool
+
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	bool "Sparse Memory virtual memmap" if !SPARSEMEM_VMEMMAP_FORCE
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
 	default y
 	help
