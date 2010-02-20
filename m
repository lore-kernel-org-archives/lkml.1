Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0BTVx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:53:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:34324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0BTVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:53:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf symbols: Fix up map end too on modular kernels with no modules installed
Date: Sat, 20 Feb 2010 19:53:13 -0200
Message-Id: <1266702793-29434-1-git-send-email-acme@infradead.org>
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

In 2161db9 we stopped failing when not finding modules when asked too,
but then the kernel maps (just one, for vmlinux) wasn't having its ->end
field correctly set up, so symbols were not being found for the vmlinux
map because its range was 0-0.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    6 ++++++
 tools/perf/util/symbol.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5a99e61..705ec63 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -379,6 +379,12 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 
 			session->vmlinux_maps[MAP__FUNCTION]->start = self->mmap.start;
 			session->vmlinux_maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
+			/*
+			 * Be a bit paranoid here, some perf.data file came with
+			 * a zero sized synthesized MMAP event for the kernel.
+			 */
+			if (session->vmlinux_maps[MAP__FUNCTION]->end == 0)
+				session->vmlinux_maps[MAP__FUNCTION]->end = ~0UL;
 
 			perf_session__set_kallsyms_ref_reloc_sym(session, symbol_name,
 								 self->mmap.pgoff);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 6882e9f..ee9c37e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1937,7 +1937,7 @@ int map_groups__create_kernel_maps(struct map_groups *self,
 		return -1;
 
 	if (symbol_conf.use_modules && map_groups__create_modules(self) < 0)
-		return 0;
+		pr_debug("Problems creating module maps, continuing anyway...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-- 
1.6.2.5

