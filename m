Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbYB1XR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbYB1XR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbYB1XRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:17:19 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:22900 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758109AbYB1XRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:17:18 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47C72432.3010606@zytor.com>
References: <20080224174605.GA21661@mailshack.com>
	 <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <20080228132822.GA25278@mailshack.com>
	 <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
	 <47C72432.3010606@zytor.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 23:16:49 +0000
Message-Id: <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 13:14 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > On Thu, 2008-02-28 at 14:28 +0100, Alexander van Heukelum wrote:
> >> Instead of using early reservations inside the kernel code,
> >> we could use the realmode code to modify the e820 memmap.
> >> This patch shows what that would look like. I have not looked
> >> at the case where the BIOS does not provide an e820 memmap
> >> yet. Probably a full solution would need to create a fake
> >> e820 memmap in that case.
> > 
> > An e820 is already faked up in machine_specific_memory_setup() if one
> > doesn't already exist.
> > 
> >> Comments?
> > 
> > This won't work for Xen since the real-mode code never runs there. I
> > think it could be fixed in xen_memory_setup() though if native goes down
> > this route.
> > 
> 
> s/could/should/.
> 
> You need to set up your memory map more sensibly; it's not just the 
> kernel, user space tries to access these areas too.

Agreed, I think it's pure luck that Xen kernels have gotten away with it
in the past.

The patch below seems like the right thing to do. It certainly boots in
a domU without the DMI problem (without any of the other related patches
such as Alexander's).

However ddcprobe hangs when run -- need to investigate some more, vm86
in general works ok (i.e. my vm86 test code passes).

BTW Jeremy, the kernel doesn't use XENMEM_memory_map -- any reason other
than it not being useful at the time? These days the tools can push an
arbitrary e820 down for a guest which might be useful to support,
although nothing interesting is done with it today.

Ian.

x86/xen: Construct e820 map with a hole between 640K-1M.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 3bad477..2341492 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -38,7 +38,8 @@ char * __init xen_memory_setup(void)
 	unsigned long max_pfn = xen_start_info->nr_pages;
 
 	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
+	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
+	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
 
 	return "Xen";
 }
-- 
1.5.4.2


-- 
Ian Campbell

His mind is like a steel trap: full of mice.
		-- Foghorn Leghorn

