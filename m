Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbZCYMIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbZCYMIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbZCYMHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:07:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760624AbZCYMHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:07:41 -0400
Date: Wed, 25 Mar 2009 12:07:02 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
In-Reply-To: <20090325113317.104545398@chello.nl>
References: <20090325113317.104545398@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: kerneltop: mmap_pages argument
Message-ID: <tip-a7aa0cab482525a039b7ce7b1c8cf62f57f441c9@git.kernel.org>
Git-Commit-ID: a7aa0cab482525a039b7ce7b1c8cf62f57f441c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:07:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7aa0cab482525a039b7ce7b1c8cf62f57f441c9
Gitweb:     http://git.kernel.org/tip/a7aa0cab482525a039b7ce7b1c8cf62f57f441c9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:30:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:53 +0100

perf_counter: kerneltop: mmap_pages argument

provide a knob to set the number of mmap data pages.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20090325113317.104545398@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 7ebde7a..3e45bf6 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
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
@@ -732,7 +734,9 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* Tag events to be skipped. */
 	if (!strcmp("default_idle", s->sym) || !strcmp("cpu_idle", s->sym))
 		s->skip = 1;
-	if (!strcmp("enter_idle", s->sym) || !strcmp("exit_idle", s->sym))
+	else if (!strcmp("enter_idle", s->sym) || !strcmp("exit_idle", s->sym))
+		s->skip = 1;
+	else if (!strcmp("mwait_idle", s->sym))
 		s->skip = 1;
 
 	if (filter_match == 1) {
@@ -1042,9 +1046,10 @@ static void process_options(int argc, char *argv[])
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
@@ -1081,6 +1086,7 @@ static void process_options(int argc, char *argv[])
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
