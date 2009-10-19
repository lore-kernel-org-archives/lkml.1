Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZJSCV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZJSCV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 22:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZJSCV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 22:21:27 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:28055 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZJSCV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 22:21:26 -0400
Message-ID: <4ADBCCE8.3060300@oracle.com>
Date: Sun, 18 Oct 2009 19:20:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de
Subject: [PATCH] perf tools: better error messages on missing packages
References: <tip-55621ccf2b7a8afe39df8c80f55b28424fd07d13@git.kernel.org> <20091013140915.96cfe060.randy.dunlap@oracle.com> <20091014062052.GD784@elte.hu> <20091014074404.98577824.randy.dunlap@oracle.com> <20091014155848.GB15193@ghostprotocols.net>
In-Reply-To: <20091014155848.GB15193@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ADBCD02.0016:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Check for libelf headers and glibc headers separately so that
the error message correctly identifies which package
installation is missing/needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tools/perf/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- lnx-2632-rc5.orig/tools/perf/Makefile
+++ lnx-2632-rc5/tools/perf/Makefile
@@ -422,8 +422,12 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+endif
+
 ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
+	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 endif
 
 ifdef NO_DEMANGLE
