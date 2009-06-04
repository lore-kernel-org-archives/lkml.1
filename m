Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZFDNWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZFDNWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZFDNWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:22:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZFDNWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:22:14 -0400
Date: Thu, 4 Jun 2009 13:21:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Print out symbol parsing errors only if --verbose
Message-ID: <tip-bd74137ec9aaca3df3ff22b92455fddf7afaced1@git.kernel.org>
Git-Commit-ID: bd74137ec9aaca3df3ff22b92455fddf7afaced1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 13:21:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd74137ec9aaca3df3ff22b92455fddf7afaced1
Gitweb:     http://git.kernel.org/tip/bd74137ec9aaca3df3ff22b92455fddf7afaced1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 14:13:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 14:16:38 +0200

perf_counter tools: Print out symbol parsing errors only if --verbose

Also, add a suggestion to 'perf report', if the default sort order is
used.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   18 ++++++++++++++----
 Documentation/perf_counter/builtin-top.c    |    2 +-
 Documentation/perf_counter/util/symbol.c    |   27 +++++++++++++++------------
 Documentation/perf_counter/util/symbol.h    |    4 ++--
 4 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 56c664d..15fe9da 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -26,7 +26,10 @@
 
 static char		const *input_name = "perf.data";
 static char		*vmlinux = NULL;
-static char		*sort_order = "comm,dso";
+
+static char		default_sort_order[] = "comm,dso";
+static char		*sort_order = default_sort_order;
+
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -103,9 +106,10 @@ static struct dso *dsos__findnew(const char *name)
 	if (!dso)
 		goto out_delete_dso;
 
-	nr = dso__load(dso, NULL);
+	nr = dso__load(dso, NULL, verbose);
 	if (nr < 0) {
-		fprintf(stderr, "Failed to open: %s\n", name);
+		if (verbose)
+			fprintf(stderr, "Failed to open: %s\n", name);
 		goto out_delete_dso;
 	}
 	if (!nr && verbose) {
@@ -139,7 +143,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
 	if (err) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
@@ -741,6 +745,12 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 		ret += hist_entry__fprintf(fp, pos, total_samples);
 	}
 
+	if (!strcmp(sort_order, default_sort_order)) {
+		fprintf(fp, "#\n");
+		fprintf(fp, "# ( For more details, try: perf report --sort comm,dso,symbol )\n");
+		fprintf(fp, "#\n");
+	}
+
 	return ret;
 }
 
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 3f7778b..548a8da 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -349,7 +349,7 @@ static int parse_symbols(void)
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter) != 0)
+	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) != 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index 35ee6de..15d5cf9 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -124,7 +124,7 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
 	return ret;
 }
 
-static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter)
+static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verbose)
 {
 	struct rb_node *nd, *prevnd;
 	char *line = NULL;
@@ -370,7 +370,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 }
 
 static int dso__load_sym(struct dso *self, int fd, const char *name,
-			 symbol_filter_t filter)
+			 symbol_filter_t filter, int verbose)
 {
 	Elf_Data *symstrs;
 	uint32_t nr_syms;
@@ -387,13 +387,15 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		fprintf(stderr, "%s: cannot read %s ELF file.\n",
-			__func__, name);
+		if (verbose)
+			fprintf(stderr, "%s: cannot read %s ELF file.\n",
+				__func__, name);
 		goto out_close;
 	}
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		if (verbose)
+			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
 
@@ -473,7 +475,7 @@ out_close:
 	return err;
 }
 
-int dso__load(struct dso *self, symbol_filter_t filter)
+int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 {
 	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
 	char *name = malloc(size);
@@ -505,7 +507,7 @@ more:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, fd, name, filter);
+	ret = dso__load_sym(self, fd, name, filter, verbose);
 	close(fd);
 
 	/*
@@ -520,28 +522,29 @@ out:
 }
 
 static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
-			     symbol_filter_t filter)
+			     symbol_filter_t filter, int verbose)
 {
 	int err, fd = open(vmlinux, O_RDONLY);
 
 	if (fd < 0)
 		return -1;
 
-	err = dso__load_sym(self, fd, vmlinux, filter);
+	err = dso__load_sym(self, fd, vmlinux, filter, verbose);
 	close(fd);
 
 	return err;
 }
 
-int dso__load_kernel(struct dso *self, const char *vmlinux, symbol_filter_t filter)
+int dso__load_kernel(struct dso *self, const char *vmlinux,
+		     symbol_filter_t filter, int verbose)
 {
 	int err = -1;
 
 	if (vmlinux)
-		err = dso__load_vmlinux(self, vmlinux, filter);
+		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
 
 	if (err)
-		err = dso__load_kallsyms(self, filter);
+		err = dso__load_kallsyms(self, filter, verbose);
 
 	return err;
 }
diff --git a/Documentation/perf_counter/util/symbol.h b/Documentation/perf_counter/util/symbol.h
index b0299bc..8dd8522 100644
--- a/Documentation/perf_counter/util/symbol.h
+++ b/Documentation/perf_counter/util/symbol.h
@@ -32,8 +32,8 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 struct symbol *dso__find_symbol(struct dso *self, uint64_t ip);
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter);
-int dso__load(struct dso *self, symbol_filter_t filter);
+		     symbol_filter_t filter, int verbose);
+int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 
