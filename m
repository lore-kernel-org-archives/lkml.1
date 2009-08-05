Return-Path: <linux-kernel-owner+w=401wt.eu-S934546AbZHEOaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546AbZHEOaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934493AbZHEOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:30:05 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:61194 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449AbZHEOaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:30:03 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/urgent] perf: Auto-detect libbfd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, kyle@mcmartin.ca,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-2cdbc46d7b2cb0acb68c3ecad93b000552121fa6@git.kernel.org>
References: <20090801082048.GX12579@kernel.dk>
	 <tip-2cdbc46d7b2cb0acb68c3ecad93b000552121fa6@git.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 16:29:46 +0200
Message-Id: <1249482586.32113.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 12:16 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  2cdbc46d7b2cb0acb68c3ecad93b000552121fa6
> Gitweb:     http://git.kernel.org/tip/2cdbc46d7b2cb0acb68c3ecad93b000552121fa6
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Wed, 5 Aug 2009 14:05:16 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 5 Aug 2009 14:12:08 +0200
> 
> perf: Auto-detect libbfd
> 
> Since the C++ demangling isn't needed for everybody and
> bfd/iberty aren't widely/easily available on all machines, make
> it optional.
> 
> It also allows you to forcefully disable demangling by using
> NO_DEMANGLE=1 and otherwise tries to detect libbfd/libiberty
> combinations that result in a compiling demangler.


The below simpifies the C proglet and extends it to cover auto-detection
of libelf as well, it also generates an error in case of libelf being
MIA and an warning for libbfd.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/Makefile |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ff905ac..e9db128 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -158,8 +158,10 @@ uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
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
@@ -373,19 +375,24 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (int)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(error No libelf.h/libelf found, please install libelf-dev[el]);
+endif
+
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
 
-	has_bfd := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd > /dev/null 2>&1 && echo y")
+	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
 
-	has_bfd_iberty := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd -liberty > /dev/null 2>&1 && echo y")
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


