Return-Path: <linux-kernel-owner+w=401wt.eu-S1946262AbXBCCyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946262AbXBCCyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946209AbXBCCgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:36 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52671 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946238AbXBCCfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:48 -0500
Message-Id: <20070203023803.713362000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:07 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [patch 03/59] Check for populated zone in __drain_pages
Content-Disposition: inline; filename=check-for-populated-zone-in-__drain_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Christoph Lameter <clameter@sgi.com>

Both process_zones() and drain_node_pages() check for populated zones
before touching pagesets.  However, __drain_pages does not do so,

This may result in a NULL pointer dereference for pagesets in unpopulated
zones if a NUMA setup is combined with cpu hotplug.

Initially the unpopulated zone has the pcp pointers pointing to the boot
pagesets.  Since the zone is not populated the boot pageset pointers will
not be changed during page allocator and slab bootstrap.

If a cpu is later brought down (first call to __drain_pages()) then the pcp
pointers for cpus in unpopulated zones are set to NULL since __drain_pages
does not first check for an unpopulated zone.

If the cpu is then brought up again then we call process_zones() which will
ignore the unpopulated zone.  So the pageset pointers will still be NULL.

If the cpu is then again brought down then __drain_pages will attempt to
drain pages by following the NULL pageset pointer for unpopulated zones.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f2e12bb272f2544d1504f982270e90ae3dcc4ff2

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.19.2.orig/mm/page_alloc.c
+++ linux-2.6.19.2/mm/page_alloc.c
@@ -710,6 +710,9 @@ static void __drain_pages(unsigned int c
 	for_each_zone(zone) {
 		struct per_cpu_pageset *pset;
 
+		if (!populated_zone(zone))
+			continue;
+
 		pset = zone_pcp(zone, cpu);
 		for (i = 0; i < ARRAY_SIZE(pset->pcp); i++) {
 			struct per_cpu_pages *pcp;

--
