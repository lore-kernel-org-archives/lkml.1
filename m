Return-Path: <linux-kernel-owner+w=401wt.eu-S1161087AbXAZSjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161087AbXAZSjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161089AbXAZSjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:39:14 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:41789 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161087AbXAZSjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:39:13 -0500
Date: Fri, 26 Jan 2007 10:38:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
In-Reply-To: <6bffcb0e0701261008u2fd5a7d9va16d7fd9f250e14b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> 
 <45BA42B9.7020203@googlemail.com> <6bffcb0e0701261008u2fd5a7d9va16d7fd9f250e14b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Michal Piotrowski wrote:

> mm/page_alloc.c: In function 'nr_free_inactive_pages_node':
> mm/page_alloc.c:1588: error: 'struct zone' has no member named 'nr_inactive'
> mm/page_alloc.c:1589: error: 'struct zone' has no member named 'free_pages'
> make[1]: *** [mm/page_alloc.o] Error 1
> make: *** [mm] Error 2

I cannot get it to compile either:

christoph@schroedinger:~/software/linux/xx/linux-2.6.20-rc6$ make 
mm/page_alloc.o
scripts/kconfig/conf -s arch/i386/Kconfig
Warning! Found recursive dependency: INET GFS2_FS_LOCKING_DLM SYSFS 
OCFS2_FS INET
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/i386/kernel/asm-offsets.s
In file included from include/linux/sched.h:87,
                 from include/linux/utsname.h:35,
                 from include/asm/elf.h:12,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/crypto.h:21,
                 from arch/i386/kernel/asm-offsets.c:7:
include/linux/nsproxy.h: In function 'preexit_task_namespaces':
include/linux/nsproxy.h:56: error: dereferencing pointer to incomplete 
type
make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

but I would think that this would fix the compile errors that are my 
responsibility (sort of .... patch was against rc6 and not against mm).
More when I track down the above issue:


mm-fixes to ZVC patches

Fix uses of free_pages

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.20-rc6.orig/kernel/power/swsusp.c	2007-01-26 10:32:05.000000000 -0800
+++ linux-2.6.20-rc6/kernel/power/swsusp.c	2007-01-26 10:32:24.000000000 -0800
@@ -230,7 +230,8 @@ int swsusp_shrink_memory(void)
 		for_each_zone (zone)
 			if (populated_zone(zone)) {
 				if (is_highmem(zone)) {
-					highmem_size -= zone->free_pages;
+					highmem_size -=
+					zone_page_state(zone, NR_FREE_PAGES);
 				} else {
 					tmp -= zone->free_pages;
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
Index: linux-2.6.20-rc6/mm/page_alloc.c
===================================================================
--- linux-2.6.20-rc6.orig/mm/page_alloc.c	2007-01-26 10:32:19.000000000 -0800
+++ linux-2.6.20-rc6/mm/page_alloc.c	2007-01-26 10:32:27.000000000 -0800
@@ -1581,12 +1581,12 @@ unsigned int nr_free_pagecache_pages(voi
 unsigned long nr_free_inactive_pages_node(int nid)
 {
 	enum zone_type i;
-	unsigned long sum = 0;
+	unsigned long sum = node_page_state(nid, NR_FREE_PAGES)
+				+ node_page_state(nid, NR_INACTIVE);
 	struct zone *zones = NODE_DATA(nid)->node_zones;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
-		sum += zones[i].nr_inactive +
-			zones[i].free_pages - zones[i].pages_low;
+		sum -= zones[i].pages_low;
 
 	return sum;
 }
