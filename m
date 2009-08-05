Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbZHEMLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbZHEMLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbZHEMLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:11:14 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:51026 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbZHEMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:11:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] basic perf support for sparc
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
In-Reply-To: <20090802194454.GC28572@bombadil.infradead.org>
References: <20090729112509.GN4148@kernel.dk>
	 <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten>
	 <20090801082048.GX12579@kernel.dk>
	 <20090801182216.GA25334@ghostprotocols.net>
	 <20090802184148.GB17241@elte.hu>
	 <20090802194454.GC28572@bombadil.infradead.org>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 14:10:56 +0200
Message-Id: <1249474256.7924.253.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 15:44 -0400, Kyle McMartin wrote:

> Why not abuse the perf Makefile, which already has this kind of
> portability gunk in it?

Does this work for people?

---
Subject: perf: autodetect libbfd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Aug 05 14:05:16 CEST 2009

Since the C++ demangling isn't needed for everybody and bfd/iberty
aren't widely/easily available on all machines, make it optional.

It allows you to forcefully disable demangling by using NO_DEMANGLE=1
and otherwise tries to detect libbfd/libiberty combinations that
result in a compiling demangler.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/Makefile      |   17 ++++++++++++++++-
 tools/perf/util/symbol.c |    9 +++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6/tools/perf/Makefile
===================================================================
--- linux-2.6.orig/tools/perf/Makefile
+++ linux-2.6/tools/perf/Makefile
@@ -345,7 +345,6 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd -liberty
 
 #
 # Platform specific tweaks
@@ -374,6 +373,22 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifdef NO_DEMANGLE
+	BASIC_CFLAGS += -DNO_DEMANGLE
+else
+	has_bfd := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd > /dev/null 2>&1 && echo y")
+
+	has_bfd_iberty := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd -liberty > /dev/null 2>&1 && echo y")
+
+	ifeq ($(has_bfd),y)
+		EXTLIBS += -lbfd
+	else ifeq ($(has_bfd_iberty),y)
+		EXTLIBS += -lbfd -liberty
+	else
+		BASIC_CFLAGS += -DNO_DEMANGLE
+	endif
+endif
+
 ifndef CC_LD_DYNPATH
 	ifdef NO_R_TO_GCC_LINKER
 		# Some gcc does not accept and pass -R to the linker to specify
Index: linux-2.6/tools/perf/util/symbol.c
===================================================================
--- linux-2.6.orig/tools/perf/util/symbol.c
+++ linux-2.6/tools/perf/util/symbol.c
@@ -6,7 +6,16 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
+
+#ifndef NO_DEMANGLE
 #include <bfd.h>
+#else
+static inline
+char *bfd_demangle(void __used *v, const char __used *c, int __used i)
+{
+	return NULL;
+}
+#endif
 
 const char *sym_hist_filter;
 


