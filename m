Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbYCDOtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbYCDOtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYCDOtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:49:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYCDOtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:49:39 -0500
Date: Tue, 4 Mar 2008 15:49:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
Message-ID: <20080304144915.GA4457@elte.hu>
References: <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <1204232996.28798.8.camel@cthulhu.hellion.org.uk> <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com> <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com> <1204631082.16613.7.camel@muff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204631082.16613.7.camel@muff>
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


* Mark McLoughlin <markmc@redhat.com> wrote:

> > This is the second attempt at a i386-version of the ebda patch. I 
> > hope that one of the Xen people will be able to check that this does 
> > not break their setups, but I think it will be fine after their 
> > patch to exclude the 0x9f000- 0x100000 area explicitly in their 
> > setup.
> 
> Confirmed that with Ian's e820 map patch and your patch, Xen DomU 
> boots fine.

hm, for now i've only got the patch below queued up for v2.6.25.

Could you check whether just the patch below ontop of -rc3-ish upstream 
solves the problem too? The EBDA patch would be a bit risky now - it's 
queued up for v2.6.26 at the moment.

	Ingo

--------------->
Subject: x86/xen: fix DomU boot problem
From: Ian Campbell <ijc@hellion.org.uk>
Date: Thu, 28 Feb 2008 23:16:49 +0000

Construct Xen guest e820 map with a hole between 640K-1M.

It's pure luck that Xen kernels have gotten away with it in the past.

The patch below seems like the right thing to do. It certainly boots in
a domU without the DMI problem (without any of the other related patches
such as Alexander's).

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Tested-by: Mark McLoughlin <markmc@redhat.com>
Acked-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/xen/setup.c
===================================================================
--- linux-x86.q.orig/arch/x86/xen/setup.c
+++ linux-x86.q/arch/x86/xen/setup.c
@@ -38,7 +38,8 @@ char * __init xen_memory_setup(void)
 	unsigned long max_pfn = xen_start_info->nr_pages;
 
 	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
+	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
+	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
 
 	return "Xen";
 }
