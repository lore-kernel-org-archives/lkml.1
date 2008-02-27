Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbYB0VOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbYB0VOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYB0VOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:14:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYB0VOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:14:36 -0500
Date: Wed, 27 Feb 2008 22:14:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
Message-ID: <20080227211414.GA12199@elte.hu>
References: <adad4qiwcmz.fsf@cisco.com> <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> <ada1w6y1bzk.fsf@cisco.com> <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de> <20080227203655.GA30054@elte.hu> <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de> <alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 27 Feb 2008, Thomas Gleixner wrote:
> > +static inline int phys_addr_valid(unsigned long addr)
> > +{
> > +	return addr < (1 << boot_cpu_data.x86_phys_bits);
> 
> That needs to be:
> 
> +     return addr < (1UL << boot_cpu_data.x86_phys_bits);
> 
> Where is my brown paperbag ? I know that GCC _is_ stupid, but I never 
> remember.

here's the updated patch.

	Ingo

-------------->
Subject: x86: check physical address range in ioremap
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 27 Feb 2008 20:57:40 +0100

Roland Dreier reported in http://lkml.org/lkml/2008/2/27/194

[ 8425.915139] BUG: unable to handle kernel paging request at ffffc20001a0a000
[ 8425.919087] IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
[ 8425.919087] PGD 1bf80e067 PUD 1bf80f067 PMD 1bb497067 PTE 80000047000ee17b

This is on a Intel machine with 36bit physical address space. The PTE
entry references 47000ee000, which is outside of it.

Add a check for the physical address space and warn/printk about the
stupid caller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -35,6 +35,18 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 
+static inline int phys_addr_valid(unsigned long addr)
+{
+	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+}
+
+#else
+
+static inline int phys_addr_valid(unsigned long addr)
+{
+	return 1;
+}
+
 #endif
 
 int page_is_ram(unsigned long pagenr)
@@ -118,6 +130,13 @@ static void __iomem *__ioremap(unsigned 
 	if (!size || last_addr < phys_addr)
 		return NULL;
 
+	if (!phys_addr_valid(phys_addr)) {
+		printk(KERN_WARNING "ioremap: invalid physical address %lx\n",
+		       phys_addr);
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
 	/*
 	 * Don't remap the low PCI/ISA area, it's always mapped..
 	 */
