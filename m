Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbZLPRSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbZLPRSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762329AbZLPRSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:18:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:37840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762255AbZLPRSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:18:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf diff: Use fabs instead of, ugh, casting to u64
Date: Wed, 16 Dec 2009 15:17:58 -0200
Message-Id: <1260983878-3430-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To check which deltas should be printed. Things looks more believable now, I
guess:

$ perf report -i perf.data.old --sort dso,symbol | head -13
     9.02%  libc-2.10.1.so               [.] _IO_vfprintf_internal
     4.88%  find                         [.] 0x00000000014af0
     2.91%  [kernel]                     [k] __kmalloc
     2.85%  [kernel]                     [k] ext4_htree_store_dirent
     2.50%  libc-2.10.1.so               [.] __GI_memmove
     2.44%  [kernel]                     [k] half_md4_transform
     2.43%  [kernel]                     [k] _spin_lock
     2.33%  [kernel]                     [k] system_call
$ perf report -i perf.data --sort dso,symbol | head -13
     8.55%  libc-2.10.1.so               [.] _IO_vfprintf_internal
     3.11%  [kernel]                     [k] __kmalloc
     3.07%  [kernel]                     [k] ext4_htree_store_dirent
     2.66%  find                         [.] 0x00000000016bcf
     2.61%  [kernel]                     [k] _atomic_dec_and_lock
     2.46%  [kernel]                     [k] half_md4_transform
     2.41%  libc-2.10.1.so               [.] __GI_memmove
     2.30%  find                         [.] 0x00000000009219
$ perf diff | head -13
     9.02%     -0.47%  libc-2.10.1.so               [.] _IO_vfprintf_internal
     2.91%     +0.20%  [kernel]                     [k] __kmalloc
     2.85%     +0.23%  [kernel]                     [k] ext4_htree_store_dirent
     1.99%     +0.62%  [kernel]                     [k] _atomic_dec_and_lock
     2.44%     +0.02%  [kernel]                     [k] half_md4_transform
     2.50%     -0.09%  libc-2.10.1.so               [.] __GI_memmove
     1.88%     +0.01%  [kernel]                     [k] __d_lookup
     2.43%     -0.75%  [kernel]                     [k] _spin_lock
     0.97%     +0.62%  [kernel]                     [k] path_get
     1.99%     -0.42%  libc-2.10.1.so               [.] _int_malloc
$

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1bf8658..e8daf5c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,6 +1,7 @@
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
+#include <math.h>
 
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -498,9 +499,9 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 		if (session->events_stats.total > 0)
 			new_percent = (self->count * 100.0) / session->events_stats.total;
 
-		diff = old_percent - new_percent;
+		diff = new_percent - old_percent;
 
-		if ((u64)diff != 0)
+		if (fabs(diff) >= 0.01)
 			snprintf(bf, sizeof(bf), "%+4.2F%%", diff);
 		else
 			snprintf(bf, sizeof(bf), " ");
-- 
1.6.2.5

