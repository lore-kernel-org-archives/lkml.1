Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549Ab0A2Uxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0A2Uxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883Ab0A2UvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:14 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42660 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0A2UvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:13 -0500
Message-Id: <20100129205002.024594962@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:38 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Extend slabinfo to support -D and -F options
Content-Disposition: inline; filename=slub_extend_slabinfo
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

Index: slab-2.6/Documentation/vm/slabinfo.c
===================================================================
--- slab-2.6.orig/Documentation/vm/slabinfo.c	2010-01-22 15:09:38.000000000 -0600
+++ slab-2.6/Documentation/vm/slabinfo.c	2010-01-22 15:53:03.000000000 -0600
@@ -31,6 +31,8 @@ struct slabinfo {
 	int hwcache_align, object_size, objs_per_slab;
 	int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
+	int defrag, ctor;
+	int defrag_ratio, remote_node_defrag_ratio;
 	unsigned long partial, objects, slabs, objects_partial, objects_total;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
@@ -64,6 +66,8 @@ int show_slab = 0;
 int skip_zero = 1;
 int show_numa = 0;
 int show_track = 0;
+int show_defrag = 0;
+int show_ctor = 0;
 int show_first_alias = 0;
 int validate = 0;
 int shrink = 0;
@@ -100,13 +104,15 @@ static void fatal(const char *x, ...)
 static void usage(void)
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
@@ -296,7 +302,7 @@ static void first_line(void)
 		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
 	else
 		printf("Name                   Objects Objsize    Space "
-			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n");
+			"Slabs/Part/Cpu  O/S O %%Ra %%Ef Flg\n");
 }
 
 /*
@@ -345,7 +351,7 @@ static void slab_numa(struct slabinfo *s
 		return;
 
 	if (!line) {
-		printf("\n%-21s:", mode ? "NUMA nodes" : "Slab");
+		printf("\n%-21s: Rto ", mode ? "NUMA nodes" : "Slab");
 		for(node = 0; node <= highest_node; node++)
 			printf(" %4d", node);
 		printf("\n----------------------");
@@ -354,6 +360,7 @@ static void slab_numa(struct slabinfo *s
 		printf("\n");
 	}
 	printf("%-21s ", mode ? "All slabs" : s->name);
+	printf("%3d ", s->remote_node_defrag_ratio);
 	for(node = 0; node <= highest_node; node++) {
 		char b[20];
 
@@ -492,6 +499,8 @@ static void report(struct slabinfo *s)
 		printf("** Slabs are destroyed via RCU\n");
 	if (s->reclaim_account)
 		printf("** Reclaim accounting active\n");
+	if (s->defrag)
+		printf("** Defragmentation at %d%%\n", s->defrag_ratio);
 
 	printf("\nSizes (bytes)     Slabs              Debug                Memory\n");
 	printf("------------------------------------------------------------------------\n");
@@ -539,6 +548,12 @@ static void slabcache(struct slabinfo *s
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
@@ -550,6 +565,10 @@ static void slabcache(struct slabinfo *s
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
@@ -584,7 +603,8 @@ static void slabcache(struct slabinfo *s
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
 			s->name, s->objects, s->object_size, size_str, dist_str,
 			s->objs_per_slab, s->order,
-			s->slabs ? (s->partial * 100) / s->slabs : 100,
+			s->slabs ? (s->partial * 100) /
+					(s->slabs * s->objs_per_slab) : 100,
 			s->slabs ? (s->objects * s->object_size * 100) /
 				(s->slabs * (page_size << s->order)) : 100,
 			flags);
@@ -1190,7 +1210,17 @@ static void read_slab_dir(void)
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
@@ -1241,10 +1271,12 @@ static void output_slabs(void)
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
@@ -1267,7 +1299,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aAd::Defhil1noprstvzTS",
+	while ((c = getopt_long(argc, argv, "aACd::DefFhil1noprstvzTS",
 						opts, NULL)) != -1)
 		switch (c) {
 		case '1':
@@ -1323,6 +1355,12 @@ int main(int argc, char *argv[])
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
