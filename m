Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZKVK3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZKVK3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZKVK3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:29:39 -0500
Received: from smtp6.welho.com ([213.243.153.40]:35626 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZKVK3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:29:39 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf kmem: Fix ELF header errors during "perf kmem record"
Date: Sun, 22 Nov 2009 12:29:44 +0200
Message-Id: <1258885784-11709-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write_event() function in builtin-record.c writes out all mmap()'d DSOs
including non-ELF files like GNOME resource files and such. Therefore, check
for ELF_K_ELF in filename__read_build_id() before attempting to read the ELF
header with gelf_getehdr().

Fixes the following error messages when running "perf kmem record":

  penberg@penberg-laptop:~/src/linux/tools/perf$ perf kmem record
  ^C[ perf record: Woken up 2 times to write data ]
  [ perf record: Captured and wrote 0.753 MB perf.data (~32885 samples) ]
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.
  filename__read_build_id: cannot get elf header.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tools/perf/util/symbol.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 86ec6c7..f56158f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -921,6 +921,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 	GElf_Shdr shdr;
 	Elf_Data *data;
 	Elf_Scn *sec;
+	Elf_Kind ek;
 	void *ptr;
 	Elf *elf;
 
@@ -937,6 +938,10 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 		goto out_close;
 	}
 
+	ek = elf_kind(elf);
+	if (ek != ELF_K_ELF)
+		goto out_elf_end;
+
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
 		pr_err("%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
-- 
1.6.0.4

