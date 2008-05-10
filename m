Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYHASij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYHASij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbYHASh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:37:56 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:12449 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbYHAShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:37:54 -0400
Message-Id: <20080801182345.521105016@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:08 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 07/19] slub: Extend slabinfo to support -D and -F options
Content-Disposition: inline; filename=0007-SLUB-Extend-slabinfo-to-support-D-and-F-options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-F lists caches that support defragmentation

-C lists caches that use a ctor.

Change field names for defrag_ratio and remote_node_defrag_ratio.

Add determination of the allocation ratio for a slab. The allocation ratio
is the percentage of available slots for objects in use.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 Documentation/vm/slabinfo.c |   48 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

Index: linux-next/Documentation/vm/slabinfo.c
===================================================================
--- linux-next.orig/Documentation/vm/slabinfo.c	2008-07-09 09:06:12.000000000 -0500
+++ linux-next/Documentation/vm/slabinfo.c	2008-07-09 09:33:37.000000000 -0500
@@ -31,6 +31,8 @@
 	int hwcache_align, object_size, objs_per_slab;
 	int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
+	int defrag, ctor;
+	int defrag_ratio, remote_node_defrag_ratio;
 	unsigned long partial, objects, slabs, objects_partial, objects_total;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
@@ -64,6 +66,8 @@
 int skip_zero = 1;
 int show_numa = 0;
 int show_track = 0;
+int show_defrag = 0;
+int show_ctor = 0;
 int show_first_alias = 0;
 int validate = 0;
 int shrink = 0;
@@ -100,13 +104,15 @@
 void usage(void)
 {
 	printf("slabinfo 5/7/2007. (c) 2007 sgi.\n\n"
-		"slabinfo [-ahnpvtsz] [-d debugopts] [slab-regexp]\n"
+		"slabinfo [-aCdDefFhnpvtsz] [-d debugopts] [slab-regexp]\n"
 		"-a|--aliases           Show aliases\n"
 		"-A|--activity          Most active slabs first\n"
 		"-d<options>|--debug=<options> Set/Clear Debug options\n"
+		"-C|--ctor              Show slabs with ctors\n"
 		"-D|--display-active    Switch line format to activity\n"
 		"-e|--empty             Show empty slabs\n"
 		"-f|--first-alias       Show first alias\n"
+		"-F|--defrag            Show defragmentable caches\n"
 		"-h|--help              Show usage information\n"
 		"-i|--inverted          Inverted list\n"
 		"-l|--slabs             Show slabs\n"
@@ -296,7 +302,7 @@
 		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
 	else
 		printf("Name                   Objects Objsize    Space "
-			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n");
+			"Slabs/Part/Cpu  O/S O %%Ra %%Ef Flg\n");
 }
 
 /*
@@ -345,7 +351,7 @@
 		return;
 
 	if (!line) {
-		printf("\n%-21s:", mode ? "NUMA nodes" : "Slab");
+		printf("\n%-21s: Rto ", mode ? "NUMA nodes" : "Slab");
 		for(node = 0; node <= highest_node; node++)
 			printf(" %4d", node);
 		printf("\n----------------------");
@@ -354,6 +360,7 @@
 		printf("\n");
 	}
 	printf("%-21s ", mode ? "All slabs" : s->name);
+	printf("%3d ", s->remote_node_defrag_ratio);
 	for(node = 0; node <= highest_node; node++) {
 		char b[20];
 
@@ -492,6 +499,8 @@
 		printf("** Slabs are destroyed via RCU\n");
 	if (s->reclaim_account)
 		printf("** Reclaim accounting active\n");
+	if (s->defrag)
+		printf("** Defragmentation at %d%%\n", s->defrag_ratio);
 
 	printf("\nSizes (bytes)     Slabs              Debug                Memory\n");
 	printf("------------------------------------------------------------------------\n");
@@ -539,6 +548,12 @@
 	if (show_empty && s->slabs)
 		return;
 
+	if (show_defrag && !s->defrag)
+		return;
+
+	if (show_ctor && !s->ctor)
+		return;
+
 	store_size(size_str, slab_size(s));
 	snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs - s->cpu_slabs,
 						s->partial, s->cpu_slabs);
@@ -550,6 +565,10 @@
 		*p++ = '*';
 	if (s->cache_dma)
 		*p++ = 'd';
+	if (s->defrag)
+		*p++ = 'F';
+	if (s->ctor)
+		*p++ = 'C';
 	if (s->hwcache_align)
 		*p++ = 'A';
 	if (s->poison)
@@ -584,7 +603,8 @@
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
 			s->name, s->objects, s->object_size, size_str, dist_str,
 			s->objs_per_slab, s->order,
-			s->slabs ? (s->partial * 100) / s->slabs : 100,
+			s->slabs ? (s->partial * 100) /
+					(s->slabs * s->objs_per_slab) : 100,
 			s->slabs ? (s->objects * s->object_size * 100) /
 				(s->slabs * (page_size << s->order)) : 100,
 			flags);
@@ -1190,7 +1210,17 @@
 			slab->deactivate_to_tail = get_obj("deactivate_to_tail");
 			slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
 			slab->order_fallback = get_obj("order_fallback");
+			slab->defrag_ratio = get_obj("defrag_ratio");
+			slab->remote_node_defrag_ratio =
+					get_obj("remote_node_defrag_ratio");
 			chdir("..");
+			if (read_slab_obj(slab, "ops")) {
+				if (strstr(buffer, "ctor :"))
+					slab->ctor = 1;
+				if (strstr(buffer, "kick :"))
+					slab->defrag = 1;
+			}
+
 			if (slab->name[0] == ':')
 				alias_targets++;
 			slab++;
@@ -1241,10 +1271,12 @@
 struct option opts[] = {
 	{ "aliases", 0, NULL, 'a' },
 	{ "activity", 0, NULL, 'A' },
+	{ "ctor", 0, NULL, 'C' },
 	{ "debug", 2, NULL, 'd' },
 	{ "display-activity", 0, NULL, 'D' },
 	{ "empty", 0, NULL, 'e' },
 	{ "first-alias", 0, NULL, 'f' },
+	{ "defrag", 0, NULL, 'F' },
 	{ "help", 0, NULL, 'h' },
 	{ "inverted", 0, NULL, 'i'},
 	{ "numa", 0, NULL, 'n' },
@@ -1267,7 +1299,7 @@
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTS",
+	while ((c = getopt_long(argc, argv, "aACd::DefFhil1noprstvzTS",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1323,6 +1355,12 @@
 		case 'z':
 			skip_zero = 0;
 			break;
+		case 'C':
+			show_ctor = 1;
+			break;
+		case 'F':
+			show_defrag = 1;
+			break;
 		case 'T':
 			show_totals = 1;
 			break;

-- 
