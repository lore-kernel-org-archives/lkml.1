Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbZHHOfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbZHHOfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 10:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZHHOfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 10:35:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:35910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZHHOfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 10:35:31 -0400
Date: Sat, 8 Aug 2009 14:33:39 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249733655.6929.5.camel@marge.simson.net>
References: <1249733655.6929.5.camel@marge.simson.net>
Subject: [tip:perfcounters/urgent] perf_counter tools: Fix libbfd detection for systems with libz dependency
Message-ID: <tip-115c46db58736d6a517a1db8158443665d6f30c2@git.kernel.org>
Git-Commit-ID: 115c46db58736d6a517a1db8158443665d6f30c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 14:33:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  115c46db58736d6a517a1db8158443665d6f30c2
Gitweb:     http://git.kernel.org/tip/115c46db58736d6a517a1db8158443665d6f30c2
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sat, 8 Aug 2009 14:14:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 14:35:05 +0200

perf_counter tools: Fix libbfd detection for systems with libz dependency

Due to a libz dependency in some distro's binutils package,
C++ demangle support isn't compiled in despite the necessary
libraries being available.

Fix this by adding a -lz link test to the dependency detection
rules.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1249733655.6929.5.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1916e44..60411e9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,10 +387,14 @@ else
 
 	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
 
+	has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else ifeq ($(has_bfd_iberty),y)
 		EXTLIBS += -lbfd -liberty
+	else ifeq ($(has_bfd_iberty_z),y)
+		EXTLIBS += -lbfd -liberty -lz
 	else
 		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
 		BASIC_CFLAGS += -DNO_DEMANGLE
