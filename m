Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbZASLaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbZASLaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZASLaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:30:08 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:46365 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZASLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:30:06 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Mon, 19 Jan 2009 17:00:03 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901161746.36584.chandru@in.ibm.com> <1232128377.27278.69.camel@nimitz>
In-Reply-To: <1232128377.27278.69.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191700.03580.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case either physbase or reserve_size are not page aligned and in addition
if the following condition is also true

node_ar.end_pfn = node->node_end_pfn = PFN_DOWN(physbase+reserve_size).

we may hit the BUG_ON(end > bdata->node_low_pfn) in mark_bootmem_node() in
mm/bootmem.c Hence pass the pfn that the physbase is part of and align
reserve_size before calling reserve_bootmem_node().

Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 arch/powerpc/mm/numa.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.29-rc2/arch/powerpc/mm/numa.c.orig	2009-01-19 16:14:49.000000000 +0530
+++ linux-2.6.29-rc2/arch/powerpc/mm/numa.c	2009-01-19 16:36:38.000000000 +0530
@@ -901,7 +901,8 @@ static void mark_reserved_regions_for_ni
 		get_node_active_region(start_pfn, &node_ar);
 		while (start_pfn < end_pfn &&
 			node_ar.start_pfn < node_ar.end_pfn) {
-			unsigned long reserve_size = size;
+			unsigned long reserve_size = (size >> PAGE_SHIFT) <<
+								PAGE_SHIFT;
 			/*
 			 * if reserved region extends past active region
 			 * then trim size to active region
@@ -917,7 +918,8 @@ static void mark_reserved_regions_for_ni
 				dbg("reserve_bootmem %lx %lx nid=%d\n",
 					physbase, reserve_size, node_ar.nid);
 				reserve_bootmem_node(NODE_DATA(node_ar.nid),
-						physbase, reserve_size,
+						(start_pfn << PAGE_SHIFT),
+						reserve_size,
 						BOOTMEM_DEFAULT);
 			}
 			/*

