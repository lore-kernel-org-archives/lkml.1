Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZKXETr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZKXETr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 23:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZKXETq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 23:19:46 -0500
Received: from ozlabs.org ([203.10.76.45]:49512 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbZKXETq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 23:19:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19211.24287.453183.78836@cargo.ozlabs.ibm.com>
Date: Tue, 24 Nov 2009 15:19:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tools: Fix compilation on powerpc
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, perf fails to compile on powerpc with this error:

    CC util/header.o
In file included from util/../perf.h:17,
                 from util/header.c:9:
util/../../../arch/powerpc/include/asm/unistd.h:360:27: error: linux/linkage.h: No such file or directory
make: *** [util/header.o] Error 1

The reason is that we still have a #define __KERNEL__ in effect at the
point where <asm/unistd.h> gets included, which means we get extra
stuff that we don't need or want.

This fixes the problem by undefining __KERNEL__ once we have included
the file for which we need __KERNEL__ defined.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/include/linux/bitops.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index ace57c3..8d63116 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -7,6 +7,8 @@
 #define CONFIG_GENERIC_FIND_FIRST_BIT
 #include "../../../../include/linux/bitops.h"
 
+#undef __KERNEL__
+
 static inline void set_bit(int nr, unsigned long *addr)
 {
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
