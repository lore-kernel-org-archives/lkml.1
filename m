Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbZE0HVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbZE0HVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759969AbZE0HRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:50212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbZE0HRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:37 -0400
Date: Wed, 27 May 2009 07:16:38 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, rostedt@goodmis.org,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090526224614.GK4424@ghostprotocols.net>
References: <20090526224614.GK4424@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf report: Show the IP only in --verbose mode
Message-ID: <tip-815e777f913ed54ddb449d2854015c65b4ecbfe3@git.kernel.org>
Git-Commit-ID: 815e777f913ed54ddb449d2854015c65b4ecbfe3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 07:16:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  815e777f913ed54ddb449d2854015c65b4ecbfe3
Gitweb:     http://git.kernel.org/tip/815e777f913ed54ddb449d2854015c65b4ecbfe3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 May 2009 19:46:14 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 09:10:37 +0200

perf report: Show the IP only in --verbose mode

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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090526224614.GK4424@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index ed3da9d..2d65d9c 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -22,6 +22,7 @@ static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
+static int 		verbose;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -551,9 +552,12 @@ symhist__fprintf(struct symhist *self, uint64_t total_samples, FILE *fp)
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
@@ -974,6 +978,8 @@ static const char * const report_usage[] = {
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_END()
