Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbYCDQQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbYCDQQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765294AbYCDQQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:16:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762252AbYCDQQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:16:04 -0500
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080304143324.GA2713@elte.hu>
References: <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <20080228132822.GA25278@mailshack.com>
	 <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
	 <47C72432.3010606@zytor.com>
	 <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
	 <1204630906.16613.4.camel@muff>  <20080304143324.GA2713@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:15:31 +0000
Message-Id: <1204647331.2774.18.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 15:33 +0100, Ingo Molnar wrote: 
> * Mark McLoughlin <markmc@redhat.com> wrote:
> 
> > > The patch below seems like the right thing to do. It certainly boots 
> > > in a domU without the DMI problem (without any of the other related 
> > > patches such as Alexander's).
> > 
> > Yep, this patch on its own fixes 2.6.25-rc3 DomU boot for me here.
> 
> thanks - i picked it up for v2.6.25 merging.

Great. 

> i'm wondering, what triggered this bug, and why didnt we have these 
> problems in the past?

That's been bothering me too, but hadn't come up with anything until I
just now looked again.

I'm pretty certain that dmi_scan_machine() wasn't using a fixmap before
(in 2.6.24) since I had to fix a broken xen dom0 patch to handle this
new situation.

Looking at 2.6.24 bt_ioremap(), it would have been hitting this:

     /*                                                                                                                   
      * Don't remap the low PCI/ISA area, it's always mapped..                                                            
      */
        if (phys_addr >= ISA_START_ADDRESS && last_addr < ISA_END_ADDRESS)
                return phys_to_virt(phys_addr);

If I restore this behaviour (i.e. remove Ian's e820 hole and add the
patch below), then I see us still allocating a page table at 0xf0000 but
we don't then try and create a new writable mapping to it later, and
everything goes fine.

That's a little worrying though, surely? The mapping created by
kernel_physical_mapping_init() is writable, so shouldn't Xen barf if you
try and use a page within that mapping as a page table?

Cheers,
Mark.

>From c43a8a1badf5347a57d66556a4ba497623d620d4 Mon Sep 17 00:00:00 2001
From: Mark McLoughlin <markmc@redhat.com>
Date: Tue, 4 Mar 2008 15:32:03 +0000
Subject: [PATCH] x86: Don't remap the ISA region in early_ioremap()

Restore the previous behaviour of bt_ioremap() where
it would use the existing mapping of the ISA region
rather than using a fixmap.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/mm/ioremap.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 882328e..89fdd8f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -425,6 +425,13 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 		return NULL;
 	}
 
+	/*
+	 * Don't remap the low PCI/ISA area, it's always mapped..
+	 */
+	if (phys_addr >= ISA_START_ADDRESS && last_addr < ISA_END_ADDRESS)
+		return phys_to_virt(phys_addr);
+
+
 	if (nesting >= FIX_BTMAPS_NESTING) {
 		WARN_ON(1);
 		return NULL;
@@ -471,6 +478,10 @@ void __init early_iounmap(void *addr, unsigned long size)
 	enum fixed_addresses idx;
 	unsigned int nesting;
 
+	virt_addr = (unsigned long)addr;
+	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN))
+		return;
+
 	nesting = --early_ioremap_nested;
 	WARN_ON(nesting < 0);
 
@@ -480,11 +491,6 @@ void __init early_iounmap(void *addr, unsigned long size)
 		dump_stack();
 	}
 
-	virt_addr = (unsigned long)addr;
-	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)) {
-		WARN_ON(1);
-		return;
-	}
 	offset = virt_addr & ~PAGE_MASK;
 	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
 
-- 
1.5.4.2



