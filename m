Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZKTWvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZKTWvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZKTWvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:51:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:39214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZKTWvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:51:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf symbols: Change the kernel DSO name if it comes from kallsyms
Date: Fri, 20 Nov 2009 20:51:29 -0200
Message-Id: <1258757489-5978-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258757489-5978-5-git-send-email-acme@infradead.org>
References: <1258757489-5978-1-git-send-email-acme@infradead.org>
 <1258757489-5978-2-git-send-email-acme@infradead.org>
 <1258757489-5978-3-git-send-email-acme@infradead.org>
 <1258757489-5978-4-git-send-email-acme@infradead.org>
 <1258757489-5978-5-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that the user have a clearer indication about the source of the
symbols, as we only state buildid mismatches in verbose mode, because
'perf top' would overwrite such warning anyway.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9cf6dbc..48f87f0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -108,6 +108,8 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 
 static void dso__set_long_name(struct dso *self, char *name)
 {
+	if (name == NULL)
+		return;
 	self->long_name = name;
 	self->long_name_len = strlen(name);
 }
@@ -1377,8 +1379,11 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 {
 	int err = dso__load_vmlinux(self, map, self->name, filter);
 
-	if (err <= 0)
+	if (err <= 0) {
 		err = kernel_maps__load_kallsyms(filter);
+		if (err > 0)
+                        dso__set_long_name(self, strdup("[kernel.kallsyms]"));
+	}
 
 	if (err > 0) {
 		map__fixup_start(map);
-- 
1.6.2.5

