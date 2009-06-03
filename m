Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZFCNHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZFCNHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZFCNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:07:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:44795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbZFCNHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:07:18 -0400
Date: Wed, 3 Jun 2009 13:06:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Use long arg for counter period
Message-ID: <tip-e61078a0c88773d3465b0b9d665c5ed6b952b1cf@git.kernel.org>
Git-Commit-ID: e61078a0c88773d3465b0b9d665c5ed6b952b1cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 13:06:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e61078a0c88773d3465b0b9d665c5ed6b952b1cf
Gitweb:     http://git.kernel.org/tip/e61078a0c88773d3465b0b9d665c5ed6b952b1cf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Jun 2009 11:24:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 14:14:31 +0200

perf record: Use long arg for counter period

I wrote this to test the extended period emulation, we might as
well merge it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c     |    6 +++---
 Documentation/perf_counter/util/parse-options.c |   16 ++++++++++++++++
 Documentation/perf_counter/util/parse-options.h |    2 ++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index ec3b73a..cea5b8d 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -20,8 +20,8 @@
 #define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
 #define __ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
-static int			default_interval = 100000;
-static int			event_count[MAX_COUNTERS];
+static long			default_interval = 100000;
+static long			event_count[MAX_COUNTERS];
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 static int			nr_cpus				= 0;
@@ -494,7 +494,7 @@ static const struct option options[] = {
 			    "append to the output file to do incremental profiling"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file"),
-	OPT_INTEGER('c', "count", &default_interval,
+	OPT_LONG('c', "count", &default_interval,
 		    "event period to sample"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
diff --git a/Documentation/perf_counter/util/parse-options.c b/Documentation/perf_counter/util/parse-options.c
index 28b34c1..b80abd9 100644
--- a/Documentation/perf_counter/util/parse-options.c
+++ b/Documentation/perf_counter/util/parse-options.c
@@ -113,6 +113,22 @@ static int get_value(struct parse_opt_ctx_t *p,
 			return opterror(opt, "expects a numerical value", flags);
 		return 0;
 
+	case OPTION_LONG:
+		if (unset) {
+			*(long *)opt->value = 0;
+			return 0;
+		}
+		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
+			*(long *)opt->value = opt->defval;
+			return 0;
+		}
+		if (get_arg(p, opt, flags, &arg))
+			return -1;
+		*(long *)opt->value = strtol(arg, (char **)&s, 10);
+		if (*s)
+			return opterror(opt, "expects a numerical value", flags);
+		return 0;
+
 	default:
 		die("should not happen, someone must be hit on the forehead");
 	}
diff --git a/Documentation/perf_counter/util/parse-options.h b/Documentation/perf_counter/util/parse-options.h
index a81c7fa..a1039a6 100644
--- a/Documentation/perf_counter/util/parse-options.h
+++ b/Documentation/perf_counter/util/parse-options.h
@@ -14,6 +14,7 @@ enum parse_opt_type {
 	/* options with arguments (usually) */
 	OPTION_STRING,
 	OPTION_INTEGER,
+	OPTION_LONG,
 	OPTION_CALLBACK,
 };
 
@@ -97,6 +98,7 @@ struct option {
 #define OPT_SET_INT(s, l, v, h, i)  { OPTION_SET_INT, (s), (l), (v), NULL, (h), 0, NULL, (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { OPTION_SET_PTR, (s), (l), (v), NULL, (h), 0, NULL, (p) }
 #define OPT_INTEGER(s, l, v, h)     { OPTION_INTEGER, (s), (l), (v), NULL, (h) }
+#define OPT_LONG(s, l, v, h)        { OPTION_LONG, (s), (l), (v), NULL, (h) }
 #define OPT_STRING(s, l, v, a, h)   { OPTION_STRING,  (s), (l), (v), (a), (h) }
 #define OPT_DATE(s, l, v, h) \
 	{ OPTION_CALLBACK, (s), (l), (v), "time",(h), 0, \
