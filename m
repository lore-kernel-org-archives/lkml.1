Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZHES7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZHES7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZHES7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:59:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZHES7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:59:05 -0400
Subject: Re: [tip:perfcounters/urgent] perf: Auto-detect libbfd
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, acme@redhat.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, kyle@mcmartin.ca, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1249482586.32113.7.camel@twins>
References: <20090801082048.GX12579@kernel.dk>
	 <tip-2cdbc46d7b2cb0acb68c3ecad93b000552121fa6@git.kernel.org>
	 <1249482586.32113.7.camel@twins>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 20:58:49 +0200
Message-Id: <1249498729.5890.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int
> main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return
> (int)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE
> -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 &&
> echo y"), y)

s/(int)/(long)/

---
Index: linux-2.6/tools/perf/Makefile
===================================================================
--- linux-2.6.orig/tools/perf/Makefile
+++ linux-2.6/tools/perf/Makefile
@@ -158,8 +158,10 @@ uname_P := $(shell sh -c 'uname -p 2>/de
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # If we're on a 64-bit kernel, use -m64
-ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-  M64 := -m64
+ifndef NO_64BIT
+	ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+	  M64 := -m64
+	endif
 endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
@@ -373,18 +375,24 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(error No libelf.h/libelf found, please install libelf-dev[el]);
+endif
+
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-	has_bfd := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd > /dev/null 2>&1 && echo y")
 
-	has_bfd_iberty := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd -liberty > /dev/null 2>&1 && echo y")
+	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
+
+	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
 
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else ifeq ($(has_bfd_iberty),y)
 		EXTLIBS += -lbfd -liberty
 	else
+		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
 		BASIC_CFLAGS += -DNO_DEMANGLE
 	endif
 endif


