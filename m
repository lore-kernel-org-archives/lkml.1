Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0CHJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:21:21 -0500
Received: from www.tglx.de ([62.245.132.106]:59145 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab0CHJVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:21:18 -0500
Date: Mon, 8 Mar 2010 10:21:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
Message-ID: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__zone_pcp_update() iterates over NR_CPUS instead of limiting the
access to the possible cpus. This might result in access to
uninitialized areas as the per cpu allocator only populates the per
cpu memory for possible cpus.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3224,7 +3224,7 @@ static int __zone_pcp_update(void *data)
 	int cpu;
 	unsigned long batch = zone_batchsize(zone), flags;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		struct per_cpu_pageset *pset;
 		struct per_cpu_pages *pcp;
 
