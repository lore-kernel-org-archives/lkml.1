Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYCYHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYCYHcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 03:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYCYHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 03:32:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYCYHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 03:32:07 -0400
Date: Tue, 25 Mar 2008 08:31:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080325073117.GA8469@elte.hu>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E8217C.9080400@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Thomas Meyer wrote:
>> Linus Torvalds schrieb:
>>> Does this patch make any difference?
>> Yes. With this patch applied the error messages doesn't appear anymore.
> ...
>> [    2.232822] ohci1394: Failed to remap registers - card not accessible
> ...
>> [    2.551959] firewire_ohci: Failed to remap registers
>
> ioremap() fails now.

64-bit ioremaps never worked on 32-bit, so we are in totally unchartered 
waters now - but due to the unification we have a realistic chance to 
make them work. At minimum we need the fix below in addition to Linus' 
patch - does it make any difference?

	Ingo

---
 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: v/arch/x86/mm/ioremap.c
===================================================================
--- v.orig/arch/x86/mm/ioremap.c
+++ v/arch/x86/mm/ioremap.c
@@ -39,7 +39,7 @@ EXPORT_SYMBOL(__phys_addr);
 
 int page_is_ram(unsigned long pagenr)
 {
-	unsigned long addr, end;
+	resource_size_t addr, end;
 	int i;
 
 	/*
@@ -109,7 +109,8 @@ static int ioremap_change_attr(unsigned 
 static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
-	unsigned long pfn, offset, last_addr, vaddr;
+	unsigned long pfn, offset, vaddr;
+	resource_size_t last_addr;
 	struct vm_struct *area;
 	pgprot_t prot;
 
