Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbZEZWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbZEZWtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759767AbZEZWqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:46:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759666AbZEZWqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:46:48 -0400
Date: Tue, 26 May 2009 19:46:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf: report should show the IP only in --verbose
	mode
Message-ID: <20090526224614.GK4424@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ce04d315572e173eb2a443ebc973b6bb3f32596a
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue May 26 19:43:25 2009 -0300

    perf: report should show the IP only in --verbose mode
    
    [acme@emilia ~]$ perf report | head
     4.95          find [k] _spin_lock
     2.19          find [k] ext3fs_dirhash	[ext3]
     1.87          find [k] __rcu_read_lock
     1.86          find [k] _atomic_dec_and_lock
     1.86          find [.] /lib64/libc-2.5.so: __GI_strlen
     1.85          find [k] __kmalloc
     1.62          find [.] /lib64/libc-2.5.so: vfprintf
     1.59          find [k] __rcu_read_unlock
     1.55          find [k] __d_lookup
    
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index a55f15d..e681f38 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -22,6 +22,7 @@ static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
+static int 		verbose;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -545,9 +546,12 @@ symhist__fprintf(struct symhist *self, uint64_t total_samples, FILE *fp)
 	else
 		ret = fprintf(fp, "%12d", self->count);
 
-	ret += fprintf(fp, "%14s [%c] %#018llx ",
+	ret += fprintf(fp, "%14s [%c] ",
 		       thread__name(self->thread, bf, sizeof(bf)),
-		       self->level, (unsigned long long)self->ip);
+		       self->level);
+
+	if (verbose)
+		ret += fprintf(fp, "%#018llx ", (unsigned long long)self->ip);
 
 	if (self->level != '.')
 		ret += fprintf(fp, "%s\n",
@@ -968,6 +972,8 @@ static const char * const report_usage[] = {
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_END()
