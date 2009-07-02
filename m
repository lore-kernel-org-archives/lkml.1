Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZGBHH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZGBHH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZGBHHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:07:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:54546 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZGBHHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:07:15 -0400
Date: Thu, 2 Jul 2009 07:06:31 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246514758.13293.42.camel@marge.simson.net>
References: <1246514758.13293.42.camel@marge.simson.net>
Subject: [tip:perfcounters/urgent] perf_counter tools: Make symbol loading consistently return number of loaded symbols
Message-ID: <tip-9974f496782b7612e36a143bedda858f1cb953d4@git.kernel.org>
Git-Commit-ID: 9974f496782b7612e36a143bedda858f1cb953d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 07:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9974f496782b7612e36a143bedda858f1cb953d4
Gitweb:     http://git.kernel.org/tip/9974f496782b7612e36a143bedda858f1cb953d4
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 2 Jul 2009 08:05:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 08:42:20 +0200

perf_counter tools: Make symbol loading consistently return number of loaded symbols

perf_counter tools: Make symbol loading consistently return number of loaded symbols.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246514758.13293.42.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/symbol.c      |    9 ++++++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 132de8b..3becc8a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -172,7 +172,7 @@ static int load_kernel(void)
 		return -1;
 
 	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
-	if (err) {
+	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
 	} else
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index be1b758..58d1612 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -189,7 +189,7 @@ static int load_kernel(void)
 		return -1;
 
 	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
-	if (err) {
+	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
 	} else
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cdc74cf..97fde1d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -364,7 +364,7 @@ static int parse_symbols(void)
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) != 0)
+	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 78c2efd..c077b6a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -146,6 +146,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 	char *line = NULL;
 	size_t n;
 	FILE *file = fopen("/proc/kallsyms", "r");
+	int count = 0;
 
 	if (file == NULL)
 		goto out_failure;
@@ -188,8 +189,10 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 
 		if (filter && filter(self, sym))
 			symbol__delete(sym, self->sym_priv_size);
-		else
+		else {
 			dso__insert_symbol(self, sym);
+			count++;
+		}
 	}
 
 	/*
@@ -212,7 +215,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 	free(line);
 	fclose(file);
 
-	return 0;
+	return count;
 
 out_delete_line:
 	free(line);
@@ -639,7 +642,7 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	if (vmlinux)
 		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
 
-	if (err < 0)
+	if (err <= 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
 	return err;
