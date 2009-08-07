Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbZHGHkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbZHGHkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932287AbZHGHku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:40:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:53897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbZHGHkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:40:46 -0400
Date: Fri, 7 Aug 2009 07:40:14 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090806174317.GC4339@ghostprotocols.net>
References: <20090806174317.GC4339@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf report: Help the finding of symbol bugs - show the symtab origin (DSO, build-id, kernel, etc)
Message-ID: <tip-eeafb52ac8fa0fddcabe3d6e28c38d5c948d327e@git.kernel.org>
Git-Commit-ID: eeafb52ac8fa0fddcabe3d6e28c38d5c948d327e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 07:40:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eeafb52ac8fa0fddcabe3d6e28c38d5c948d327e
Gitweb:     http://git.kernel.org/tip/eeafb52ac8fa0fddcabe3d6e28c38d5c948d327e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 6 Aug 2009 14:43:17 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 09:37:31 +0200

perf report: Help the finding of symbol bugs - show the symtab origin (DSO, build-id, kernel, etc)

Used with perf report --verbose:

[acme@doppio linux-2.6-tip]$ perf report -v | head -16
     5.17%  firefox  /usr/lib64/xulrunner-1.9.1/libxul.so   0x00000000005d8eee f [.] imgContainer::DrawFrameTo(gfxIImageFrame*, gfxIImageFrame*, nsRect&)
     2.56%  firefox  /lib64/libpthread-2.10.1.so            0x0000000000008e02 d [.] __pthread_mutex_lock_internal
     1.94%  firefox  /usr/lib64/xulrunner-1.9.1/libxul.so   0x0000000000d0af8f f [.] SearchTable
     1.75%  firefox  [kernel]                               0xffffffffff60013b k [.] vread_hpet
     1.63%  firefox  /lib64/libpthread-2.10.1.so            0x000000000000a404 d [.] __pthread_mutex_unlock
     1.47%  firefox  /usr/lib64/xulrunner-1.9.1/libmozjs.so 0x00000000000482ea f [.] js_Interpret
     1.42%  firefox  /usr/lib64/xulrunner-1.9.1/libmozjs.so 0x000000000003eda3 f [.] JS_CallTracer
     1.24%  firefox  [kernel]                               0xffffffff8102ca4a k [k] read_hpet
     1.16%  firefox  [kernel]                               0xffffffff810f3dd4 k [k] fget_light
     1.11%  firefox  /usr/lib64/xulrunner-1.9.1/libmozjs.so 0x00000000000567ff f [.] js_TraceObject
     0.98%  firefox  /usr/lib64/firefox-3.5.2/firefox       0x000000000000dd23 b [.] arena_ralloc
[acme@doppio linux-2.6-tip]$

The new field is just after the symbol address. To help in
figuring out symbol resolution bugs.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090806174317.GC4339@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    3 +-
 tools/perf/util/symbol.c    |   57 ++++++++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.h    |    2 +
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8420546..a5e2f8d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -700,7 +700,8 @@ sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += repsep_fprintf(fp, "%#018llx  ", (u64)self->ip);
+		ret += repsep_fprintf(fp, "%#018llx %c ", (u64)self->ip,
+				      dso__symtab_origin(self->dso));
 
 	ret += repsep_fprintf(fp, "[%c] ", self->level);
 	if (self->sym) {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 16ddca2..f1dcede 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -24,6 +24,16 @@ const char *sym_hist_filter;
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
 
+enum dso_origin {
+	DSO__ORIG_KERNEL = 0,
+	DSO__ORIG_JAVA_JIT,
+	DSO__ORIG_FEDORA,
+	DSO__ORIG_UBUNTU,
+	DSO__ORIG_BUILDID,
+	DSO__ORIG_DSO,
+	DSO__ORIG_NOT_FOUND,
+};
+
 static struct symbol *symbol__new(u64 start, u64 len,
 				  const char *name, unsigned int priv_size,
 				  u64 obj_start, int verbose)
@@ -81,6 +91,7 @@ struct dso *dso__new(const char *name, unsigned int sym_priv_size)
 		self->sym_priv_size = sym_priv_size;
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
+		self->origin = DSO__ORIG_NOT_FOUND;
 	}
 
 	return self;
@@ -710,7 +721,7 @@ static char *dso__read_build_id(struct dso *self, int verbose)
 		++raw;
 		bid += 2;
 	}
-	if (verbose)
+	if (verbose >= 2)
 		printf("%s(%s): %s\n", __func__, self->name, build_id);
 out_elf_end:
 	elf_end(elf);
@@ -720,11 +731,26 @@ out:
 	return build_id;
 }
 
+char dso__symtab_origin(const struct dso *self)
+{
+	static const char origin[] = {
+		[DSO__ORIG_KERNEL] =   'k',
+		[DSO__ORIG_JAVA_JIT] = 'j',
+		[DSO__ORIG_FEDORA] =   'f',
+		[DSO__ORIG_UBUNTU] =   'u',
+		[DSO__ORIG_BUILDID] =  'b',
+		[DSO__ORIG_DSO] =      'd',
+	};
+
+	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
+		return '!';
+	return origin[self->origin];
+}
+
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 {
 	int size = PATH_MAX;
 	char *name = malloc(size), *build_id = NULL;
-	int variant = 0;
 	int ret = -1;
 	int fd;
 
@@ -733,19 +759,26 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 
 	self->adjust_symbols = 0;
 
-	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
-		return dso__load_perf_map(self, filter, verbose);
+	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
+		ret = dso__load_perf_map(self, filter, verbose);
+		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
+					 DSO__ORIG_NOT_FOUND;
+		return ret;
+	}
+
+	self->origin = DSO__ORIG_FEDORA - 1;
 
 more:
 	do {
-		switch (variant) {
-		case 0: /* Fedora */
+		self->origin++;
+		switch (self->origin) {
+		case DSO__ORIG_FEDORA:
 			snprintf(name, size, "/usr/lib/debug%s.debug", self->name);
 			break;
-		case 1: /* Ubuntu */
+		case DSO__ORIG_UBUNTU:
 			snprintf(name, size, "/usr/lib/debug%s", self->name);
 			break;
-		case 2:
+		case DSO__ORIG_BUILDID:
 			build_id = dso__read_build_id(self, verbose);
 			if (build_id != NULL) {
 				snprintf(name, size,
@@ -754,16 +787,15 @@ more:
 				free(build_id);
 				break;
 			}
-			variant++;
+			self->origin++;
 			/* Fall thru */
-		case 3: /* Sane people */
+		case DSO__ORIG_DSO:
 			snprintf(name, size, "%s", self->name);
 			break;
 
 		default:
 			goto out;
 		}
-		variant++;
 
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
@@ -899,6 +931,9 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	if (err <= 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
+	if (err > 0)
+		self->origin = DSO__ORIG_KERNEL;
+
 	return err;
 }
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2f92b21..1e003ec 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -26,6 +26,7 @@ struct dso {
 	unsigned int	 sym_priv_size;
 	unsigned char	 adjust_symbols;
 	unsigned char	 slen_calculated;
+	unsigned char	 origin;
 	char		 name[0];
 };
 
@@ -49,6 +50,7 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
+char dso__symtab_origin(const struct dso *self);
 
 void symbol__init(void);
 #endif /* _PERF_SYMBOL_ */
