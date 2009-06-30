Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZF3XSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZF3XSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbZF3XRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:21 -0400
Received: from ozlabs.org ([203.10.76.45]:39625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462AbZF3XRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:18 -0400
Message-Id: <20090630230140.904782938@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:46 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/8] perf top: Move skip symbols to an array
Content-Disposition: inline; filename=pcl_skip_symbols.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the list of symbols we skip into an array, making it easier to add new
ones.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/builtin-top.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-top.c	2009-07-01 08:21:24.000000000 +1000
+++ linux-2.6-tip/tools/perf/builtin-top.c	2009-07-01 08:21:31.000000000 +1000
@@ -286,11 +286,22 @@
 	return NULL;
 }
 
+/* Tag samples to be skipped. */
+char *skip_symbols[] = {
+	"default_idle",
+	"cpu_idle",
+	"enter_idle",
+	"exit_idle",
+	"mwait_idle",
+	NULL
+};
+
 static int symbol_filter(struct dso *self, struct symbol *sym)
 {
 	static int filter_match;
 	struct sym_entry *syme;
 	const char *name = sym->name;
+	int i;
 
 	if (!strcmp(name, "_text") ||
 	    !strcmp(name, "_etext") ||
@@ -302,13 +313,12 @@
 		return 1;
 
 	syme = dso__sym_priv(self, sym);
-	/* Tag samples to be skipped. */
-	if (!strcmp("default_idle", name) ||
-	    !strcmp("cpu_idle", name) ||
-	    !strcmp("enter_idle", name) ||
-	    !strcmp("exit_idle", name) ||
-	    !strcmp("mwait_idle", name))
-		syme->skip = 1;
+	for (i = 0; skip_symbols[i]; i++) {
+		if (!strcmp(skip_symbols[i], name)) {
+			syme->skip = 1;
+			break;
+		}
+	}
 
 	if (filter_match == 1) {
 		filter_end = sym->start;

-- 

