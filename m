Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756226AbYLPWfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYLPWfQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYLPWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:35:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbYLPWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:34:59 -0500
Date: Tue, 16 Dec 2008 23:34:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Frans Pop <elendil@planet.nl>,
        Eric Anholt <eric@anholt.net>, nix.or.die@googlemail.com,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081216223426.GN14787@elte.hu>
References: <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain> <20081211163548.GA11859@elte.hu> <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain> <20081211203604.GA14817@elte.hu> <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com> <20081212082456.GA25106@elte.hu> <20081212075746.4ddc9349@infradead.org> <alpine.LFD.2.00.0812120808200.3340@localhost.localdomain> <20081213091527.6f8efbc7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213091527.6f8efbc7@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 12 Dec 2008 08:11:35 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Fri, 12 Dec 2008, Arjan van de Ven wrote:
> > > 
> > > another thing we could do is try to only warn if you cross bar
> > > boundaries but not if you cross other user-of-the-resource
> > > boundaries.
> > 
> > Hmm. We could use the res->flags for this. But I'm not sure non-PCI 
> > resources fill those in correctly.
> > 
> > A pure "busy" allocation (ie a driver marker) would generally have
> > just the IORESOURCE_BUSY bit set, while a real PCI hardware resource
> > will have other bits set (ie the IORESOURCE_IO/MEM bits) and not be
> > marked BUSY.
> > 
> > Maybe just ignoring resources with BUSY set, as they are driver
> > markers rather than actual HW resources.
> 
> something like this: ?

okay, i've applied it in the form below, to tip/core/resources. This in 
combination with the toning down of the messages should do the trick i 
think.

btw., here's a bug that got caught by the sanity checks:

| commit d522af581c6abd0e064278345ca638b0553a93fa
| Author: Suresh Siddha <suresh.b.siddha@intel.com>
| Date:   Mon Oct 20 17:57:02 2008 -0300
|
|     V4L/DVB (9356): [PATCH] saa7134: fix resource map sanity check conflict
|    
|     Impact: driver could possibly stomp on resources outside of its scope

so it's not just nuisance.

> Note: having two drivers talk to the same hardware at the same
> time is obviously not optimal behavior, but that's a separate story.

it will be much more likely to be caught via other misbehavior i guess. 

	Ingo

------------------>
>From 3ac52669c7a24b93663acfcab606d1065ed1accd Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 13 Dec 2008 09:15:27 -0800
Subject: [PATCH] resources: skip sanity check of busy resources

Impact: reduce false positives in iomem_map_sanity_check()

Some drivers (vesafb) only map/reserve a portion of a resource.
If then some other driver comes in and maps the whole resource,
the current code WARN_ON's. This is not the intent of the checks
in iomem_map_sanity_check(); rather these checks want to
warn when crossing *hardware* resources only.

This patch skips BUSY resources as suggested by Linus.

Note: having two drivers talk to the same hardware at the same
time is obviously not optimal behavior, but that's a separate story.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/resource.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 4337063..e633106 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -853,6 +853,15 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
 		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
 			continue;
+		/*
+		 * if a resource is "BUSY", it's not a hardware resource
+		 * but a driver mapping of such a resource; we don't want
+		 * to warn for those; some drivers legitimately map only
+		 * partial hardware resources. (example: vesafb)
+		 */
+		if (p->flags & IORESOURCE_BUSY)
+			continue;
+
 		printk(KERN_WARNING "resource map sanity check conflict: "
 		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
 		       (unsigned long long)addr,
