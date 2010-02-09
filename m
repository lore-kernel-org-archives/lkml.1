Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0BIDpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 22:45:39 -0500
Received: from ozlabs.org ([203.10.76.45]:36568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0BIDpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 22:45:38 -0500
Date: Tue, 9 Feb 2010 14:43:05 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix hypervisor sample reporting
Message-ID: <20100209034304.GA3702@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpumode bits are defined as such:

#define PERF_RECORD_MISC_KERNEL                 (1 << 0)
#define PERF_RECORD_MISC_USER                   (2 << 0)
#define PERF_RECORD_MISC_HYPERVISOR             (3 << 0)

We need to compare against the complete value of cpumode, otherwise hypervisor
samples get incorrectly attributed as userspace.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index c3831f6..5a99e61 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -436,10 +436,10 @@ void thread__find_addr_map(struct thread *self,
 	al->thread = self;
 	al->addr = addr;
 
-	if (cpumode & PERF_RECORD_MISC_KERNEL) {
+	if (cpumode == PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
 		mg = &session->kmaps;
-	} else if (cpumode & PERF_RECORD_MISC_USER)
+	} else if (cpumode == PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
 		al->level = 'H';
