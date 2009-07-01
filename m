Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZGATCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZGATCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZGATCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:02:14 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:43599 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZGATCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=b8a5qSJk/aYiwL6w13b96Lq6DjZ7X3LFv1DZAHxhzoHiphQMuu7H7Yaua6H28Y0lHu
         YxiR2wTFr5m+0cvAxzwdLRpZuntu1FupxTDGgCpCa2AOyC8R8FRL7l8rTz7LPW1gKXy9
         s5HU536JUi7S48rIIsQkTis4LpTgYnBAPliYE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] perfcounter: Handle pipe read failures in perf stat
Date: Wed,  1 Jul 2009 21:02:10 +0200
Message-Id: <1246474930-6088-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
References: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building builtin-stat.c reports the following errors:

cc1: warnings being treated as errors
builtin-stat.c: In function ‘run_perf_stat’:
builtin-stat.c:242: erreur: ignoring return value of ‘read’, declared with attribute warn_unused_result
builtin-stat.c:255: erreur: ignoring return value of ‘read’, declared with attribute warn_unused_result
make: *** [builtin-stat.o] Erreur 1

This patch handles the possible pipe read failures.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-stat.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 01cc07e..27921a8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -239,7 +239,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 		/*
 		 * Wait until the parent tells us to go.
 		 */
-		read(go_pipe[0], &buf, 1);
+		if (read(go_pipe[0], &buf, 1) == -1)
+			perror("unable to read pipe");
 
 		execvp(argv[0], (char **)argv);
 
@@ -252,7 +253,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 	 */
 	close(child_ready_pipe[1]);
 	close(go_pipe[0]);
-	read(child_ready_pipe[0], &buf, 1);
+	if (read(child_ready_pipe[0], &buf, 1) == -1)
+		perror("unable to read pipe");
 	close(child_ready_pipe[0]);
 
 	for (counter = 0; counter < nr_counters; counter++)
-- 
1.6.2.3

