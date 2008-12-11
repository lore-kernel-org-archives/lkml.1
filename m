Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYLKUgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYLKUgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYLKUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:36:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559AbYLKUgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:36:43 -0500
Date: Thu, 11 Dec 2008 21:36:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211203604.GA14817@elte.hu>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain> <20081211163548.GA11859@elte.hu> <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 11 Dec 2008, Ingo Molnar wrote:
> > 
> > hm, the warning caught a couple of real bugs already. (one in some 
> > cpq driver, another was in some networking driver iirc)
> 
> Well, one thing that does irritate me is that it scares people who 
> can't do anything about it, and probably _shouldn't_ do anything about 
> it.

yeah - and false positives also tend to create apathy and resistence 
against kernel warnings - thus drawing tester resources away from more 
important bugs.

> I wonder if we should just change the "Warning" message to 
> "Informational" or something. Yes, they are often real bugs. But no, 
> they're not _automatically_ bugs. Almost all the time when a warning 
> triggers, it's really just a developer who wants to know about it, it's 
> not something that a user should really care/worry about.

ok. In this case i'd suggest we should just remove the warning. People do 
get scared by needless kernel stack dumps - no matter whether it's marked 
informational or not.

So how about the patch below, queued up in tip/x86/debug? Arjan, what do 
you think?

	Ingo

--------------->
>From 2dcae81e819fa5cc0e9310ef8b0c079940df3bf3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 11 Dec 2008 21:29:51 +0100
Subject: [PATCH] IO resources, x86: remove multi-BAR mapping sanity check

Impact: remove a debug warning

The ioremap() time multi-BAR map warning has been causing false positives:

 http://lkml.org/lkml/2008/12/10/432
 http://lkml.org/lkml/2008/12/11/136

So remove it for now.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c  |    6 ------
 include/linux/ioport.h |    1 -
 kernel/resource.c      |   38 --------------------------------------
 3 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index d4c4307..421b92d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -220,12 +220,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
 	/*
-	 * Check if the request spans more than any BAR in the iomem resource
-	 * tree.
-	 */
-	WARN_ON(iomem_map_sanity_check(phys_addr, size));
-
-	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 041e95a..0dde772 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -174,7 +174,6 @@ extern struct resource * __devm_request_region(struct device *dev,
 
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
-extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 4337063..4b0bc70 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -829,41 +829,3 @@ static int __init reserve_setup(char *str)
 }
 
 __setup("reserve=", reserve_setup);
-
-/*
- * Check if the requested addr and size spans more than any slot in the
- * iomem resource tree.
- */
-int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
-{
-	struct resource *p = &iomem_resource;
-	int err = 0;
-	loff_t l;
-
-	read_lock(&resource_lock);
-	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
-		/*
-		 * We can probably skip the resources without
-		 * IORESOURCE_IO attribute?
-		 */
-		if (p->start >= addr + size)
-			continue;
-		if (p->end < addr)
-			continue;
-		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
-		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
-			continue;
-		printk(KERN_WARNING "resource map sanity check conflict: "
-		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
-		       (unsigned long long)addr,
-		       (unsigned long long)(addr + size - 1),
-		       (unsigned long long)p->start,
-		       (unsigned long long)p->end,
-		       p->name);
-		err = -1;
-		break;
-	}
-	read_unlock(&resource_lock);
-
-	return err;
-}
