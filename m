Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZKRWVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZKRWVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:21:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbZKRWVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:21:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbZKRWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:20:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf symbols: Fix comparision of build_ids
Date: Wed, 18 Nov 2009 20:20:50 -0200
Message-Id: <1258582853-8579-1-git-send-email-acme@infradead.org>
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

When we read the build_id from the DSO name to then index into
/usr/lib/debug/.buildid/DSO_BUILD_ID[0:2]/DSO_BUILD_ID[2:], we were
jumping directly to the comparision with the buildid we already have in
dso->build_id (that came from the perf.data build_id section, collected
at perf record time) unconditionally, even if we didn't had recorded it,
and furthermore, comparing a formatted buildid with a rawbuildid, yikes.

Fix it by deleting the dso__read_build_id function, that was really
misdesigned anyway, and do the necessary checks and correct comparision
of raw buildids.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   52 ++++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5cc96c8..594f36a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -962,25 +962,6 @@ out:
 	return err;
 }
 
-static char *dso__read_build_id(struct dso *self)
-{
-	int len;
-	char *build_id = NULL;
-	unsigned char rawbf[BUILD_ID_SIZE];
-
-	len = filename__read_build_id(self->long_name, rawbf, sizeof(rawbf));
-	if (len < 0)
-		goto out;
-
-	build_id = malloc(len * 2 + 1);
-	if (build_id == NULL)
-		goto out;
-
-	build_id__sprintf(rawbf, len, build_id);
-out:
-	return build_id;
-}
-
 char dso__symtab_origin(const struct dso *self)
 {
 	static const char origin[] = {
@@ -1001,7 +982,8 @@ char dso__symtab_origin(const struct dso *self)
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
-	char *name = malloc(size), *build_id = NULL;
+	char *name = malloc(size);
+	u8 build_id[BUILD_ID_SIZE];
 	int ret = -1;
 	int fd;
 
@@ -1023,8 +1005,6 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 
 more:
 	do {
-		int berr = 0;
-
 		self->origin++;
 		switch (self->origin) {
 		case DSO__ORIG_FEDORA:
@@ -1036,12 +1016,18 @@ more:
 				 self->long_name);
 			break;
 		case DSO__ORIG_BUILDID:
-			build_id = dso__read_build_id(self);
-			if (build_id != NULL) {
+			if (filename__read_build_id(self->long_name, build_id,
+						    sizeof(build_id))) {
+				char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+
+				build_id__sprintf(build_id, sizeof(build_id),
+						  build_id_hex);
 				snprintf(name, size,
 					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
-					build_id, build_id + 2);
-				goto compare_build_id;
+					build_id_hex, build_id_hex + 2);
+				if (self->has_build_id)
+					goto compare_build_id;
+				break;
 			}
 			self->origin++;
 			/* Fall thru */
@@ -1054,18 +1040,12 @@ more:
 		}
 
 		if (self->has_build_id) {
-			bool match;
-			build_id = malloc(BUILD_ID_SIZE);
-			if (build_id == NULL)
+			if (filename__read_build_id(name, build_id,
+						    sizeof(build_id)) < 0)
 				goto more;
-			berr = filename__read_build_id(name, build_id,
-						       BUILD_ID_SIZE);
 compare_build_id:
-			match = berr > 0 && memcmp(build_id, self->build_id,
-						   sizeof(self->build_id)) == 0;
-			free(build_id);
-			build_id = NULL;
-			if (!match)
+			if (memcmp(build_id, self->build_id,
+				   sizeof(self->build_id)) != 0)
 				goto more;
 		}
 
-- 
1.6.2.5

