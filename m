Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZJXPNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZJXPNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 11:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZJXPNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 11:13:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:34116 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZJXPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 11:13:16 -0400
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
In-Reply-To: <193b0f820910240626m1567190cqc40930542453319d@mail.gmail.com>
References: <1256330234-14079-1-git-send-email-marti@juffo.org>
	 <20091023210231.GC8356@elte.hu>
	 <1256334501-15755-1-git-send-email-marti@juffo.org>
	 <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
	 <20091024083031.GB20575@elte.hu>
	 <193b0f820910240626m1567190cqc40930542453319d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Oct 2009 18:13:12 +0300
Message-ID: <1256397192.24594.13.camel@newn>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 11:26 -0200, Lucas De Marchi wrote:
> In this case you should define PERF_ELF_C_READ_MMAP as ELF_C_READ_MMAP
> when using elftutils:
> #ifndef ELF_C_READ_MMAP
> # define PERF_ELF_C_READ_MMAP ELF_C_READ
> #else
> # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
> #endif

That's what I wanted to do at first, but it doesn't work because
ELF_C_READ_MMAP is an enum constant -- not a #define

But defining our own PERF_ELF_C_READ_MMAP is a good idea and much
cleaner than the earlier mess. Thanks

> I think the comment is wrong. I downloaded the latest version of
> libelf, i.e. 0.8.12 at http://www.mr511.de/software/english.html, and
> there's no support to ELF_C_READ_MMAP. It's a elfutils' feature only.

I guess the comment was confusing. With "libelf 0.8" I meant the whole
0.8.x series.

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
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+		BASIC_CFLAGS += -DLIBELF_NO_MMAP
+	endif
+else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -413,7 +413,7 @@
 	if (fd < 0)
 		goto out;
 
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL)
 		goto out_close;
 
@@ -533,7 +533,7 @@
 	Elf *elf;
 	int nr = 0, kernel = !strcmp("[kernel]", self->name);
 
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
 		if (v)
 			fprintf(stderr, "%s: cannot read %s ELF file.\n",
@@ -675,7 +675,7 @@
 	if (fd < 0)
 		goto out;
 
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
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
+ * libelf 0.8.x and earlier do not support elf_c_read_mmap; for newer versions
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


