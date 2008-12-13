Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbYLMROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbYLMROU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYLMROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 12:14:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:40453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYLMROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 12:14:08 -0500
Date: Sat, 13 Dec 2008 09:15:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081213091527.6f8efbc7@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0812120808200.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<49407CE1.9090600@googlemail.com>
	<1228979963.3254.8.camel@gaiman.anholt.net>
	<200812111707.20857.elendil@planet.nl>
	<alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
	<20081211163548.GA11859@elte.hu>
	<alpine.LFD.2.00.0812110902450.3340@localhost.localdomain>
	<20081211203604.GA14817@elte.hu>
	<84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
	<20081212082456.GA25106@elte.hu>
	<20081212075746.4ddc9349@infradead.org>
	<alpine.LFD.2.00.0812120808200.3340@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 08:11:35 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 12 Dec 2008, Arjan van de Ven wrote:
> > 
> > another thing we could do is try to only warn if you cross bar
> > boundaries but not if you cross other user-of-the-resource
> > boundaries.
> 
> Hmm. We could use the res->flags for this. But I'm not sure non-PCI 
> resources fill those in correctly.
> 
> A pure "busy" allocation (ie a driver marker) would generally have
> just the IORESOURCE_BUSY bit set, while a real PCI hardware resource
> will have other bits set (ie the IORESOURCE_IO/MEM bits) and not be
> marked BUSY.
> 
> Maybe just ignoring resources with BUSY set, as they are driver
> markers rather than actual HW resources.

something like this: ?

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 13 Dec 2008 09:12:18 -0800
Subject: [PATCH] resource: Don't warn for driver originated resource structures

Some drivers (vesafb) only map/reserve a portion of a resource.
If then some other driver comes in and maps the whole resource,
the current code WARN_ON's. This is not the intent of the checks
in iomem_map_sanity_check(); rather these checks want to
warn when crossing *hardware* resources only.

This patch skips BUSY resources as suggested by Linus.

Note: having two drivers talk to the same hardware at the same
time is obviously not optimal behavior, but that's a separate story.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
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
-- 
1.6.0.4



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
