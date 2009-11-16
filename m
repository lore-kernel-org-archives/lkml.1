Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZKPQsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZKPQsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZKPQsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:48:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:37066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbZKPQsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:48:16 -0500
Date: Mon, 16 Nov 2009 16:45:36 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258386491-20278-1-git-send-email-acme@infradead.org>
References: <1258386491-20278-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Call the symbol filter in dso__synthesize_plt_symbols()
Message-ID: <tip-82164161679c448f33092945ea97cb547a13683a@git.kernel.org>
Git-Commit-ID: 82164161679c448f33092945ea97cb547a13683a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82164161679c448f33092945ea97cb547a13683a
Gitweb:     http://git.kernel.org/tip/82164161679c448f33092945ea97cb547a13683a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 13:48:11 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 17:29:54 +0100

perf symbols: Call the symbol filter in dso__synthesize_plt_symbols()

We need to pass the symbol to the filter so that, for instance,
'perf top' can do filtering and also set the private area it
manages, setting the ->map pointer, etc.

I found this while running 'perf top' on a machine where hits
happened on PLT symbols, where ->map wasn't being set up and
segfaults thus happened.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258386491-20278-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9c286db..93e4b52 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -281,6 +281,11 @@ static int kernel_maps__load_all_kallsyms(void)
 		if (sym == NULL)
 			goto out_delete_line;
 
+		/*
+		 * We will pass the symbols to the filter later, in
+		 * kernel_maps__split_kallsyms, when we have split the
+		 * maps per module
+		 */
 		dso__insert_symbol(kernel_map->dso, sym);
 	}
 
@@ -555,7 +560,8 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *self)
+static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
+				       symbol_filter_t filter)
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
@@ -643,8 +649,12 @@ static int dso__synthesize_plt_symbols(struct  dso *self)
 			if (!f)
 				goto out_elf_end;
 
-			dso__insert_symbol(self, f);
-			++nr;
+			if (filter && filter(map, f))
+				symbol__delete(f);
+			else {
+				dso__insert_symbol(self, f);
+				++nr;
+			}
 		}
 	} else if (shdr_rel_plt.sh_type == SHT_REL) {
 		GElf_Rel pos_mem, *pos;
@@ -661,8 +671,12 @@ static int dso__synthesize_plt_symbols(struct  dso *self)
 			if (!f)
 				goto out_elf_end;
 
-			dso__insert_symbol(self, f);
-			++nr;
+			if (filter && filter(map, f))
+				symbol__delete(f);
+			else {
+				dso__insert_symbol(self, f);
+				++nr;
+			}
 		}
 	}
 
@@ -1050,7 +1064,7 @@ compare_build_id:
 		goto more;
 
 	if (ret > 0) {
-		int nr_plt = dso__synthesize_plt_symbols(self);
+		int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
 		if (nr_plt > 0)
 			ret += nr_plt;
 	}
