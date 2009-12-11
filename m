Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZLKQuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZLKQuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZLKQup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:50:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:60429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZLKQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:50:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf symbols: Introduce ELF counterparts to symbol_type__is_a
Date: Fri, 11 Dec 2009 14:50:38 -0200
Message-Id: <1260550239-5372-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260550239-5372-1-git-send-email-acme@infradead.org>
References: <1260550239-5372-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For selecting the right types of symbols in ELF symtabs.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index bb21c96..db8dc97 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -751,6 +751,26 @@ out:
 	return 0;
 }
 
+static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sym__is_function(self);
+	default:
+		return false;
+	}
+}
+
+static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sec__is_text(self, secstrs);
+	default:
+		return false;
+	}
+}
+
 static int dso__load_sym(struct dso *self, struct map *map,
 			 struct map_groups *mg, const char *name, int fd,
 			 symbol_filter_t filter, int kernel, int kmodule)
@@ -825,7 +845,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 		int is_label = elf_sym__is_label(&sym);
 		const char *section_name;
 
-		if (!is_label && !elf_sym__is_function(&sym))
+		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
 		sec = elf_getscn(elf, sym.st_shndx);
@@ -834,7 +854,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 
 		gelf_getshdr(sec, &shdr);
 
-		if (is_label && !elf_sec__is_text(&shdr, secstrs))
+		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
 			continue;
 
 		elf_name = elf_sym__name(&sym, symstrs);
-- 
1.6.2.5

