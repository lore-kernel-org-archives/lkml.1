Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273Ab0AGWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0AGWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255Ab0AGWA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:00:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:50256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0AGV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:59:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/6] perf buildid-list: No need to process the header sections again
Date: Thu,  7 Jan 2010 19:59:38 -0200
Message-Id: <1262901583-8074-1-git-send-email-acme@infradead.org>
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

As it is already processed by:

	perf_session__new
		perf_session__open
			perf_session__read

This was harmless, because we use dsos__findnew, that would already find
it, but is unnecessary work and removing it makes builtin-buildid-list.c
even shorter.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 1e99ac8..4229c2c 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -31,26 +31,6 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static int perf_file_section__process_buildids(struct perf_file_section *self,
-					       int feat, int fd)
-{
-	if (feat != HEADER_BUILD_ID)
-		return 0;
-
-	if (lseek(fd, self->offset, SEEK_SET) < 0) {
-		pr_warning("Failed to lseek to %Ld offset for buildids!\n",
-			   self->offset);
-		return -1;
-	}
-
-	if (perf_header__read_build_ids(fd, self->offset, self->size)) {
-		pr_warning("Failed to read buildids!\n");
-		return -1;
-	}
-
-	return 0;
-}
-
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
@@ -60,10 +40,7 @@ static int __cmd_buildid_list(void)
 	if (session == NULL)
 		return -1;
 
-	err = perf_header__process_sections(&session->header, session->fd,
-				         perf_file_section__process_buildids);
-	if (err >= 0)
-		dsos__fprintf_buildid(stdout);
+	dsos__fprintf_buildid(stdout);
 
 	perf_session__delete(session);
 	return err;
-- 
1.6.2.5

