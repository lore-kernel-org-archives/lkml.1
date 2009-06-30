Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbZF3POU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbZF3POU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZF3POH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:14:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:50483 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZF3POF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:14:05 -0400
Date: Tue, 30 Jun 2009 15:12:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630144317.GB12663@ghostprotocols.net>
References: <20090630144317.GB12663@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf_counter tools: Adjust only prelinked symbol's addresses
Message-ID: <tip-f5812a7a336fb952d819e4427b9a2dce02368e82@git.kernel.org>
Git-Commit-ID: f5812a7a336fb952d819e4427b9a2dce02368e82
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 15:12:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5812a7a336fb952d819e4427b9a2dce02368e82
Gitweb:     http://git.kernel.org/tip/f5812a7a336fb952d819e4427b9a2dce02368e82
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 30 Jun 2009 11:43:17 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 30 Jun 2009 17:09:30 +0200

perf_counter tools: Adjust only prelinked symbol's addresses

I.e. we can't handle these two kinds of files in the same way:

1) prelinked system library:

[acme@doppio pahole]$ readelf -s /usr/lib64/libdw-0.141.so | egrep 'FUNC.+GLOBAL.+dwfl_report_elf'
   278: 00000030450105a0   261 FUNC    GLOBAL DEFAULT   12 dwfl_report_elf@@ELFUTILS_0.122

2) not prelinked library with debug information from a -debuginfo package:

[acme@doppio pahole]$ readelf -s /usr/lib/debug/usr/lib64/libdw-0.141.so.debug | egrep 'FUNC.+GLOBAL.+dwfl_report_elf'
   629: 00000000000105a0   261 FUNC    GLOBAL DEFAULT   12 dwfl_report_elf
[acme@doppio pahole]$

Now the numbers I got for a pahole perf run are in line with
the numbers I get from oprofile.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090630144317.GB12663@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |   16 +++++++++++-----
 tools/perf/util/symbol.h |    3 ++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9c659ef..78c2efd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -520,7 +520,9 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-
+	self->prelinked = elf_section_by_name(elf, &ehdr, &shdr,
+					      ".gnu.prelink_undo",
+					      NULL) != NULL;
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		u64 obj_start;
@@ -535,11 +537,13 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		gelf_getshdr(sec, &shdr);
 		obj_start = sym.st_value;
 
-		if (verbose >= 2)
-			printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
-				(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
+		if (self->prelinked) {
+			if (verbose >= 2)
+				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
+					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
 
-		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+		}
 
 		f = symbol__new(sym.st_value, sym.st_size,
 				elf_sym__name(&sym, symstrs),
@@ -573,6 +577,8 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 	if (!name)
 		return -1;
 
+	self->prelinked = 0;
+
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
 		return dso__load_perf_map(self, filter, verbose);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 940b432..2c48ace 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -20,8 +20,9 @@ struct symbol {
 struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
-	unsigned int	 sym_priv_size;
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
+	unsigned int	 sym_priv_size;
+	unsigned char	 prelinked;
 	char		 name[0];
 };
 
