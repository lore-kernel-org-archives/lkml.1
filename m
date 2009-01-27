Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZA0QEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZA0QEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZA0QEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:04:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbZA0QEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:04:22 -0500
Date: Tue, 27 Jan 2009 11:04:21 -0500
From: Kyle McMartin <kyle@redhat.com>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: [PATCH stable] resources: skip sanity check of busy resources
Message-ID: <20090127160421.GF5034@bombadil.infradead.org>
Reply-To: kyle@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

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
Signed-off-by: Kyle McMartin <kyle@redhat.com>
---

Bug fix for 2.6.28-stable only (relevant iomem_map_sanity_check hadn't
been added to 2.6.27.) This resolves a fairly nasty boot time WARN
in acpi ec seen on a number of systems. (RH #480700)

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
1.6.0.6

