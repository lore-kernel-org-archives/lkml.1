Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZGTMBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZGTMBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZGTMBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:01:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:35961 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753066AbZGTMBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:01:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Ym38gHluYr5n44O+ganAiSgbehV1PeFLDvLSITt
	1vkIQ8dlepvncB
Subject: [patch] perf_counter tools: fix vmlinux symbol generation breakage
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 14:01:38 +0200
Message-Id: <1248091298.18702.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend.. wrong lkml address)


perf_counter tools: fix vmlinux symbol generation breakage.

vmlinux meets the criteria for symbol adjustment, which breaks vmlinux generated symbols.
Fix this by exempting vmlinux.  This is a bit fragile in that someone could change the
kernel dso's name, but currently that name is also hardwired.



Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/util/symbol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/tools/perf/util/symbol.c
===================================================================
--- linux-2.6.orig/tools/perf/util/symbol.c
+++ linux-2.6/tools/perf/util/symbol.c
@@ -519,7 +519,7 @@ static int dso__load_sym(struct dso *sel
 	GElf_Sym sym;
 	Elf_Scn *sec, *sec_strndx;
 	Elf *elf;
-	int nr = 0;
+	int nr = 0, kernel = !strcmp("[kernel]", self->name);
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
@@ -565,10 +565,13 @@ static int dso__load_sym(struct dso *sel
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+	if (!kernel)
+		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
+	else self->adjust_symbols = 0;
+
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		u64 obj_start;


