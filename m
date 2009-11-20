Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZKTWvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZKTWvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZKTWve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:51:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZKTWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:51:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf symbols: Check vmlinux buildid
Date: Fri, 20 Nov 2009 20:51:28 -0200
Message-Id: <1258757489-5978-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258757489-5978-4-git-send-email-acme@infradead.org>
References: <1258757489-5978-1-git-send-email-acme@infradead.org>
 <1258757489-5978-2-git-send-email-acme@infradead.org>
 <1258757489-5978-3-git-send-email-acme@infradead.org>
 <1258757489-5978-4-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

E.g.:

[root@doppio linux-2.6-tip]# perf top -v --vmlinux ../build/tip/vmlinux > /dev/null
build_id in vmlinux is e96699725a47413a50c231864a8e7a8ced40a31b while
expected is 18e7cc53db62a7d35e9d6f6c9ddc23017d38ee9a, ignoring it

I.e. perf top was told to use a vmlinux file that is not the one
currently running on the machine, it ignores it and falls back to using
/proc/kallsyms.

This solves many, at first, mysterious results when people have a stale
vmlinux file while keeping the default of trying to use the vmlinux file
in the current directory in things like 'perf annotate' where the DWARF
info is required and thus we can't use just /proc/kallsyms.

Modules buildids are already being checked as of the previous changeset
in this series, because we are using the default dso__load routine, that
will look at a series of places looking for the best file with a
matching buildid, starting in the -debuginfo directories.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index cb086cb..9cf6dbc 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1334,13 +1334,37 @@ out_failure:
 static int dso__load_vmlinux(struct dso *self, struct map *map,
 			     const char *vmlinux, symbol_filter_t filter)
 {
-	int err, fd = open(vmlinux, O_RDONLY);
+	int err = -1, fd;
 
-	self->loaded = 1;
+	if (self->has_build_id) {
+		u8 build_id[BUILD_ID_SIZE];
+
+		if (filename__read_build_id(vmlinux, build_id,
+					    sizeof(build_id)) < 0) {
+			pr_debug("No build_id in %s, ignoring it\n", vmlinux);
+			return -1;
+		}
+		if (!dso__build_id_equal(self, build_id)) {
+			char expected_build_id[BUILD_ID_SIZE * 2 + 1],
+			     vmlinux_build_id[BUILD_ID_SIZE * 2 + 1];
+
+			build_id__sprintf(self->build_id,
+					  sizeof(self->build_id),
+					  expected_build_id);
+			build_id__sprintf(build_id, sizeof(build_id),
+					  vmlinux_build_id);
+			pr_debug("build_id in %s is %s while expected is %s, "
+				 "ignoring it\n", vmlinux, vmlinux_build_id,
+				 expected_build_id);
+			return -1;
+		}
+	}
 
+	fd = open(vmlinux, O_RDONLY);
 	if (fd < 0)
 		return -1;
 
+	self->loaded = 1;
 	err = dso__load_sym(self, map, self->long_name, fd, filter, 1, 0);
 
 	close(fd);
-- 
1.6.2.5

