Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGBGGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGBGGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZGBGGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:06:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:56110 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751425AbZGBGF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:05:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cPXdgx2CccT6QjoZ/M1w/vuzKnhkVuiQZIgeqnm
	CMJGjDkQhCZH4Z
Subject: [patch 1/4] perf_counter tools: Make symbol loading consistently
 return number of loaded symbols
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1246514639.13293.40.camel@marge.simson.net>
References: <1246514639.13293.40.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:05:58 +0200
Message-Id: <1246514758.13293.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: Make symbol loading consistently return number of loaded symbols.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/symbol.c      |    9 ++++++---
 4 files changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/tools/perf/builtin-annotate.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-annotate.c
+++ linux-2.6/tools/perf/builtin-annotate.c
@@ -172,7 +172,7 @@ static int load_kernel(void)
 		return -1;
 
 	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
-	if (err) {
+	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
 	} else
Index: linux-2.6/tools/perf/builtin-report.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-report.c
+++ linux-2.6/tools/perf/builtin-report.c
@@ -189,7 +189,7 @@ static int load_kernel(void)
 		return -1;
 
 	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
-	if (err) {
+	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
 	} else
Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -364,7 +364,7 @@ static int parse_symbols(void)
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) != 0)
+	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
Index: linux-2.6/tools/perf/util/symbol.c
===================================================================
--- linux-2.6.orig/tools/perf/util/symbol.c
+++ linux-2.6/tools/perf/util/symbol.c
@@ -146,6 +146,7 @@ static int dso__load_kallsyms(struct dso
 	char *line = NULL;
 	size_t n;
 	FILE *file = fopen("/proc/kallsyms", "r");
+	int count = 0;
 
 	if (file == NULL)
 		goto out_failure;
@@ -188,8 +189,10 @@ static int dso__load_kallsyms(struct dso
 
 		if (filter && filter(self, sym))
 			symbol__delete(sym, self->sym_priv_size);
-		else
+		else {
 			dso__insert_symbol(self, sym);
+			count++;
+		}
 	}
 
 	/*
@@ -212,7 +215,7 @@ static int dso__load_kallsyms(struct dso
 	free(line);
 	fclose(file);
 
-	return 0;
+	return count;
 
 out_delete_line:
 	free(line);
@@ -639,7 +642,7 @@ int dso__load_kernel(struct dso *self, c
 	if (vmlinux)
 		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
 
-	if (err < 0)
+	if (err <= 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
 	return err;


