Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZKUQbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZKUQbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZKUQba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:31:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbZKUQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:31:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf symbols: fixup kernel_maps__fixup_end end map
Date: Sat, 21 Nov 2009 14:31:24 -0200
Message-Id: <1258821086-11521-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We better call this routine after both the kernel and modules are
loaded, because as it was if there weren't modules it would be called,
resulting in kernel_map->end remaining at zero, so no map would be found
and consequently the kernel symtab wouldn't get loaded, i.e. no kernel
symbols would be resolved.

Also this fixes another case, that is when we _have_ modules, but the
last map would have its ->end address not set before we loaded its
symbols, which would never happen because ->end was not set.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 48f87f0..e161a51 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -71,6 +71,12 @@ static void kernel_maps__fixup_end(void)
 		curr = rb_entry(nd, struct map, rb_node);
 		prev->end = curr->start - 1;
 	}
+
+	/*
+	 * We still haven't the actual symbols, so guess the
+	 * last map final address.
+	 */
+	curr->end = ~0UL;
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
@@ -1319,12 +1325,6 @@ static int kernel_maps__create_module_maps(void)
 	free(line);
 	fclose(file);
 
-	/*
-	 * Now that we have all sorted out, just set the ->end of all
-	 * maps:
-	 */
-	kernel_maps__fixup_end();
-
 	return dsos__set_modules_path();
 
 out_delete_line:
@@ -1493,7 +1493,10 @@ int kernel_maps__init(bool use_modules)
 	if (use_modules && kernel_maps__create_module_maps() < 0)
 		pr_warning("Failed to load list of modules in use, "
 			   "continuing...\n");
-
+	/*
+	 * Now that we have all the maps created, just set the ->end of them:
+	 */
+	kernel_maps__fixup_end();
 	return 0;
 }
 
-- 
1.6.2.5

