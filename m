Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbZHILMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbZHILMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZHILMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:12:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZHILME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:12:04 -0400
Date: Sun, 9 Aug 2009 11:11:21 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Fix libbfd detection for systems with libz dependency
Message-ID: <tip-183f3b0887083d36c8a25cd5e3518906415d1889@git.kernel.org>
Git-Commit-ID: 183f3b0887083d36c8a25cd5e3518906415d1889
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:11:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  183f3b0887083d36c8a25cd5e3518906415d1889
Gitweb:     http://git.kernel.org/tip/183f3b0887083d36c8a25cd5e3518906415d1889
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sat, 8 Aug 2009 14:14:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:54:47 +0200

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
