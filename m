Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0BWCFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab0BWCFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:05:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 5/9] perf probe: Use elfutils-libdw for analyzing
	debuginfo
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>
Date: Mon, 22 Feb 2010 21:08:53 -0500
Message-ID: <20100223020852.26668.93415.stgit@localhost6.localdomain6>
In-Reply-To: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer gcc introduces newer & richer debuginfo, and only libdw
in elfutils project can support it. So perf probe moves onto
elfutils-libdw from libdwarf.

Changes in v3:
 - Cast Dwarf_Addr/Dwarf_Word to uintmax_t for printf-formats.
 - Recover a sign-prefix which was removed in v2 by mistake.

Changes in v2:
 - Fix a type-casting bug in Makefile.
 - Cast Dwarf_Addr/Dwarf_Word to unsigned long long for printf-formats.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---

 tools/perf/Makefile            |   10 -
 tools/perf/builtin-probe.c     |   22 +
 tools/perf/util/probe-finder.c |  696 ++++++++++++++++------------------------
 tools/perf/util/probe-finder.h |   52 +--
 4 files changed, 314 insertions(+), 466 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3a5fb36..3b35acc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -501,12 +501,12 @@ else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#ifndef _MIPS_SZLONG'; echo '\#define _MIPS_SZLONG 0'; echo '\#endif'; echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/libdwarf -ldwarf -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
-	BASIC_CFLAGS += -DNO_LIBDWARF
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
+	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
-	BASIC_CFLAGS += -I/usr/include/libdwarf
-	EXTLIBS += -lelf -ldwarf
+	BASIC_CFLAGS += -I/usr/include/elfutils
+	EXTLIBS += -lelf -ldw
 	LIB_OBJS += util/probe-finder.o
 endif
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c3e6119..d8d3f05 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -128,7 +128,7 @@ static void evaluate_probe_point(struct probe_point *pp)
 		    pp->function);
 }
 
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 static int open_vmlinux(void)
 {
 	if (map__load(session.kmaps[MAP__FUNCTION], NULL) < 0) {
@@ -156,7 +156,7 @@ static const char * const probe_usage[] = {
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	"perf probe --line 'LINEDESC'",
 #endif
 	NULL
@@ -165,7 +165,7 @@ static const char * const probe_usage[] = {
 static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 #endif
@@ -174,7 +174,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef NO_LIBDWARF
+#ifdef NO_DWARF_SUPPORT
 		"[EVENT=]FUNC[+OFFS|%return] [ARG ...]",
 #else
 		"[EVENT=]FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
@@ -185,7 +185,7 @@ static const struct option options[] = {
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFFS:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef NO_LIBDWARF
+#ifdef NO_DWARF_SUPPORT
 		"\t\tARG:\tProbe argument (only \n"
 #else
 		"\t\tSRC:\tSource code path\n"
@@ -197,7 +197,7 @@ static const struct option options[] = {
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &session.force_add, "forcibly add events"
 		    " with existing name"),
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -225,7 +225,7 @@ static void init_vmlinux(void)
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
 	int i, ret;
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	int fd;
 #endif
 	struct probe_point *pp;
@@ -261,7 +261,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		return 0;
 	}
 
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	if (session.show_lines) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --line with"
@@ -292,9 +292,9 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	init_vmlinux();
 
 	if (session.need_dwarf)
-#ifdef NO_LIBDWARF
+#ifdef NO_DWARF_SUPPORT
 		die("Debuginfo-analysis is not supported");
-#else	/* !NO_LIBDWARF */
+#else	/* !NO_DWARF_SUPPORT */
 		pr_debug("Some probes require debuginfo.\n");
 
 	fd = open_vmlinux();
@@ -335,7 +335,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	close(fd);
 
 end_dwarf:
-#endif /* !NO_LIBDWARF */
+#endif /* !NO_DWARF_SUPPORT */
 
 	/* Synthesize probes without dwarf */
 	for (i = 0; i < session.nr_probe; i++) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c819fd5..c422472 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -44,8 +44,6 @@ struct die_link {
 	Dwarf_Die die;			/* Current die */
 };
 
-static Dwarf_Debug __dw_debug;
-static Dwarf_Error __dw_error;
 
 /*
  * Generic dwarf analysis helpers
@@ -114,157 +112,114 @@ static int strtailcmp(const char *s1, const char *s2)
 }
 
 /* Find the fileno of the target file. */
-static Dwarf_Unsigned cu_find_fileno(Dwarf_Die cu_die, const char *fname)
+static int cu_find_fileno(Dwarf_Die *cu_die, const char *fname)
 {
-	Dwarf_Signed cnt, i;
-	Dwarf_Unsigned found = 0;
-	char **srcs;
+	Dwarf_Files *files;
+	size_t nfiles, i;
+	const char *src;
 	int ret;
 
 	if (!fname)
-		return 0;
+		return -EINVAL;
 
-	ret = dwarf_srcfiles(cu_die, &srcs, &cnt, &__dw_error);
-	if (ret == DW_DLV_OK) {
-		for (i = 0; i < cnt && !found; i++) {
-			if (strtailcmp(srcs[i], fname) == 0)
-				found = i + 1;
-			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
+	ret = dwarf_getsrcfiles(cu_die, &files, &nfiles);
+	if (ret == 0) {
+		for (i = 0; i < nfiles; i++) {
+			src = dwarf_filesrc(files, i, NULL, NULL);
+			if (strtailcmp(src, fname) == 0) {
+				ret = (int)i;	/*???: +1 or not?*/
+				break;
+			}
 		}
-		for (; i < cnt; i++)
-			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
-		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
+		if (ret)
+			pr_debug("found fno: %d\n", ret);
 	}
-	if (found)
-		pr_debug("found fno: %d\n", (int)found);
-	return found;
+	return ret;
 }
 
-static int cu_get_filename(Dwarf_Die cu_die, Dwarf_Unsigned fno, char **buf)
+struct __addr_die_search_param {
+	Dwarf_Addr	addr;
+	Dwarf_Die	*die_mem;
+};
+
+static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
 {
-	Dwarf_Signed cnt, i;
-	char **srcs;
-	int ret = 0;
+	struct __addr_die_search_param *ad = data;
 
-	if (!buf || !fno)
-		return -EINVAL;
+	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
+	    dwarf_haspc(fn_die, ad->addr)) {
+		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
+		return DWARF_CB_ABORT;
+	}
+	return DWARF_CB_OK;
+}
 
-	ret = dwarf_srcfiles(cu_die, &srcs, &cnt, &__dw_error);
-	if (ret == DW_DLV_OK) {
-		if ((Dwarf_Unsigned)cnt > fno - 1) {
-			*buf = strdup(srcs[fno - 1]);
-			ret = 0;
-			pr_debug("found filename: %s\n", *buf);
-		} else
-			ret = -ENOENT;
-		for (i = 0; i < cnt; i++)
-			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
-		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
-	} else
-		ret = -EINVAL;
-	return ret;
+/* Search a real subprogram including this line, */
+static Dwarf_Die *die_get_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
+					  Dwarf_Die *die_mem)
+{
+	struct __addr_die_search_param ad;
+	ad.addr = addr;
+	ad.die_mem = die_mem;
+	/* dwarf_getscopes can't find subprogram. */
+	if (!dwarf_getfuncs(cu_die, __die_search_func_cb, &ad, 0))
+		return NULL;
+	else
+		return die_mem;
 }
 
 /* Compare diename and tname */
-static int die_compare_name(Dwarf_Die dw_die, const char *tname)
+static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
-	char *name;
-	int ret;
-	ret = dwarf_diename(dw_die, &name, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK) {
-		ret = strcmp(tname, name);
-		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
-	} else
-		ret = -1;
-	return ret;
+	const char *name;
+	name = dwarf_diename(dw_die);
+	DIE_IF(name == NULL);
+	return strcmp(tname, name);
 }
 
 /* Check the address is in the subprogram(function). */
-static int die_within_subprogram(Dwarf_Die sp_die, Dwarf_Addr addr,
-				 Dwarf_Signed *offs)
+static bool die_within_subprogram(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				 size_t *offs)
 {
-	Dwarf_Addr lopc, hipc;
+	Dwarf_Addr epc;
 	int ret;
 
-	/* TODO: check ranges */
-	ret = dwarf_lowpc(sp_die, &lopc, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_NO_ENTRY)
-		return 0;
-	ret = dwarf_highpc(sp_die, &hipc, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	if (lopc <= addr && addr < hipc) {
-		*offs = addr - lopc;
-		return 1;
-	} else
-		return 0;
-}
+	ret = dwarf_haspc(sp_die, addr);
+	if (ret <= 0)
+		return false;
 
-/* Check the die is inlined function */
-static Dwarf_Bool die_inlined_subprogram(Dwarf_Die dw_die)
-{
-	/* TODO: check strictly */
-	Dwarf_Bool inl;
-	int ret;
+	if (offs) {
+		ret = dwarf_entrypc(sp_die, &epc);
+		DIE_IF(ret == -1);
+		*offs = addr - epc;
+	}
 
-	ret = dwarf_hasattr(dw_die, DW_AT_inline, &inl, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	return inl;
+	return true;
 }
 
-/* Get the offset of abstruct_origin */
-static Dwarf_Off die_get_abstract_origin(Dwarf_Die dw_die)
+/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
+static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
 {
-	Dwarf_Attribute attr;
-	Dwarf_Off cu_offs;
+	Dwarf_Addr epc;
 	int ret;
 
-	ret = dwarf_attr(dw_die, DW_AT_abstract_origin, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = dwarf_formref(attr, &cu_offs, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-	return cu_offs;
+	ret = dwarf_entrypc(dw_die, &epc);
+	DIE_IF(ret == -1);
+	return epc;
 }
 
-/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
-static Dwarf_Addr die_get_entrypc(Dwarf_Die dw_die)
+/* Check if the abstract origin's address or not */
+static bool die_compare_abstract_origin(Dwarf_Die *in_die, void *origin_addr)
 {
 	Dwarf_Attribute attr;
-	Dwarf_Addr addr;
-	Dwarf_Off offs;
-	Dwarf_Ranges *ranges;
-	Dwarf_Signed cnt;
-	int ret;
+	Dwarf_Die origin;
 
-	/* Try to get entry pc */
-	ret = dwarf_attr(dw_die, DW_AT_entry_pc, &attr, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK) {
-		ret = dwarf_formaddr(attr, &addr, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-		return addr;
-	}
+	if (!dwarf_attr(in_die, DW_AT_abstract_origin, &attr))
+		return false;
+	if (!dwarf_formref_die(&attr, &origin))
+		return false;
 
-	/* Try to get low pc */
-	ret = dwarf_lowpc(dw_die, &addr, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK)
-		return addr;
-
-	/* Try to get ranges */
-	ret = dwarf_attr(dw_die, DW_AT_ranges, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = dwarf_formref(attr, &offs, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = dwarf_get_ranges(__dw_debug, offs, &ranges, &cnt, NULL,
-				&__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	addr = ranges[0].dwr_addr1;
-	dwarf_ranges_dealloc(__dw_debug, ranges, cnt);
-	return addr;
+	return origin.addr == origin_addr;
 }
 
 /*
@@ -275,7 +230,6 @@ static int __search_die_tree(struct die_link *cur_link,
 			     int (*die_cb)(struct die_link *, void *),
 			     void *data)
 {
-	Dwarf_Die new_die;
 	struct die_link new_link;
 	int ret;
 
@@ -285,31 +239,24 @@ static int __search_die_tree(struct die_link *cur_link,
 	/* Check current die */
 	while (!(ret = die_cb(cur_link, data))) {
 		/* Check child die */
-		ret = dwarf_child(cur_link->die, &new_die, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_OK) {
+		ret = dwarf_child(&cur_link->die, &new_link.die);
+		if (ret == 0) {
 			new_link.parent = cur_link;
-			new_link.die = new_die;
 			ret = __search_die_tree(&new_link, die_cb, data);
 			if (ret)
 				break;
 		}
 
 		/* Move to next sibling */
-		ret = dwarf_siblingof(__dw_debug, cur_link->die, &new_die,
-				      &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
-		cur_link->die = new_die;
-		if (ret == DW_DLV_NO_ENTRY)
+		ret = dwarf_siblingof(&cur_link->die, &cur_link->die);
+		if (ret != 0)
 			return 0;
 	}
-	dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
 	return ret;
 }
 
 /* Search a die in its children's die tree */
-static int search_die_from_children(Dwarf_Die parent_die,
+static int search_die_from_children(Dwarf_Die *parent_die,
 				    int (*die_cb)(struct die_link *, void *),
 				    void *data)
 {
@@ -317,125 +264,58 @@ static int search_die_from_children(Dwarf_Die parent_die,
 	int ret;
 
 	new_link.parent = NULL;
-	ret = dwarf_child(parent_die, &new_link.die, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK)
+	ret = dwarf_child(parent_die, &new_link.die);
+	if (ret == 0)
 		return __search_die_tree(&new_link, die_cb, data);
 	else
 		return 0;
 }
 
-/* Find a locdesc corresponding to the address */
-static int attr_get_locdesc(Dwarf_Attribute attr, Dwarf_Locdesc *desc,
-			    Dwarf_Addr addr)
-{
-	Dwarf_Signed lcnt;
-	Dwarf_Locdesc **llbuf;
-	int ret, i;
-
-	ret = dwarf_loclist_n(attr, &llbuf, &lcnt, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = DW_DLV_NO_ENTRY;
-	for (i = 0; i < lcnt; ++i) {
-		if (llbuf[i]->ld_lopc <= addr &&
-		    llbuf[i]->ld_hipc > addr) {
-			memcpy(desc, llbuf[i], sizeof(Dwarf_Locdesc));
-			desc->ld_s =
-				malloc(sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
-			DIE_IF(desc->ld_s == NULL);
-			memcpy(desc->ld_s, llbuf[i]->ld_s,
-				sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
-			ret = DW_DLV_OK;
-			break;
-		}
-		dwarf_dealloc(__dw_debug, llbuf[i]->ld_s, DW_DLA_LOC_BLOCK);
-		dwarf_dealloc(__dw_debug, llbuf[i], DW_DLA_LOCDESC);
-	}
-	/* Releasing loop */
-	for (; i < lcnt; ++i) {
-		dwarf_dealloc(__dw_debug, llbuf[i]->ld_s, DW_DLA_LOC_BLOCK);
-		dwarf_dealloc(__dw_debug, llbuf[i], DW_DLA_LOCDESC);
-	}
-	dwarf_dealloc(__dw_debug, llbuf, DW_DLA_LIST);
-	return ret;
-}
-
-/* Get decl_file attribute value (file number) */
-static Dwarf_Unsigned die_get_decl_file(Dwarf_Die sp_die)
-{
-	Dwarf_Attribute attr;
-	Dwarf_Unsigned fno;
-	int ret;
-
-	ret = dwarf_attr(sp_die, DW_AT_decl_file, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_formudata(attr, &fno, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-	return fno;
-}
-
-/* Get decl_line attribute value (line number) */
-static Dwarf_Unsigned die_get_decl_line(Dwarf_Die sp_die)
-{
-	Dwarf_Attribute attr;
-	Dwarf_Unsigned lno;
-	int ret;
-
-	ret = dwarf_attr(sp_die, DW_AT_decl_line, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_formudata(attr, &lno, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-	return lno;
-}
 
 /*
  * Probe finder related functions
  */
 
 /* Show a location */
-static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
+static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 {
-	Dwarf_Small op;
-	Dwarf_Unsigned regn;
-	Dwarf_Signed offs;
+	unsigned int regn;
+	Dwarf_Word offs = 0;
 	int deref = 0, ret;
 	const char *regs;
 
-	op = loc->lr_atom;
-
+	/* TODO: support CFA */
 	/* If this is based on frame buffer, set the offset */
-	if (op == DW_OP_fbreg) {
+	if (op->atom == DW_OP_fbreg) {
+		if (pf->fb_ops == NULL)
+			die("The attribute of frame base is not supported.\n");
 		deref = 1;
-		offs = (Dwarf_Signed)loc->lr_number;
-		op = pf->fbloc.ld_s[0].lr_atom;
-		loc = &pf->fbloc.ld_s[0];
-	} else
-		offs = 0;
+		offs = op->number;
+		op = &pf->fb_ops[0];
+	}
 
-	if (op >= DW_OP_breg0 && op <= DW_OP_breg31) {
-		regn = op - DW_OP_breg0;
-		offs += (Dwarf_Signed)loc->lr_number;
+	if (op->atom >= DW_OP_breg0 && op->atom <= DW_OP_breg31) {
+		regn = op->atom - DW_OP_breg0;
+		offs += op->number;
 		deref = 1;
-	} else if (op >= DW_OP_reg0 && op <= DW_OP_reg31) {
-		regn = op - DW_OP_reg0;
-	} else if (op == DW_OP_bregx) {
-		regn = loc->lr_number;
-		offs += (Dwarf_Signed)loc->lr_number2;
+	} else if (op->atom >= DW_OP_reg0 && op->atom <= DW_OP_reg31) {
+		regn = op->atom - DW_OP_reg0;
+	} else if (op->atom == DW_OP_bregx) {
+		regn = op->number;
+		offs += op->number2;
 		deref = 1;
-	} else if (op == DW_OP_regx) {
-		regn = loc->lr_number;
+	} else if (op->atom == DW_OP_regx) {
+		regn = op->number;
 	} else
-		die("Dwarf_OP %d is not supported.", op);
+		die("DW_OP %d is not supported.", op->atom);
 
 	regs = get_arch_regstr(regn);
 	if (!regs)
-		die("%lld exceeds max register number.", regn);
+		die("%u exceeds max register number.", regn);
 
 	if (deref)
-		ret = snprintf(pf->buf, pf->len,
-				 " %s=%+lld(%s)", pf->var, offs, regs);
+		ret = snprintf(pf->buf, pf->len, " %s=+%ju(%s)",
+			       pf->var, (uintmax_t)offs, regs);
 	else
 		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
 	DIE_IF(ret < 0);
@@ -443,41 +323,41 @@ static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
 }
 
 /* Show a variables in kprobe event format */
-static void show_variable(Dwarf_Die vr_die, struct probe_finder *pf)
+static void show_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
 	Dwarf_Attribute attr;
-	Dwarf_Locdesc ld;
+	Dwarf_Op *expr;
+	size_t nexpr;
 	int ret;
 
-	ret = dwarf_attr(vr_die, DW_AT_location, &attr, &__dw_error);
-	if (ret != DW_DLV_OK)
+	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
 		goto error;
-	ret = attr_get_locdesc(attr, &ld, (pf->addr - pf->cu_base));
-	if (ret != DW_DLV_OK)
+	/* TODO: handle more than 1 exprs */
+	ret = dwarf_getlocation_addr(&attr, (pf->addr - pf->cu_base),
+				     &expr, &nexpr, 1);
+	if (ret <= 0 || nexpr == 0)
 		goto error;
-	/* TODO? */
-	DIE_IF(ld.ld_cents != 1);
-	show_location(&ld.ld_s[0], pf);
-	free(ld.ld_s);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+
+	show_location(expr, pf);
+	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
+	/* TODO: Support const_value */
 	die("Failed to find the location of %s at this address.\n"
 	    " Perhaps, it has been optimized out.", pf->var);
 }
 
-static int variable_callback(struct die_link *dlink, void *data)
+static int variable_search_cb(struct die_link *dlink, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
-	Dwarf_Half tag;
-	int ret;
+	int tag;
 
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
+	tag = dwarf_tag(&dlink->die);
+	DIE_IF(tag < 0);
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
-	    (die_compare_name(dlink->die, pf->var) == 0)) {
-		show_variable(dlink->die, pf);
+	    (die_compare_name(&dlink->die, pf->var) == 0)) {
+		show_variable(&dlink->die, pf);
 		return 1;
 	}
 	/* TODO: Support struct members and arrays */
@@ -485,7 +365,7 @@ static int variable_callback(struct die_link *dlink, void *data)
 }
 
 /* Find a variable in a subprogram die */
-static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
+static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	int ret;
 
@@ -499,43 +379,25 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 
 	pr_debug("Searching '%s' variable in context.\n", pf->var);
 	/* Search child die for local variables and parameters. */
-	ret = search_die_from_children(sp_die, variable_callback, pf);
+	ret = search_die_from_children(sp_die, variable_search_cb, pf);
 	if (!ret)
 		die("Failed to find '%s' in this function.", pf->var);
 }
 
-/* Get a frame base on the address */
-static void get_current_frame_base(Dwarf_Die sp_die, struct probe_finder *pf)
-{
-	Dwarf_Attribute attr;
-	int ret;
-
-	ret = dwarf_attr(sp_die, DW_AT_frame_base, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = attr_get_locdesc(attr, &pf->fbloc, (pf->addr - pf->cu_base));
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-}
-
-static void free_current_frame_base(struct probe_finder *pf)
-{
-	free(pf->fbloc.ld_s);
-	memset(&pf->fbloc, 0, sizeof(Dwarf_Locdesc));
-}
-
 /* Show a probe point to output buffer */
-static void show_probe_point(Dwarf_Die sp_die, Dwarf_Signed offs,
+static void show_probe_point(Dwarf_Die *sp_die, size_t offs,
 			     struct probe_finder *pf)
 {
 	struct probe_point *pp = pf->pp;
-	char *name;
+	const char *name;
 	char tmp[MAX_PROBE_BUFFER];
 	int ret, i, len;
+	Dwarf_Attribute fb_attr;
+	size_t nops;
 
 	/* Output name of probe point */
-	ret = dwarf_diename(sp_die, &name, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK) {
+	name = dwarf_diename(sp_die);
+	if (name) {
 		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%u", name,
 				(unsigned int)offs);
 		/* Copy the function name if possible */
@@ -543,14 +405,14 @@ static void show_probe_point(Dwarf_Die sp_die, Dwarf_Signed offs,
 			pp->function = strdup(name);
 			pp->offset = offs;
 		}
-		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
 	} else {
 		/* This function has no name. */
-		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%llx", pf->addr);
+		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%jx",
+			       (uintmax_t)pf->addr);
 		if (!pp->function) {
 			/* TODO: Use _stext */
 			pp->function = strdup("");
-			pp->offset = (int)pf->addr;
+			pp->offset = (size_t)pf->addr;
 		}
 	}
 	DIE_IF(ret < 0);
@@ -558,8 +420,15 @@ static void show_probe_point(Dwarf_Die sp_die, Dwarf_Signed offs,
 	len = ret;
 	pr_debug("Probe point found: %s\n", tmp);
 
+	/* Get the frame base attribute/ops */
+	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
+	ret = dwarf_getlocation_addr(&fb_attr, (pf->addr - pf->cu_base),
+				     &pf->fb_ops, &nops, 1);
+	if (ret <= 0 || nops == 0)
+		pf->fb_ops = NULL;
+
 	/* Find each argument */
-	get_current_frame_base(sp_die, pf);
+	/* TODO: use dwarf_cfi_addrframe */
 	for (i = 0; i < pp->nr_args; i++) {
 		pf->var = pp->args[i];
 		pf->buf = &tmp[len];
@@ -567,131 +436,106 @@ static void show_probe_point(Dwarf_Die sp_die, Dwarf_Signed offs,
 		find_variable(sp_die, pf);
 		len += strlen(pf->buf);
 	}
-	free_current_frame_base(pf);
+
+	/* *pf->fb_ops will be cached in libdw. Don't free it. */
+	pf->fb_ops = NULL;
 
 	pp->probes[pp->found] = strdup(tmp);
 	pp->found++;
 }
 
-static int probeaddr_callback(struct die_link *dlink, void *data)
-{
-	struct probe_finder *pf = (struct probe_finder *)data;
-	Dwarf_Half tag;
-	Dwarf_Signed offs;
-	int ret;
-
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	/* Check the address is in this subprogram */
-	if (tag == DW_TAG_subprogram &&
-	    die_within_subprogram(dlink->die, pf->addr, &offs)) {
-		show_probe_point(dlink->die, offs, pf);
-		return 1;
-	}
-	return 0;
-}
-
 /* Find probe point from its line number */
 static void find_probe_point_by_line(struct probe_finder *pf)
 {
-	Dwarf_Signed cnt, i, clm;
-	Dwarf_Line *lines;
-	Dwarf_Unsigned lineno = 0;
-	Dwarf_Addr addr;
-	Dwarf_Unsigned fno;
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	size_t nlines, i;
+	Dwarf_Addr addr, epc;
+	int lineno;
 	int ret;
+	Dwarf_Die *sp_die, die_mem;
 
-	ret = dwarf_srclines(pf->cu_die, &lines, &cnt, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-
-	for (i = 0; i < cnt; i++) {
-		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		if (fno != pf->fno)
-			continue;
+	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
+	DIE_IF(ret != 0);
 
-		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+		dwarf_lineno(line, &lineno);
 		if (lineno != pf->lno)
 			continue;
 
-		ret = dwarf_lineoff(lines[i], &clm, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+		/* TODO: Get fileno from line, but how? */
+		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
+			continue;
 
-		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		pr_debug("Probe line found: line[%d]:%u,%d addr:0x%llx\n",
-			 (int)i, (unsigned)lineno, (int)clm, addr);
+		ret = dwarf_lineaddr(line, &addr);
+		DIE_IF(ret != 0);
+		pr_debug("Probe line found: line[%d]:%d addr:0x%jx\n",
+			 (int)i, lineno, (uintmax_t)addr);
 		pf->addr = addr;
-		/* Search a real subprogram including this line, */
-		ret = search_die_from_children(pf->cu_die,
-					       probeaddr_callback, pf);
-		if (ret == 0)
+
+		sp_die = die_get_real_subprogram(&pf->cu_die, addr, &die_mem);
+		if (!sp_die)
 			die("Probe point is not found in subprograms.");
+		dwarf_entrypc(sp_die, &epc);
+		show_probe_point(sp_die, (size_t)(addr - epc), pf);
 		/* Continuing, because target line might be inlined. */
 	}
-	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
 }
 
+
 /* Search function from function name */
-static int probefunc_callback(struct die_link *dlink, void *data)
+static int probe_point_search_cb(struct die_link *dlink, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
 	struct probe_point *pp = pf->pp;
 	struct die_link *lk;
-	Dwarf_Signed offs;
-	Dwarf_Half tag;
+	size_t offs;
+	int tag;
 	int ret;
 
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
+	tag = dwarf_tag(&dlink->die);
 	if (tag == DW_TAG_subprogram) {
-		if (die_compare_name(dlink->die, pp->function) == 0) {
+		if (die_compare_name(&dlink->die, pp->function) == 0) {
 			if (pp->line) {	/* Function relative line */
-				pf->fno = die_get_decl_file(dlink->die);
-				pf->lno = die_get_decl_line(dlink->die)
-					 + pp->line;
+				pf->fname = dwarf_decl_file(&dlink->die);
+				dwarf_decl_line(&dlink->die, &pf->lno);
+				pf->lno += pp->line;
 				find_probe_point_by_line(pf);
 				return 1;
 			}
-			if (die_inlined_subprogram(dlink->die)) {
+			if (dwarf_func_inline(&dlink->die)) {
 				/* Inlined function, save it. */
-				ret = dwarf_die_CU_offset(dlink->die,
-							  &pf->inl_offs,
-							  &__dw_error);
-				DIE_IF(ret != DW_DLV_OK);
-				pr_debug("inline definition offset %lld\n",
-					 pf->inl_offs);
+				pf->origin = dlink->die.addr;
 				return 0;	/* Continue to search */
 			}
 			/* Get probe address */
-			pf->addr = die_get_entrypc(dlink->die);
+			pf->addr = die_get_entrypc(&dlink->die);
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
-			show_probe_point(dlink->die, pp->offset, pf);
+			show_probe_point(&dlink->die, pp->offset, pf);
 			return 1; /* Exit; no same symbol in this CU. */
 		}
-	} else if (tag == DW_TAG_inlined_subroutine && pf->inl_offs) {
-		if (die_get_abstract_origin(dlink->die) == pf->inl_offs) {
+	} else if (tag == DW_TAG_inlined_subroutine && pf->origin) {
+		if (die_compare_abstract_origin(&dlink->die, pf->origin)) {
 			/* Get probe address */
-			pf->addr = die_get_entrypc(dlink->die);
+			pf->addr = die_get_entrypc(&dlink->die);
 			pf->addr += pp->offset;
-			pr_debug("found inline addr: 0x%llx\n", pf->addr);
+			pr_debug("found inline addr: 0x%jx\n",
+				 (uintmax_t)pf->addr);
 			/* Inlined function. Get a real subprogram */
 			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
-				tag = 0;
-				dwarf_tag(lk->die, &tag, &__dw_error);
-				DIE_IF(ret == DW_DLV_ERROR);
+				tag = dwarf_tag(&lk->die);
 				if (tag == DW_TAG_subprogram &&
-				    !die_inlined_subprogram(lk->die))
+				    !dwarf_func_inline(&lk->die))
 					goto found;
 			}
 			die("Failed to find real subprogram.");
 found:
 			/* Get offset from subprogram */
-			ret = die_within_subprogram(lk->die, pf->addr, &offs);
+			ret = die_within_subprogram(&lk->die, pf->addr, &offs);
 			DIE_IF(!ret);
-			show_probe_point(lk->die, offs, pf);
+			show_probe_point(&lk->die, offs, pf);
 			/* Continue to search */
 		}
 	}
@@ -700,43 +544,43 @@ found:
 
 static void find_probe_point_by_func(struct probe_finder *pf)
 {
-	search_die_from_children(pf->cu_die, probefunc_callback, pf);
+	search_die_from_children(&pf->cu_die, probe_point_search_cb, pf);
 }
 
 /* Find a probe point */
 int find_probe_point(int fd, struct probe_point *pp)
 {
-	Dwarf_Half addr_size = 0;
-	Dwarf_Unsigned next_cuh = 0;
-	int cu_number = 0, ret;
 	struct probe_finder pf = {.pp = pp};
-
-	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK)
+	int ret;
+	Dwarf_Off off, noff;
+	size_t cuhl;
+	Dwarf_Die *diep;
+	Dwarf *dbg;
+	int fno = 0;
+
+	dbg = dwarf_begin(fd, DWARF_C_READ);
+	if (!dbg)
 		return -ENOENT;
 
 	pp->found = 0;
-	while (++cu_number) {
-		/* Search CU (Compilation Unit) */
-		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
-			&addr_size, &next_cuh, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_NO_ENTRY)
-			break;
-
+	off = 0;
+	/* Loop on CUs (Compilation Unit) */
+	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		ret = dwarf_siblingof(__dw_debug, 0, &pf.cu_die, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+		diep = dwarf_offdie(dbg, off + cuhl, &pf.cu_die);
+		if (!diep)
+			continue;
 
 		/* Check if target file is included. */
 		if (pp->file)
-			pf.fno = cu_find_fileno(pf.cu_die, pp->file);
+			fno = cu_find_fileno(&pf.cu_die, pp->file);
+		else
+			fno = 0;
 
-		if (!pp->file || pf.fno) {
+		if (!pp->file || fno) {
 			/* Save CU base address (for frame_base) */
-			ret = dwarf_lowpc(pf.cu_die, &pf.cu_base, &__dw_error);
-			DIE_IF(ret == DW_DLV_ERROR);
-			if (ret == DW_DLV_NO_ENTRY)
+			ret = dwarf_lowpc(&pf.cu_die, &pf.cu_base);
+			if (ret != 0)
 				pf.cu_base = 0;
 			if (pp->function)
 				find_probe_point_by_func(&pf);
@@ -745,10 +589,9 @@ int find_probe_point(int fd, struct probe_point *pp)
 				find_probe_point_by_line(&pf);
 			}
 		}
-		dwarf_dealloc(__dw_debug, pf.cu_die, DW_DLA_DIE);
+		off = noff;
 	}
-	ret = dwarf_finish(__dw_debug, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	dwarf_end(dbg);
 
 	return pp->found;
 }
@@ -781,69 +624,76 @@ found:
 /* Find line range from its line number */
 static void find_line_range_by_line(struct line_finder *lf)
 {
-	Dwarf_Signed cnt, i;
-	Dwarf_Line *lines;
-	Dwarf_Unsigned lineno = 0;
-	Dwarf_Unsigned fno;
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	size_t nlines, i;
 	Dwarf_Addr addr;
+	int lineno;
 	int ret;
+	const char *src;
 
 	INIT_LIST_HEAD(&lf->lr->line_list);
-	ret = dwarf_srclines(lf->cu_die, &lines, &cnt, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	ret = dwarf_getsrclines(&lf->cu_die, &lines, &nlines);
+	DIE_IF(ret != 0);
 
-	for (i = 0; i < cnt; i++) {
-		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		if (fno != lf->fno)
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+		dwarf_lineno(line, &lineno);
+		if (lf->lno_s > lineno || lf->lno_e < lineno)
 			continue;
 
-		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		if (lf->lno_s > lineno || lf->lno_e < lineno)
+		/* TODO: Get fileno from line, but how? */
+		src = dwarf_linesrc(line, NULL, NULL);
+		if (strtailcmp(src, lf->fname) != 0)
 			continue;
 
 		/* Filter line in the function address range */
 		if (lf->addr_s && lf->addr_e) {
-			ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
-			DIE_IF(ret != DW_DLV_OK);
+			ret = dwarf_lineaddr(line, &addr);
+			DIE_IF(ret != 0);
 			if (lf->addr_s > addr || lf->addr_e <= addr)
 				continue;
 		}
+		/* Copy real path */
+		if (!lf->lr->path)
+			lf->lr->path = strdup(src);
 		line_range_add_line(lf->lr, (unsigned int)lineno);
 	}
-	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
+	/* Update status */
 	if (!list_empty(&lf->lr->line_list))
 		lf->found = 1;
+	else {
+		free(lf->lr->path);
+		lf->lr->path = NULL;
+	}
 }
 
 /* Search function from function name */
-static int linefunc_callback(struct die_link *dlink, void *data)
+static int line_range_search_cb(struct die_link *dlink, void *data)
 {
 	struct line_finder *lf = (struct line_finder *)data;
 	struct line_range *lr = lf->lr;
-	Dwarf_Half tag;
+	int tag;
 	int ret;
 
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
+	tag = dwarf_tag(&dlink->die);
 	if (tag == DW_TAG_subprogram &&
-	    die_compare_name(dlink->die, lr->function) == 0) {
+	    die_compare_name(&dlink->die, lr->function) == 0) {
 		/* Get the address range of this function */
-		ret = dwarf_highpc(dlink->die, &lf->addr_e, &__dw_error);
-		if (ret == DW_DLV_OK)
-			ret = dwarf_lowpc(dlink->die, &lf->addr_s, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_NO_ENTRY) {
+		ret = dwarf_highpc(&dlink->die, &lf->addr_e);
+		if (ret == 0)
+			ret = dwarf_lowpc(&dlink->die, &lf->addr_s);
+		if (ret != 0) {
 			lf->addr_s = 0;
 			lf->addr_e = 0;
 		}
 
-		lf->fno = die_get_decl_file(dlink->die);
-		lr->offset = die_get_decl_line(dlink->die);;
+		lf->fname = dwarf_decl_file(&dlink->die);
+		dwarf_decl_line(&dlink->die, &lr->offset);
+		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);
 		lf->lno_s = lr->offset + lr->start;
 		if (!lr->end)
-			lf->lno_e = (Dwarf_Unsigned)-1;
+			lf->lno_e = INT_MAX;
 		else
 			lf->lno_e = lr->offset + lr->end;
 		lr->start = lf->lno_s;
@@ -856,55 +706,57 @@ static int linefunc_callback(struct die_link *dlink, void *data)
 
 static void find_line_range_by_func(struct line_finder *lf)
 {
-	search_die_from_children(lf->cu_die, linefunc_callback, lf);
+	search_die_from_children(&lf->cu_die, line_range_search_cb, lf);
 }
 
 int find_line_range(int fd, struct line_range *lr)
 {
-	Dwarf_Half addr_size = 0;
-	Dwarf_Unsigned next_cuh = 0;
+	struct line_finder lf = {.lr = lr, .found = 0};
 	int ret;
-	struct line_finder lf = {.lr = lr};
-
-	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK)
+	Dwarf_Off off = 0, noff;
+	size_t cuhl;
+	Dwarf_Die *diep;
+	Dwarf *dbg;
+	int fno;
+
+	dbg = dwarf_begin(fd, DWARF_C_READ);
+	if (!dbg)
 		return -ENOENT;
 
+	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found) {
-		/* Search CU (Compilation Unit) */
-		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
-			&addr_size, &next_cuh, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_NO_ENTRY)
+		ret = dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL);
+		if (ret != 0)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		ret = dwarf_siblingof(__dw_debug, 0, &lf.cu_die, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+		diep = dwarf_offdie(dbg, off + cuhl, &lf.cu_die);
+		if (!diep)
+			continue;
 
 		/* Check if target file is included. */
 		if (lr->file)
-			lf.fno = cu_find_fileno(lf.cu_die, lr->file);
+			fno = cu_find_fileno(&lf.cu_die, lr->file);
+		else
+			fno = 0;
 
-		if (!lr->file || lf.fno) {
+		if (!lr->file || fno) {
 			if (lr->function)
 				find_line_range_by_func(&lf);
 			else {
+				lf.fname = lr->file;
 				lf.lno_s = lr->start;
 				if (!lr->end)
-					lf.lno_e = (Dwarf_Unsigned)-1;
+					lf.lno_e = INT_MAX;
 				else
 					lf.lno_e = lr->end;
 				find_line_range_by_line(&lf);
 			}
-			/* Get the real file path */
-			if (lf.found)
-				cu_get_filename(lf.cu_die, lf.fno, &lr->path);
 		}
-		dwarf_dealloc(__dw_debug, lf.cu_die, DW_DLA_DIE);
+		off = noff;
 	}
-	ret = dwarf_finish(__dw_debug, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	pr_debug("path: %lx\n", (unsigned long)lr->path);
+	dwarf_end(dbg);
 	return lf.found;
 }
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index b2a2524..9dd4a88 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,6 +1,7 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
+#include <stdbool.h>
 #include "util.h"
 
 #define MAX_PATH_LEN		 256
@@ -46,53 +47,48 @@ struct line_range {
 	char			*function;		/* Function name */
 	unsigned int		start;			/* Start line number */
 	unsigned int		end;			/* End line number */
-	unsigned int		offset;			/* Start line offset */
+	int			offset;			/* Start line offset */
 	char			*path;			/* Real path name */
 	struct list_head	line_list;		/* Visible lines */
 };
 
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 extern int find_probe_point(int fd, struct probe_point *pp);
 extern int find_line_range(int fd, struct line_range *lr);
 
-/* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h: */
-#ifndef _MIPS_SZLONG
-# define _MIPS_SZLONG		0
-#endif
-
 #include <dwarf.h>
-#include <libdwarf.h>
+#include <libdw.h>
 
 struct probe_finder {
-	struct probe_point	*pp;			/* Target probe point */
+	struct probe_point	*pp;		/* Target probe point */
 
 	/* For function searching */
-	Dwarf_Addr		addr;			/* Address */
-	Dwarf_Unsigned		fno;			/* File number */
-	Dwarf_Unsigned		lno;			/* Line number */
-	Dwarf_Off		inl_offs;		/* Inline offset */
-	Dwarf_Die		cu_die;			/* Current CU */
+	Dwarf_Addr		addr;		/* Address */
+	const char		*fname;		/* File name */
+	int			lno;		/* Line number */
+	void			*origin;	/* Inline origin addr */
+	Dwarf_Die		cu_die;		/* Current CU */
 
 	/* For variable searching */
-	Dwarf_Addr		cu_base;		/* Current CU base address */
-	Dwarf_Locdesc		fbloc;			/* Location of Current Frame Base */
-	const char		*var;			/* Current variable name */
-	char			*buf;			/* Current output buffer */
-	int			len;			/* Length of output buffer */
+	Dwarf_Op		*fb_ops;	/* Frame base attribute */
+	Dwarf_Addr		cu_base;	/* Current CU base address */
+	const char		*var;		/* Current variable name */
+	char			*buf;		/* Current output buffer */
+	int			len;		/* Length of output buffer */
 };
 
 struct line_finder {
-	struct line_range	*lr;			/* Target line range */
-
-	Dwarf_Unsigned		fno;			/* File number */
-	Dwarf_Unsigned		lno_s;			/* Start line number */
-	Dwarf_Unsigned		lno_e;			/* End line number */
-	Dwarf_Addr		addr_s;			/* Start address */
-	Dwarf_Addr		addr_e;			/* End address */
-	Dwarf_Die		cu_die;			/* Current CU */
+	struct line_range	*lr;		/* Target line range */
+
+	const char		*fname;		/* File name */
+	int			lno_s;		/* Start line number */
+	int			lno_e;		/* End line number */
+	Dwarf_Addr		addr_s;		/* Start address */
+	Dwarf_Addr		addr_e;		/* End address */
+	Dwarf_Die		cu_die;		/* Current CU */
 	int			found;
 };
 
-#endif /* NO_LIBDWARF */
+#endif /* NO_DWARF_SUPPORT */
 
 #endif /*_PROBE_FINDER_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
