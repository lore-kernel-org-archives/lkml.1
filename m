Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZHBTpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZHBTpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZHBTpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:45:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZHBTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:45:12 -0400
Date: Sun, 2 Aug 2009 15:44:54 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802194454.GC28572@bombadil.infradead.org>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802184148.GB17241@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 08:41:48PM +0200, Ingo Molnar wrote:
> Could we somehow define a weak symbol for those library functions 
> ourselves and thus just fall back to that (which does nothing) 
> instead of failing the link?
> 

Well, you could just dlopen the object, but that's kind of gross...

Why not abuse the perf Makefile, which already has this kind of
portability gunk in it?

$ make NO_BFD_DEMANGLE=1
succeeds with no libbfd.

$ make
succeeds when libbfd is around.

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a5e9b87..67ab097 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,6 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd
 
 #
 # Platform specific tweaks
@@ -541,6 +540,11 @@ endif
 ifdef NO_EXTERNAL_GREP
 	BASIC_CFLAGS += -DNO_EXTERNAL_GREP
 endif
+ifdef NO_BFD_DEMANGLE
+	BASIC_CFLAGS += -DNO_BFD_DEMANGLE
+else
+	EXTLIBS += -lbfd
+endif
 
 ifeq ($(PERL_PATH),)
 NO_PERL=NoThanks
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2810605..736b8db 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -6,10 +6,20 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
+
+#ifndef NO_BFD_DEMANGLE
 #include <bfd.h>
+#endif /* NO_BFD_DEMANGLE */
 
 const char *sym_hist_filter;
 
+#ifdef NO_BFD_DEMANGLE
+static inline char *bfd_demangle(void __used *v, const char __used *c,
+				int __used i) {
+	return NULL;
+}
+#endif
+
 #ifndef DMGL_PARAMS
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
