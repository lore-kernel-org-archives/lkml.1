Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZGCG2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZGCG2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZGCG2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:28:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbZGCG2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:28:32 -0400
Date: Fri, 3 Jul 2009 06:27:53 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Adjust symbols in ET_EXEC files too
Message-ID: <tip-30d7a77dd5a9720430af72f6f62f5156fe073e55@git.kernel.org>
Git-Commit-ID: 30d7a77dd5a9720430af72f6f62f5156fe073e55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 06:27:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30d7a77dd5a9720430af72f6f62f5156fe073e55
Gitweb:     http://git.kernel.org/tip/30d7a77dd5a9720430af72f6f62f5156fe073e55
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 2 Jul 2009 21:24:14 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 08:24:13 +0200

perf_counter tools: Adjust symbols in ET_EXEC files too

Ingo Molnar wrote:

> i just bisected a 'perf report' bug that would cause us to not
> resolve all user-space symbols in a 'git gc' run to:
>
> f5812a7a336fb952d819e4427b9a2dce02368e82 is first bad commit
> commit f5812a7a336fb952d819e4427b9a2dce02368e82
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Tue Jun 30 11:43:17 2009 -0300
>
>     perf_counter tools: Adjust only prelinked symbol's addresses

Rename ->prelinked to ->adjust_symbols and making what was done
only for prelinked libraries also to ET_EXEC binaries, such as
/usr/bin/git:

[acme@doppio pahole]$ readelf -h /usr/bin/git | grep Type
  Type:                              EXEC (Executable file)
[acme@doppio pahole]$

And after installing the 'git-debuginfo' package, I get correct results:

[acme@doppio linux-2.6-tip]$ perf report --sort comm,dso,symbol -d /usr/bin/git | head -20

 #
 # (1139614 samples)
 #
 # Overhead           Command  Shared Object              Symbol
 # ........  ................  .........................  ......
 #
    34.98%               git  /usr/bin/git               [.] send_sideband
    33.39%               git  /usr/bin/git               [.] enter_repo
     6.81%               git  /usr/bin/git               [.] diff_opt_parse
     4.95%               git  /usr/bin/git               [.] is_repository_shallow
     3.24%               git  /usr/bin/git               [.] odb_mkstemp
     1.39%               git  /usr/bin/git               [.] output
     1.34%               git  /usr/bin/git               [.] xmmap
     1.25%               git  /usr/bin/git               [.] receive_pack_config
     1.16%               git  /usr/bin/git               [.] git_pathdup
     0.90%               git  /usr/bin/git               [.] read_object_with_reference
     0.86%               git  /usr/bin/git               [.] show_patch_diff
     0.85%               git  /usr/bin/git               0x00000000095e2e
     0.69%               git  /usr/bin/git               [.] display
[acme@doppio linux-2.6-tip]$

I'll check what are the last cases where we can't resolve symbols, like
this 0x00000000095e2e later.

And I guess this will fix the problems Mike were seeing too:

 [acme@doppio linux-2.6-tip]$ readelf -h ../build/perf/vmlinux | grep Type
   Type:                              EXEC (Executable file)
 [acme@doppio linux-2.6-tip]$

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |   11 ++++++-----
 tools/perf/util/symbol.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 98a1311..4683b67 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -555,9 +555,10 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	self->prelinked = elf_section_by_name(elf, &ehdr, &shdr,
-					      ".gnu.prelink_undo",
-					      NULL) != NULL;
+	self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				elf_section_by_name(elf, &ehdr, &shdr,
+						     ".gnu.prelink_undo",
+						     NULL) != NULL);
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		u64 obj_start;
@@ -580,7 +581,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		section_name = elf_sec__name(&shdr, secstrs);
 		obj_start = sym.st_value;
 
-		if (self->prelinked) {
+		if (self->adjust_symbols) {
 			if (verbose >= 2)
 				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
 					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
@@ -632,7 +633,7 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 	if (!name)
 		return -1;
 
-	self->prelinked = 0;
+	self->adjust_symbols = 0;
 
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
 		return dso__load_perf_map(self, filter, verbose);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4e141a3..7918cff 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -24,7 +24,7 @@ struct dso {
 	struct rb_root	 syms;
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
 	unsigned int	 sym_priv_size;
-	unsigned char	 prelinked;
+	unsigned char	 adjust_symbols;
 	char		 name[0];
 };
 
