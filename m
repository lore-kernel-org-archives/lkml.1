Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZJXPTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZJXPTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 11:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZJXPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 11:19:25 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:39997 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZJXPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 11:19:24 -0400
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
 autodetect
From: Marti Raudsepp <marti@juffo.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1256397192.24594.13.camel@newn>
References: <1256330234-14079-1-git-send-email-marti@juffo.org>
	 <20091023210231.GC8356@elte.hu>
	 <1256334501-15755-1-git-send-email-marti@juffo.org>
	 <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
	 <20091024083031.GB20575@elte.hu>
	 <193b0f820910240626m1567190cqc40930542453319d@mail.gmail.com>
	 <1256397192.24594.13.camel@newn>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Oct 2009 18:19:24 +0300
Message-ID: <1256397564.24594.16.camel@newn>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending small fix; somehow I typed "elf_c_read_mmap" in lower case in
the comment.

Marti

--

perf tools: add compatibility with libelf 0.8.x and autodetect

The Makefile now automatically defines LIBELF_NO_MMAP when libelf 0.8.x is
detected. libelf 0.8.x is still maintained and some distributions such as
Arch Linux use it instead of elfutils.

Can't use #ifdef ELF_C_READ_MMAP because it's an enum constant not a
define.

Signed-off-by: Marti Raudsepp <marti@juffo.org>
---
 Makefile      |    6 +++++-
 util/symbol.c |    6 +++---
 util/symbol.h |   10 ++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -422,7 +422,11 @@
        PTHREAD_LIBS =
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+       ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+               BASIC_CFLAGS += -DLIBELF_NO_MMAP
+       endif
+else
        msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -413,7 +413,7 @@
        if (fd < 0)
                goto out;
 
-       elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+       elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
        if (elf == NULL)
                goto out_close;
 
@@ -533,7 +533,7 @@
        Elf *elf;
        int nr = 0, kernel = !strcmp("[kernel]", self->name);
 
-       elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+       elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
        if (elf == NULL) {
                if (v)
                        fprintf(stderr, "%s: cannot read %s ELF file.\n",
@@ -675,7 +675,7 @@
        if (fd < 0)
                goto out;
 
-       elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+       elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
        if (elf == NULL) {
                if (v)
                        fprintf(stderr, "%s: cannot read %s ELF file.\n",
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -27,6 +27,16 @@
 #endif
 #endif
 
+/*
+ * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP; for newer versions
+ * we can use mmap to reduce memory usage
+ */
+#ifdef LIBELF_NO_MMAP
+# define PERF_ELF_C_READ_MMAP ELF_C_READ
+#else
+# define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
+#endif
+
 #ifndef DMGL_PARAMS
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */


