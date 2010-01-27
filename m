Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316Ab0A0XGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0A0XGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265Ab0A0XGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:06:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:45488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab0A0XGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:06:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/9] perf top: Exit if specified --vmlinux can't be used
Date: Wed, 27 Jan 2010 21:05:49 -0200
Message-Id: <1264633557-17597-1-git-send-email-acme@infradead.org>
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

As we do lazy loading of symtabs we only will know if the specified
vmlinux file is invalid when we actually have a hit in kernel space and
then try to load it. So if we get kernel hits and there are _no_ symbols
in the DSO backing the kernel map, bail out.

Reported-by: Mike Galbraith <efault@gmx.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2227b84..78f9c45 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -951,9 +951,31 @@ static void event__process_sample(const event_t *self,
 	}
 
 	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
-	    al.sym == NULL || al.filtered)
+	    al.filtered)
 		return;
 
+	if (al.sym == NULL) {
+		/*
+		 * As we do lazy loading of symtabs we only will know if the
+		 * specified vmlinux file is invalid when we actually have a
+		 * hit in kernel space and then try to load it. So if we get
+		 * here and there are _no_ symbols in the DSO backing the
+		 * kernel map, bail out.
+		 *
+		 * We may never get here, for instance, if we use -K/
+		 * --hide-kernel-symbols, even if the user specifies an
+		 * invalid --vmlinux ;-)
+		 */
+		if (al.map == session->vmlinux_maps[MAP__FUNCTION] &&
+		    RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION])) {
+			pr_err("The %s file can't be used\n",
+			       symbol_conf.vmlinux_name);
+			exit(1);
+		}
+
+		return;
+	}
+
 	syme = symbol__priv(al.sym);
 	if (!syme->skip) {
 		syme->count[counter]++;
-- 
1.6.2.5

