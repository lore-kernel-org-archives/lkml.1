Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZKVLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZKVLZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZKVLZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:25:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:51246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZKVLZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:25:36 -0500
Date: Sun, 22 Nov 2009 11:24:44 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       lizf@cn.fujitsu.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258885784-11709-1-git-send-email-penberg@cs.helsinki.fi>
References: <1258885784-11709-1-git-send-email-penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix ELF header errors during "perf kmem record"
Message-ID: <tip-e57cfcdac6badd846a1cd831de54a1359c2d1eea@git.kernel.org>
Git-Commit-ID: e57cfcdac6badd846a1cd831de54a1359c2d1eea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e57cfcdac6badd846a1cd831de54a1359c2d1eea
Gitweb:     http://git.kernel.org/tip/e57cfcdac6badd846a1cd831de54a1359c2d1eea
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Sun, 22 Nov 2009 12:29:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 12:19:07 +0100

perf symbols: Fix ELF header errors during "perf kmem record"

The write_event() function in builtin-record.c writes out all
mmap()'d DSOs including non-ELF files like GNOME resource files
and such.

Therefore, check for ELF_K_ELF in filename__read_build_id()
before attempting to read the ELF header with gelf_getehdr().

Fixes the following error messages when running "perf kmem
record":

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

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1258885784-11709-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
