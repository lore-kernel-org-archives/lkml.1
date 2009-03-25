Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbZCYLky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbZCYLky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbZCYLiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:39785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbZCYLiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:51 -0400
Message-Id: <20090325113317.104545398@chello.nl>
References: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
Content-Disposition: inline; filename=mike-perf_counter_tools-mmap-pages.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

provide a knob to set the number of mmap data pages.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -178,6 +178,7 @@ static int			nr_cpus				=  0;
 static int			nmi				=  1;
 static int			group				=  0;
 static unsigned int		page_size;
+static unsigned int		mmap_pages			=  4;
 
 static char			*vmlinux;
 
@@ -326,6 +327,7 @@ static void display_help(void)
 	" -x path   --vmlinux=<path>   # the vmlinux binary, required for -s use\n"
 	" -z        --zero             # zero counts after display\n"
 	" -D        --dump_symtab      # dump symbol table to stderr on startup\n"
+	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
 	);
 
 	exit(0);
@@ -732,7 +734,9 @@ static int read_symbol(FILE *in, struct 
 	/* Tag events to be skipped. */
 	if (!strcmp("default_idle", s->sym) || !strcmp("cpu_idle", s->sym))
 		s->skip = 1;
-	if (!strcmp("enter_idle", s->sym) || !strcmp("exit_idle", s->sym))
+	else if (!strcmp("enter_idle", s->sym) || !strcmp("exit_idle", s->sym))
+		s->skip = 1;
+	else if (!strcmp("mwait_idle", s->sym))
 		s->skip = 1;
 
 	if (filter_match == 1) {
@@ -1042,9 +1046,10 @@ static void process_options(int argc, ch
 			{"symbol",	required_argument,	NULL, 's'},
 			{"stat",	no_argument,		NULL, 'S'},
 			{"zero",	no_argument,		NULL, 'z'},
+			{"mmap_pages",	required_argument,	NULL, 'm'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hn:p:s:Sx:z",
+		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hn:m:p:s:Sx:z",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1081,6 +1086,7 @@ static void process_options(int argc, ch
 		case 'S': run_perfstat			=	       1; break;
 		case 'x': vmlinux			= strdup(optarg); break;
 		case 'z': zero				=              1; break;
+		case 'm': mmap_pages			=   atoi(optarg); break;
 		default: error = 1; break;
 		}
 	}
@@ -1134,17 +1140,30 @@ repeat:
 	return head;
 }
 
+struct timeval last_read, this_read;
+
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
 
+	gettimeofday(&this_read, NULL);
+
 	if (head - old > md->mask) {
-		printf("ERROR: failed to keep up with mmap data\n");
-		exit(-1);
+		struct timeval iv;
+		unsigned long msecs;
+
+		timersub(&this_read, &last_read, &iv);
+		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
+
+		fprintf(stderr, "WARNING: failed to keep up with mmap data.  Last read %lu msecs ago.\n", msecs);
+
+		old = head;
 	}
 
+	last_read = this_read;
+
 	for (; old != head;) {
 		__u64 *ptr = (__u64 *)&data[old & md->mask];
 		old += sizeof(__u64);
@@ -1220,8 +1239,8 @@ int main(int argc, char *argv[])
 
 			mmap_array[i][counter].counter = counter;
 			mmap_array[i][counter].prev = 0;
-			mmap_array[i][counter].mask = 2*page_size - 1;
-			mmap_array[i][counter].base = mmap(NULL, 3*page_size,
+			mmap_array[i][counter].mask = mmap_pages*page_size - 1;
+			mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
 					PROT_READ, MAP_SHARED, fd[i][counter], 0);
 			if (mmap_array[i][counter].base == MAP_FAILED) {
 				printf("kerneltop error: failed to mmap with %d (%s)\n",

-- 

